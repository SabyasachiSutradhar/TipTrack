function [BW,BG] = make_binary(I,params)
  nonzero_im=I~=0;
    Ic=(I==0);
    inz=I;
    inz(inz==0)=0/0;
    pd=fitdist(inz(:),'Normal');
    Ig=normrnd(pd.mu,0.25*pd.sigma,size(I));
    In=I+Ic.*Ig;  
    In=imadjust(In);

    J = wiener2(In,[5 5]);
    im=im2double(J);
    im=im/max(im(:));
    im=imgaussfilt(im,1);
    ws= params.filter_box_size;
    %BG=imsubtract(im,imfilter(im,fspecial('average',ws),'replicate'));
%     BG=imsubtract(im,medfilt2(im,[ws,ws]));
    
    pd=fitdist(im(:),'Normal');
    im(im<=0)=0/0;
    BG=im-pd.mu;
    BG(isnan(BG))=0;
    BG(BG<0)=0;
    level = graythresh(BG);
    BW=imbinarize(BG,level);
    BW=bwareaopen(BW,params.areathreshold); %%remove small unwanted areas
%     im1=imgaussfilt(double(BW),1); %smooth rough edges
%     BW = imbinarize(im1,graythresh(im1));
    BW=bwmorph(BW,'bridge',1);
    BW=bwmorph(BW,'fill');
    BW=bwmorph(BW,'close');
    BW=bwmorph(BW,'majority',1);
    BW=bwmorph(BW,'spur',inf);
    BW=bwmorph(BW,'clean');
    BW=BW.*nonzero_im;
end
