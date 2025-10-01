function fitresult= Fitgaussian(xx, yy)

x=xx(:);
x=x-x(1);
y=yy(:);
y(isnan(y))=0;
y=y-min(y(:));
y=y./max(y(:));
xm=x(end)/2;

%  fun = @(A)sseval(A,x(:),y(:));
% 
% A0=[1,x(end)/2,3.0,0.01];
% options = optimset('Display','off','MaxIter',1000);
% fitresult = fminsearch(fun,A0,options);



%     low=[0,xm-2,0,0];
%     up=[1,xm+2,100,100];
%     start=[1,x(end)/2,2.0,0.1];
%   
%      ft = fittype( 'a1*exp(-((x-b1)/c1).^2)+d1', 'independent', 'x', 'dependent', 'y' );
%     opts = fitoptions('Method','NonlinearLeastSquares','Upper',up,'Lower',low,'Display','off','StartPoint',start);
%    [fitresult, gof] = fit( x, y, ft, opts );

% 
opt = optimoptions('lsqcurvefit','Display','off');
g = @(A,X) A(1)*exp(-(X-A(2)).^2./(2*A(3)^2));
A0=[1,xm,2.0];
AL=[0,xm-2,0.1];
AU=[1,xm+2,20,];
fitresult = lsqcurvefit(g,A0,x,y,AL,AU,opt);

% figure
% scatter(x,y)
% hold on
% plot(x,g(fitresult,x))
% hold off
end


function sse = sseval(A,xdata,ydata)
sse = sum((ydata -  A(1)*exp(-(xdata-A(2)).^2./(2*A(3)^2))+A(4)).^2);
end