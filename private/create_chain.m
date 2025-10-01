function points=create_chain(bw)
bwdum=bw;
ends=bwmorph(bw,'endpoints');
[endy,endx]=find(ends==1);
 % add first point
 x=endx(1);y=endy(1);
 points=[x y];
%% find all conneted middle points
  while bwdum(y,x)==1
      bwdum(y,x)=0;
      [ dy, dx ] = find( bwdum(y-1:y+1,x-1:x+1)==1 );
      if isempty(dx)
          break
      end
      x = x + dx - 2;
      y = y + dy - 2;
 points(end+1,1:2)=[x y];

    end
    
end