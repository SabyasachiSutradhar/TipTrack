function XS=Linear_Fit(x,y,N)
    x=x(:);
    y=y(:);
    n=length(x);
    t=(1:n)';
    px= fit( t, x, 'poly1' );
    py= fit( t, y, 'poly1' );
    ts=linspace(1,n,N)';
    xp=px(ts);
    yp=py(ts);
    XS=[xp(:),yp(:)];
end