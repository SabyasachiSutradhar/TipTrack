function object=Scan_Image(BW,IBG,params)
global pic  inner_extp_length pad
reg_pad=15;

object.xy={};
object.tip={};
object.sigv={};
object.sigp={};
object.length=0/0;

BW_stat=regionprops(BW,'Area','BoundingBox');

x=ceil(BW_stat.BoundingBox(2)); dx=BW_stat.BoundingBox(4);
y=ceil(BW_stat.BoundingBox(1)); dy=BW_stat.BoundingBox(3);
bww=BW(x-reg_pad+1:x+dx+reg_pad,y-reg_pad+1:y+dy+reg_pad);
bw = imclearborder(bww);

%IBG=IBG;
pic=IBG(x-reg_pad+1:x+dx+reg_pad,y-reg_pad+1:y+dy+reg_pad);
skel=bwmorph(bw,'skel',inf);
skel=bwmorph(skel,'spur',3);
skel=imdilate(skel,strel('disk',1,0));
skel=bwmorph(skel,'thin',inf);
skel=Remove_SmallBranch(skel,3);



if (bwarea(skel)>=2)
    obj=skel_coordinates(skel);
    inner_extp_length=3;
    obj=find_tip_centerline(obj);

    for j=1:obj.n_tip
        obj.centerfilt{j} =fit_smoothingspline(obj.center{j}(:,1),obj.center{j}(:,2));
        xt=obj.centerfilt{j}(:,1);yt=obj.centerfilt{j}(:,2);
        distance=cumsum(sqrt(diff(xt).^2+diff(yt).^2));
        obj.length(j,1) =distance(end);
        clear var xt yt
    end


    for j=obj.n_tip+1:obj.n_tip+obj.n_branch
        obj.centerfilt{j} =fit_smoothingspline(obj.center{j}(:,1),obj.center{j}(:,2));
        xb=obj.centerfilt{j}(:,1);yb=obj.centerfilt{j}(:,2);
        distance=cumsum(sqrt(diff(xb).^2+diff(yb).^2));
        obj.length(j,1) =distance(end);
        clear var xb yb
    end

    for kk=1:length(obj.skelsmooth)
        obj.skel{kk}(:,1)=obj.skel{kk}(:,1)+y-reg_pad-pad;
        obj.skel{kk}(:,2)=obj.skel{kk}(:,2)+x-reg_pad-pad;
        obj.skelsmooth{kk}(:,1)=obj.skelsmooth{kk}(:,1)+y-reg_pad-pad;
        obj.skelsmooth{kk}(:,2)=obj.skelsmooth{kk}(:,2)+x-reg_pad-pad;
        obj.center{kk}(:,1)=obj.center{kk}(:,1)+y-reg_pad-pad;
        obj.center{kk}(:,2)=obj.center{kk}(:,2)+x-reg_pad-pad;
        obj.centerfilt{kk}(:,1)=obj.centerfilt{kk}(:,1)+y-reg_pad-pad;
        obj.centerfilt{kk}(:,2)=obj.centerfilt{kk}(:,2)+x-reg_pad-pad;
        obj.tip{kk}(:,1)=obj.tip{kk}(:,1)+y-reg_pad-pad;
        obj.tip{kk}(:,2)=obj.tip{kk}(:,2)+x-reg_pad-pad;
    end
    object.xy=obj.centerfilt;
    object.tip=obj.tip;
    object.sigv=obj.sig;
    object.sigp=obj.tipendsig;
    object.length=obj.length;

end

end
