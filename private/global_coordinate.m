function xyfinalg=global_coordinate(obj,reg_pad,x,y)
    global pad
 for j=1:length(obj.xyfinal)
    xyfinalg{j}(:,1)=obj.xyfinalgauss{j}(:,1)+y-reg_pad-pad;
    xyfinalg{j}(:,2)=obj.xyfinalgauss{j}(:,2)+x-reg_pad-pad;
 end

end