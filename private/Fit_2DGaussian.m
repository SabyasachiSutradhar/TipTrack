function [Center,sigma]=Fit_2DGaussian(I,thetaguess)
im=I;
[X,Y]=meshgrid(1:size(im,2),1:size(im,1));
max_X=max(X(:));
max_Y=max(Y(:));
Z=double(im);
Z(isnan(Z))=0;
Z=Z-min(Z(:));
Z=Z./max(Z(:));

[xData, yData, zData] = prepareSurfaceData(X,Y, Z);

% Set up fittype and options.
ft = fittype( 'I0*exp(-(-(x-xc).*sin(theta)+(y-yc).*cos(theta)).^2./(2.0*sigmav^2))+d',...
    'independent', {'x', 'y'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Lower = [0 0 0 0 1 1];
opts.Upper = [1 0.25 10 2*pi  max_X max_Y];
opts.StartPoint = [0.75  0.0 3.0 thetaguess  max_X/2 max_Y/2];
% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

xx=(1:size(I,2))';
yy=tan(fitresult.theta-pi).*(xx-fitresult.xc)+fitresult.yc;
if min(yy)<1 || max(yy(:))>size(I,1)
yy=(1:size(I,1))';
xx=(yy-fitresult.yc)./tan(fitresult.theta-pi)+fitresult.xc;
end

Center=[xx,yy];
sigma=fitresult.sigmav*ones(length(xx),1);
%%%%%%%%%%%%%%%%%%% 
% Zout=fitresult(X,Y);
% figure
% imshow(imadjust(Zout))
% hold on
% plot(xx,yy,'-*')
end