function bww=Remove_SmallBranch(bw,threshold)

br=bwmorph(bw,'branchpoints');
n=sum(br(:)==1);
if n>0
brdil=imdilate(br,strel('square',3));
bwdil=bw-brdil;

cc = bwconncomp(imbinarize(bwdil),8); 
stats = regionprops(cc, 'Area'); 
idx = find([stats.Area] >=threshold); 
bw2 = ismember(labelmatrix(cc), idx);
bww=bw2+br;
bww=bwmorph(bww,'bridge');
bww=bwmorph(bww,'close');
else
    bww=bw;
end
end
