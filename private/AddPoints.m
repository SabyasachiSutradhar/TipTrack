function points=AddPoints(bw,kernel,x,y)

    ker = kernel;
    
    % find first point
    points = [ x y ];
    [ dy, dx ] = find( bw(y-1:y+1,x-1:x+1) .* ker > 0, 1 );
    x = x + dx - 2;
    y = y + dy - 2;
    
    % find all conneted middle points
    while bw(y,x) == 2 % run while it is a middle point
      points(end+1,1:2) = [ x y ]; %#ok<AGROW>
      ker = kernel;
%       ker( 4 - dy, 4 - dx ) = 0; % dont find the last point again!
      [ dy, dx ] = find( bw(y-1:y+1,x-1:x+1) .* ker > 0, 1 );
      x = x + dx - 2;
      y = y + dy - 2;
    end
    
    
  
  
end