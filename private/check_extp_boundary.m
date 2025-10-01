function [x,y]=check_extp_boundary(x,y,p,u1,pic,outer_extp_length)
    x0=x;y0=y;
val=within_image(x,y,pic);
while val==0
   outer_extp_length=outer_extp_length-0.1;
   x=x0+outer_extp_length*u1;
   y=polyval(p,x);
   val=within_image(x,y,pic);  
end
end