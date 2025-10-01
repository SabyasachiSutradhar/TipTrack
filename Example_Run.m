%% Set some initial paths %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%addpath(genpath(trackdir));
filename='Example_Data/Static_Movie300-1.tif';
logdir='Example_Data';
%% SET PARAMETERS
params.filter_box_size=11;%%box size for filtering your image in pixel
params.threshold_branchlength=3;%%remove branch less than this threshold length in pixels
params.areathreshold=100;%%%%%%%% remove detected object less than this threshold area(pixels)
%% TRACKING your tip
close all
Tip=Scan_Video(filename,params,logdir);
%% Save tip length for all frames (in pixels unit)
for ii=1:numel(Tip{1})
    Tiplength(ii,1)=Tip{1}(ii).length;
end
histogram(Tiplength,'BinWidth',0.1)
xlabel('Tip length in pixel')
ylabel ('Counts')
saveas(gcf,'Tiplength_Distribution.png')
save Analysis