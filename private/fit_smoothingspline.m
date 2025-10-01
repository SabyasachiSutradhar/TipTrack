function XS=fit_smoothingspline(x,y)
n=length(x);
%X =  curvspace([x(:),y(:)],n);
%x=X(:,1);
%y=X(:,2);
x=x(:);
y=y(:);
[x,y]=prepareCurveData(x,y);
t=(1:n)';
% h=1;
% epsilon =h^3/16;
% w=1-1/(1+epsilon*1);
w=0.25;
xp = csaps(t(:), x(:),w,t);
yp = csaps(t(:), y(:),w,t);
XS=[xp(:) yp(:)];
   
end


