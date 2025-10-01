function [xr,yr]=correct_extp_width(x,y,width,u1,u2,x1,y1,dx)
    val=within_image(y,x);
    w=width;
    if val==1
        xr=x;yr=y;
    else
        %fprintf('%d %d xq=%f yx=%f %d\n',size(pic,1),size(pic,2),xq(2),yq(2),val)
        while val==0
            w=w-dx;
            xr=x1+w*u1;
            yr=y1+w*u2;
            val=within_image(yr,xr);
            %fprintf('%f\n',outer_extp_length)
        end
    end
end

%[xq(2),yq(2)]=correct_extp_width(xq(2),yq(2),width,u1,u2,x1,y1,0.1);