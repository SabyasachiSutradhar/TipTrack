function [fitresult, gof] = Fiterfc(x, y)
    y(isnan(y))=0;
    y=y-min(y(:));
    y=y./max(y(:)); 
    guess1=x(end)/2.0;
    low=[0,0,0,0];
    up=[1.0,x(end),inf,0.25];
    start = [0.5;guess1;2.0;0.1];
    [xData, yData] = prepareCurveData( x, y );   
    %fprintf('%d %d\n',length(xData),length(yData));
    % Set up fittype and options.
    ft = fittype( 'a*erfc((x-b)/c)+d', 'independent', 'x', 'dependent', 'y' );
    opts = fitoptions('Method','NonlinearLeastSquares','Upper',up,'Lower',low,'Display','off','TolFun',10^-16,'TolX',10^-16,'StartPoint',start);
     % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
%     rmax=gof.rsquare;
%    if gof.rsquare<0.975
%        for ii=1:10
%            xp=guess1+ii*(x(end)-guess1)/10;
%            start = [0.5;xp;2.0;0.2];
%               ft = fittype( 'a*erfc((x-b)/c)+d', 'independent', 'x', 'dependent', 'y' );
%               opts = fitoptions('Method','NonlinearLeastSquares','Upper',up,'Lower',low,'Display','off','TolFun',10^-10,'TolX',10^-10,'StartPoint',start);
%  [fit1, g1] = fit( xData, yData, ft, opts );
%  if rmax>g1.rsquare
%      rmax=g1.rsquare;
%      fitresult=fit1;
%      gof=g1;
%  end
%        end
%    end

    
    %    
%     figure
%    plot(fitresult,xData, yData)
%     hold on
%     plot(fitresult.b,fitresult.a+fitresult.d,'*')  
%     hold off
end