function outfile=Scan_Video(infile,params,logdir)
    %% Name of the Movie
    start=clock;
    info=imfinfo(infile);
    n_frame=numel(info);
    [~,name,~] = fileparts(infile);
    if endsWith(logdir,filesep)
    fid=fopen(strcat(logdir,name,'.log'),'w');
    else
        fid=fopen(strcat(logdir,filesep,name,'.log'),'w');
    end
    %% run all images in the tiff stack
    global regions  nextRegId  mask frame pad 
    pad=30;
    regions = initializeRegions(); % Create an empty array of tracks.
    nextRegId = 1; % ID of the next Obj
    
    for i=1:n_frame
        %fprintf('Processing file %d frame %d at %0.2f seconds\n',in,ii,etime( clock, start));
        %fprintf(fid{in},'Processing file %d frame %d at %0.2f seconds\n',in,ii,etime( clock, start));
        fprintf(fid,'Processing file %s frame %d at %0.2f seconds\n',name,i,etime( clock, start));
        
        frame=padarray(im2double(imread(infile,i)),[pad,pad],0,'both');
        %BG=frame;
        BG=imsubtract(frame,imfilter(frame,fspecial('average',11),'replicate')-imfilter(frame,fspecial('average',3),'replicate'));
        %BG=imsubtract(frame,medfilt2(frame,[5,5]));
        %BG=imsubtract(frame,imgaussfilt(frame,11)-imgaussfilt(frame,3));
        %BG=imsubtract(frame,imopen(frame,strel('disk',5)));
        %BG(BG<0)=0;
   
    
        %%%%%%%%%   Use kalman filter to label regions
        DetectAndLabelRegions(frame,params) ;

        n_regions=length(regions);
       %fprintf('n regions= %d\n',n_regions);
        if n_regions>=1
        for j=1:n_regions
            BW1=zeros(size(mask));
            BW1(regions(j).PixelIdxList) = 1;
            try
                Object{j}(i,1)=Scan_Image(BW1,BG,params);
            catch
                Object{j}(i,1).xy={};
                Object{j}(i,1).tip={};
                Object{j}(i,1).length=0/0;
                 Object{j}(i,1).sigv=0/0;
                  Object{j}(i,1).sigp=0/0;
                fprintf(fid,'%s frame %d skipped...\n',name,i);
                continue;
            end
        end
        else
                Object{j}(1).xy={};
                Object{j}(1).tip={};
                Object{1}(1).length=0/0;
                Object{j}(1).sigv=0/0;
                Object{j}(1).sigp=0/0;
        end
    end
    outfile=Object;
    fprintf(fid,'Proseccing FINISHED..... scanning took %0.2f seconds\n', etime(clock,start));
    fclose(fid);
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function DetectAndLabelRegions(frame,params)  
    global  regions nextRegId Rcentroids Rbboxes Rpixelidx mask assignments unassignedRegions unassignedDetections 

[Rcentroids, Rbboxes, Rpixelidx,mask] = detectRegions(frame,params);
   
    predictNewLocationsOfRegion();
    
    [assignments, unassignedRegions, unassignedDetections] = detectionToRegionAssignment();
    
    updateAssignedRegion();
    updateUnassignedRegion();
   createNewRegion();
   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Rcentroids, Rbboxes, Rpixelidx, mask] = detectRegions(frame,params)
    mask=make_binary(frame,params);
    cc = bwconncomp(mask); 
    s=regionprops(cc,'Centroid','BoundingBox','PixelIdxList');
  
    for i=1:numel(s)
        Rcentroids(i,:)=s(i).Centroid;
        Rbboxes(i,:)=s(i).BoundingBox;
        Rpixelidx{i}=s(i).PixelIdxList;
    end
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function predictNewLocationsOfRegion()
    global regions
    for i = 1:length(regions)
        bbox = regions(i).bbox;        
        % Predict the current location of the track.
        predictedCentroid = predict(regions(i).kalmanFilter);
        
        % Shift the bounding box so that its center is at
        % the predicted location.
        predictedCentroid = int16(predictedCentroid) -int16(bbox(3:4)) / 2;
        regions(i).bbox = [predictedCentroid, bbox(3:4)];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [assignments, unassignedRegions, unassignedDetections] =  detectionToRegionAssignment()
    global regions Rcentroids
   nRegions = length(regions);
    nDetections = size(Rcentroids, 1);
    
    % Compute the cost of assigning each detection to each track.
    cost = zeros(nRegions, nDetections);
    for i = 1:nRegions
        cost(i, :) = distance(regions(i).kalmanFilter, Rcentroids);
    end
    
    % Solve the assignment problem.
    costOfNonAssignment = 20;
    [assignments, unassignedRegions, unassignedDetections] =  assignDetectionsToTracks(cost, costOfNonAssignment);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function updateAssignedRegion()
    global  regions Rcentroids Rbboxes assignments Rpixelidx
    numAssignedRegions = size(assignments, 1);
    for i = 1:numAssignedRegions
        regIdx = assignments(i, 1);
        detectionIdx = assignments(i, 2);
        centroid = Rcentroids(detectionIdx, :);
        bbox = Rbboxes(detectionIdx, :);
        pixellist=Rpixelidx{detectionIdx};
        % Correct the estimate of the object's location
        % using the new detection.
        correct(regions(regIdx).kalmanFilter, centroid);
        
        % Replace predicted centroid with detected
        % bounding box.
        
        regions(regIdx).centroid = centroid;
        
        % Replace predicted bounding box with detected
        % bounding box.
        regions(regIdx).bbox = bbox;
        % Replace predicted bounding box with detected
        % pixel list
        regions(regIdx).PixelIdxList = pixellist;
        
        % Update track's age.
        regions(regIdx).age = regions(regIdx).age + 1;
        
        % Update visibility.
        regions(regIdx).totalVisibleCount = ...
            regions(regIdx).totalVisibleCount + 1;
        regions(regIdx).consecutiveInvisibleCount = 0;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function updateUnassignedRegion()
    global  unassignedRegions regions
    for i = 1:length(unassignedRegions)
        ind = unassignedRegions(i);
        regions(ind).age = regions(ind).age + 1;
        regions(ind).consecutiveInvisibleCount = ...
        regions(ind).consecutiveInvisibleCount + 1;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function createNewRegion()
    global   regions nextRegId Rcentroids Rbboxes  unassignedDetections Rpixelidx
    Rcentroids = Rcentroids(unassignedDetections, :);
    Rbboxes = Rbboxes(unassignedDetections, :);
    
    for i = 1:size(Rcentroids, 1)
        
        centroid = Rcentroids(i,:);
        bbox = Rbboxes(i, :);
        pixellist=Rpixelidx{i};
        % Create a Kalman filter object.
        kalmanFilter = configureKalmanFilter('ConstantVelocity',centroid, [10, 10], [10, 5], 10);
        
        % Create a new track.
        newReg = struct(...
            'id', nextRegId, ...
            'centroid',centroid,...
            'bbox', bbox, ...
            'PixelIdxList',pixellist,...
            'kalmanFilter', kalmanFilter, ...
            'age', 1, ...
            'totalVisibleCount', 1, ...
            'consecutiveInvisibleCount', 0);
        
        % Add it to the array of tracks.
        regions(end + 1) = newReg;
        
        % Increment the next id.
        nextRegId = nextRegId + 1;
    end
end

function regions = initializeRegions()
        % create an empty array of tracks
        % Create a new track.
        regions = struct(...
            'id', {}, ...
            'centroid',{},...
            'bbox',{}, ...
            'PixelIdxList',{},...
            'kalmanFilter', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'consecutiveInvisibleCount', {});
    end