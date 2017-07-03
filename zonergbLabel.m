function zonergbLabel
global img rgbLabel maininterval;

nimages=length(img);
imwrite(img(nimages).img_bw,'A.jpg');
Img_cutlaterals=imread('A.jpg');
thresh=graythresh(Img_cutlaterals);
im=im2bw(Img_cutlaterals,thresh);
interval=10;

primskel_prev=img(nimages).priskel;
branchzoneskel=img(nimages).branchzonekel;
[Img_cutlateralsandmain,Img_cutlaterals] = cutlateral_primary(Img_cutlaterals,interval,maininterval,im,primskel_prev,branchzoneskel);

thresh=graythresh(Img_cutlateralsandmain);
Img_cutlateralsandmain=im2bw(Img_cutlateralsandmain,thresh);
Img_cutlateralsandmain=bwareaopen(Img_cutlateralsandmain,100);

Img_cutlateralsandmain=bwlabel(Img_cutlateralsandmain);
rgbLabel = label2rgb(Img_cutlateralsandmain,'lines');
return
