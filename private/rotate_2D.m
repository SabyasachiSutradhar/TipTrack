function [xr,yr]=rotate_2D(theta,x,y,xc,yc)
    x=x(:)-xc;
    y=y(:)-yc;
    R=[cos(theta) sin(theta);-sin(theta) cos(theta)];
    X=[x,y];
    XR=X*R;
    xr=XR(:,1);
    yr=XR(:,2);    
    xr=xr+xc;
    yr=yr+yc;
end
    
    
    