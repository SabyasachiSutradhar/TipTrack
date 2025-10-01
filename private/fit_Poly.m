function XS=fit_Poly(x,y)

     n=length(x);
     X =  curvspace([x(:),y(:)],n);
    x=X(:,1);
    y=X(:,2);
    [x,y]=prepareCurveData(x,y);

    t=(1:n)';
    fx = polyfit(t(:), x(:),6);
    fy = polyfit(t(:), y(:),6);

    xp=polyval(fx,t);
    yp=polyval(fy,t);

   XS =  curvspace([xp(:),yp(:)],n);
 
end