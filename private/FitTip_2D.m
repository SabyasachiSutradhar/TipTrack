function [xtip,ytip,theta,sigma]=FitTip_2D(X,Y,Z,guess)
    Z=double(Z);
    Z(isnan(Z))=0;
    Z=Z-min(Z(:));
    Z=Z./max(Z(:));
    %     [Xq,Yq]=meshgrid(0:0.25:size(X)-1,0:0.25:size(Y)-1);
    %     Zq = interp2(X,Y,Z,Xq,Yq);
    [xData, yData, zData] = prepareSurfaceData(X,Y, Z);
    
    % Set up fittype and options.
    ft = fittype( 'H*exp(-(-(x-xc).*sin(theta)+(y-yc).*cos(theta)).^2./(2.0*sigmav^2)).*erfc(((x-xc)*cos(theta)+(y-yc)*sin(theta))./sigmap)+d', 'independent', {'x', 'y'}, 'dependent', 'z' );
    %ft = fittype( 'H*exp(-(-(y-yc).*sin(theta)+(x-xc).*cos(theta)).^2./(2*sigmav^2)).*erfc(((y-yc)*cos(theta)+(x-xc)*sin(theta))./sigmap)+d', 'independent', {'x', 'y'}, 'dependent', 'z' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [0 0 0 0 0 guess.tipx-3 guess.tipy-3];
    opts.MaxIter = 800;
    opts.StartPoint = [0.75 0.1 guess.sigmap guess.sigmav guess.theta guess.tipx guess.tipy];
    opts.Upper = [1  0.5 inf inf 2*pi  guess.tipx+3 guess.tipy+3];
    % Fit model to data.
    %     fprintf('%%%%%%%%%%%%%%\n')
    [fitresult, gof] = fit( [xData, yData], zData, ft, opts );
    
    % % Plot fit with data.
%           figure
%          surf(X,Y,Z)
%          hold on
%           scatter3(fitresult.xc,fitresult.yc,fitresult(fitresult.xc,fitresult.yc))
%     hold off
    
    xtip=fitresult.xc;
    ytip=fitresult.yc;
    theta=fitresult.theta;
    sigma=fitresult.sigmap;
 
end