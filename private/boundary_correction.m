function x=boundary_correction(x,L)
   if x<1
       x=1;
   end
   if x>L
       x=L;
   end