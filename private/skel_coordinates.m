%%Function to return the coordinates of the skeletonized image
function obj=skel_coordinates(bw)
    smoothingparam=0.95;
    ends=bwmorph(bw,'endpoints');
    n_end=sum(ends(:)==1);
%     fprintf('number of end points=%d\n',n_end);
    [endx,endy]=find(ends==1);
    obj.ends(:,1)=endx;obj.ends(:,2)=endy;
    branchpoints=bwmorph(bw,'branchpoints');
    n_branchpoint=sum(branchpoints(:)==1);
%     fprintf('number of branch points=%d\n',n_branchpoint);
    if n_branchpoint~=0
        [brx,bry]=find(branchpoints==1);
        obj.brpts(:,1)=brx;obj.brpts(:,2)=bry;
        bdil=imdilate(branchpoints,strel('square',3));
        bwdil=bw-bdil;
        bwdil=imbinarize(bwdil);
        n_branch=n_branchpoint-1;
        n_tip=n_end;
        n_total=n_branch+n_end;
        cc=bwconncomp(bwdil);
    else
        bwdil=imbinarize(double(bw));
        cc=bwconncomp(bwdil); %% if there is no branchpoint
        n_branch=0;
        n_tip=n_end-1;
        n_total=n_tip;
    end
    %     stats=regionprops(cc,'Area','PixelList');
    pic_tips=zeros(size(bw));
    warning off
    k=0;
    for ii=1:n_tip
        k=k+1;
        tpic = bwselect(bwdil,endy(ii),endx(ii),8);
        pic_tips=pic_tips+tpic;
        tpic=tpic+branchpoints;
        tpic=bwmorph(tpic,'bridge');
        tpic=bwmorph(tpic,'close');
        tpic=bwmorph(tpic,'thin','inf');
        chain=create_chain(tpic);
        skel_coor{k}=chain;    
         skel_coorsmooth{k}=fit_smoothingspline(skel_coor{k}(:,1),skel_coor{k}(:,2));
%           skel_coorsmooth{k}=fit_Poly(skel_coor{k}(:,1),skel_coor{k}(:,2));
%          plot(skel_coor{k}(:,1),skel_coor{k}(:,2),'.-')
%          plot(skel_coorsmooth{k}(:,1),skel_coorsmooth{k}(:,2),'or')
        obj.type(k)=1;
        clear var statt
    end
    pic_br=imbinarize(bwdil-pic_tips);
    cc = bwconncomp(pic_br);
    for i=1:n_branch
        k=k+1;
        brpic = ismember(labelmatrix(cc), i);
        brpic=brpic+branchpoints;
        brpic=bwmorph(brpic,'bridge');
        brpic=bwmorph(brpic,'close');
        brpic=bwmorph(brpic,'thin','inf');
        chain=create_chain(brpic);
        skel_coor{k}=chain;
         skel_coorsmooth{k}=fit_smoothingspline(skel_coor{k}(:,1),skel_coor{k}(:,2));
%         plot(skel_coor{k}(:,1),skel_coor{k}(:,2),'.-')
%           plot(skel_coorsmooth{k}(:,1),skel_coorsmooth{k}(:,2),'or')
        obj.type(k)=2;
        clear var statb
    end
    
    obj.n_end=n_end;
    obj.n_branch=n_branch;
    obj.n_branchpoint=n_branchpoint;
    obj.n_tip=n_tip;
    obj_n_total=n_total;
    obj.skel=skel_coor;
    obj.skelsmooth=skel_coorsmooth;

end