function XS=fit_beziersmoothing(x,y,maxdis,N)

Mat=[x(:) y(:)];
ei= length(x);
ibi=[1;ei];
[p0mat,p1mat,p2mat,p3mat,fbi]=bzapproxu(Mat,maxdis,ibi);  
[MatI]=BezierInterpCPMatSegVec(p0mat,p1mat,p2mat,p3mat,fbi);

n=length(MatI);
t=1:n;
ts=linspace(1,n,N);
xs=spline(t,MatI(:,1),ts);
ys=spline(t,MatI(:,2),ts);
XS=[xs(:) ys(:)];
end


