function imagecrop
global img topmost bottommost leftmost rightmost standardcol rowcut;

[row,col,n]=size(img(1).imageorg);
bottommost=row-bottommost;
rightmost=col-rightmost;

nimages=length(img);
img(nimages).imagecrop=imcrop(img(nimages).imageorg,[leftmost,topmost,rightmost,bottommost]);
imagesc(img(nimages).imagecrop);
axis tight
axis equal
axis off

img(nimages).img_bw=im2bw(img(nimages).imagecrop,0.99);
img(nimages).img_bw=bwareaopen(img(nimages).img_bw,500);
[r, c] = find(img(nimages).img_bw == 1);
ir=min(r);ic=min(c);
tr=max(r);tc=max(c);
[nr,nc]=size(img(nimages).imagecrop);
img(nimages).img_cut=imcrop(img(nimages).imagecrop,[0,0,tc,nr]);
img(nimages).img_cut=imcrop(img(nimages).img_cut,[ic,ir,tc,nr]);
[row,col,n]=size(img(nimages).img_cut);
standardcol=col;
rowcut=100000;
return