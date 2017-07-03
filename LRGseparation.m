function LRGseparation
%lateral root groups separation for sequence images
global img others;

nimages=length(img);
img_pre=img(nimages).image;
thresh=graythresh(img_pre);
img_pre=im2bw(img_pre,thresh);
img_pre=~img_pre;

h=mywaitbar(0,'Images processing, please wait ...');
for i=1:nimages
    im=img(i).img_bw;
    skelImg  = bwmorph(im,'thin',Inf);
    skelImg(1:30,:)=0;
    branchImg = bwmorph(skelImg, 'branchpoints');
    [row, column] = find(branchImg);
    branchPts     = [row column];
    [Branchrow,Branchcol]=size(branchPts);
    if Branchrow>1
        img(i).img_cutroot=img(i).img_bw - img_pre;
        img(i).img_cutroot(img(i).img_cutroot<0)=0;
    else
        img(i).img_cutroot=img(i).img_bw ;
    end
    img(i).image=img(i).img_cutroot;
    mywaitbar(i/nimages);
end
close(h);
imagedraw(others.cimage)
return