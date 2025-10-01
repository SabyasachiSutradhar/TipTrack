function [tip,sigmav,sigmap]=extrapolate_findtip(x,y,boxwidth)
    global pic;

    xx=y(:);yy=x(:);
    XS=Linear_Fit(y,x,length(x));
    xp=XS(:,1);yp=XS(:,2);
    x0=xp(1);y0=yp(1);x1=xp(end);y1=yp(end);
    theta=wrap_angle(atan2(y1-y0,x1-x0));
    
    xe=x1+4*cos(theta);
    ye=y1+4*sin(theta);
    
    cornerx(1)=xe-boxwidth/2;cornerx(2)=xe+boxwidth/2;
    cornery(1)=ye-boxwidth/2;cornery(2)=ye+boxwidth/2;

    cornerx=ceil(cornerx);
    cornery=ceil(cornery);
    %%%%%%%%%%%%% cut a box around the tip %%%%%%%%%%%%%%%%%%%%%%
    xmax=boundary_correction(max(cornerx(:)),size(pic,2));
    xmin=boundary_correction(min(cornerx(:)),size(pic,2));
    ymax=boundary_correction(max(cornery(:)),size(pic,1));
    ymin=boundary_correction(min(cornery(:)),size(pic,1));
    
    Z=pic(ymin:ymax,xmin:xmax);
    %[X,Y]=meshgrid(xmin:xmax,ymin:ymax);
    %[X,Y]=meshgrid(0:size(Z,2)-1,0:size(Z,1)-1);
    
    thetaguess=theta;
    [tip,theta,sigmav,sigmap]=FitTip_2DNew(Z,thetaguess,y1-ymin+1,x1-xmin+1);
    tip(:,1)=tip(:,1)+xmin-1;
    tip(:,2)=tip(:,2)+ymin-1;
%   plot(tip(:,1),tip(:,2),'ob')
end