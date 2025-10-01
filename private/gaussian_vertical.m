function [x,y,sigma]=gaussian_vertical(xi,yi,width)
global pic;

xi=xi(:);
yi=yi(:);
k=0;
x=[];
y=[];
sigma=[];

N=length(xi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%
dis=cumsum(sqrt(diff(xi).^2+diff(yi).^2));
arc_distance=dis(end);
end_distance=sqrt((xi(end)-xi(1))^2+(yi(end)-yi(1))^2);
w=end_distance/arc_distance;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dx=3;
for i=1:dx:N-dx
    x1=xi(i);y1=yi(i);
    x2=xi(i+dx);y2=yi(i+dx);

    dis=sqrt((x2-x1)^2+(y2-y1)^2);
    u1=(x2-x1)/dis;u2=(y2-y1)/dis;%unit vec in parallel
    xin=xi(i:i+dx);
    yin=yi(i:i+dx);
    DX=ceil(abs(x2-x1));
    DY=ceil(abs(y2-y1));

    if DX>DY
        xmin=ceil(min(x1,x2));
        xmax=xmin+dx;
        ymin=ceil(min(y1-width/2,y1+width/2));
        ymax=ymin+width;  
    else
        xmin=ceil(min(x1-width/2,x1+width/2));
        xmax=xmin+width;
        ymin=ceil(min(y1,y2));
        ymax=ymin+dx;
    end
    im=pic(xmin:xmax-1,ymin:ymax-1);
    %%%%%%%%%%%%% cut a box around the point %%%%%%%%%%%%%%%%%%%%%%
    thetag=wrap_angle(atan2(u2,u1));
    [Center,sigmav]=Fit_2DGaussian(im,thetag);
    xx=Center(:,2)+xmin-1;
    yy=Center(:,1)+ymin-1;
    x=vertcat(x,xx);
    y=vertcat(y,yy);
    sigma=vertcat(sigma,sigmav);
end

XP=fit_smoothingspline(x,y);
XS=curvspace(XP,length(x));
x=XS(:,1);
y=XS(:,2);

end




