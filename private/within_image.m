function val=within_image(x,y)
    global pic;
    val=0;
    if x>=1 && y>=1
        if x<=size(pic,1) && y<=size(pic,2)
            val=1;
        end
    end
end