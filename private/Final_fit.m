function centers=Final_fit(centersi)
    centerso =fit_smoothingspline(centersi(:,1),centersi(:,2),10*length(centersi),0.15);
    xt=centerso(:,1);yt=centerso(:,2);
    dis=cumsum(sqrt(diff(xt).^2+diff(yt).^2));
    arc_distance=dis(end);
    end_distance=sqrt((xt(end)-xt(1))^2+(yt(end)-yt(1))^2);

    w=1.0-end_distance/arc_distance;
    if w<0.1
        w=0.1;
    elseif w>0.9
        w=0.9;
    end

    centers =fit_smoothingspline(centerso(:,1),centerso(:,2),10*length(centerso),w);
end
