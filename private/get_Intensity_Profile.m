function Intensity=get_Intensity_Profile(xq,yq,dx,n)
    global pic;
    
    dis=sqrt((xq(1)-xq(2))^2+(yq(1)-yq(2))^2);
    %r_dis=round(dis);
    r_dis=4*ceil(dis);
    u(1)=(xq(2)-xq(1))/dis;u(2)=(yq(2)-yq(1))/dis;
    v1(1)=u(2);v1(2)=-u(1);
    v2(1)=-u(2);v2(2)=u(1);

    int0(:,1)=improfile(pic,xq,yq,r_dis);
%     plot(xq,yq,'-','LineWidth',1)
%     scatter(xq(1),yq(1))
    if n>0
    for j=1:n
        x(1)=xq(1)+j*dx*v1(1);x(2)=xq(2)+j*dx*v1(1);
        y(1)=yq(1)+j*dx*v1(2);y(2)=yq(2)+j*dx*v1(2);
        %fprintf('%f %f\n',x,y);
        int1(:,j)=improfile(pic,x,y,r_dis); 
%         plot(x,y,'--','LineWidth',1)
%         scatter(x(1),y(1))
        x(1)=xq(1)+j*dx*v2(1);x(2)=xq(2)+j*dx*v2(1);
        y(1)=yq(1)+j*dx*v2(2);y(2)=yq(2)+j*dx*v2(2);
%         plot(x,y,'--','LineWidth',1)
%         scatter(x(1),y(1))
        %fprintf('%f %f\n',x,y);
        int2(:,j)=improfile(pic,x,y,r_dis); 
        
    end
    int=horzcat(int0,int1,int2);
    Intensity=sum(int,2)/size(int,2);
    %Intensity(isnan(Intensity))=0;
    else
   Intensity=int0;
        %Intensity(isnan(Intensity))=0;
    end
end