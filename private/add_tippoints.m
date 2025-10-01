function XX=add_tippoints(x,y,dis,n)
[x,y]=prepareCurveData(x,y);
yi=y(1);ye=y(end);
th=atan2(ye-yi,x(end)-x(1));
X=[x,y];
R=[cos(th) -sin(th);sin(th) cos(th)];
XR=X*R;
xr=XR(:,1);
yr=XR(:,2);    
p = polyfit( xr, yr,1);
xn=(linspace(xr(end),xr(end)+dis,n))';
yn=polyval(p,xn);
thr=-th;
R=[cos(thr) -sin(thr);sin(thr) cos(thr)];
XRF=[xn,yn];
XS=XRF*R;
XX = unique(XS,'rows');
end