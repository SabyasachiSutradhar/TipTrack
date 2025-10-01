function [Xout,theta,sigmav,sigmap]=FitTip_2DNew(I,thetaguess,xlast,ylast)
%%
[X,Y]=meshgrid(1:size(I,2),1:size(I,1));
max_X=max(X(:));
max_Y=max(Y(:));
Z=double(I);
Z(isnan(Z))=0;
Z=Z-min(Z(:));
Z=Z./max(Z(:));
[xData, yData, zData] = prepareSurfaceData(X,Y, Z);
% Set up fittype and options.
ft = fittype( 'H*exp(-(-(x-xc).*sin(theta)+(y-yc).*cos(theta)).^2./(2.0*sigmav^2)).*erfc(((x-xc)*cos(theta)+(y-yc)*sin(theta))./sigmap)+d',...
    'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0 0 0 0 1 1];
opts.Upper = [1  0.25 inf inf 2*pi  max_X max_Y];
opts.MaxIter = 800;
opts.StartPoint = [0.75 0.1 3.0 5.0 thetaguess max_X/2 max_Y/2];
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% %%% first point is the tip
k=1;
xt(k,1)=fitresult.xc;
yt(k,1)=fitresult.yc;
dis=sqrt((xlast-xt(1))^2+(ylast-yt(1))^2);
d=0;
%%%% length increment to the end of the images
while  d<dis
    k=k+1;
    xt(k,1)=xt(k-1,1)+cos(fitresult.theta-pi);
    yt(k,1)=yt(k-1,1)+sin(fitresult.theta-pi);
    d=d+sqrt((xt(k-1)-xt(k))^2+(yt(k-1)-yt(k))^2);
end

xtt=flipud(xt);
ytt=flipud(yt);
% plot(xtt,ytt,'.-r')
Xout=[xtt,ytt];
theta=fitresult.theta;
sigmap=fitresult.sigmap;
sigmav=ones(length(xtt),1).*fitresult.sigmav;
% figure
% Iout=fitresult(X,Y);
% imshow(Iout,[])
% hold on
% plot(xt,yt,'or')
end
