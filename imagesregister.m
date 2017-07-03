function imagesregister
global img topmost bottommost leftmost rightmost others standardcol rowcut;

nimages=length(img);
h=mywaitbar(0,'Images registering, please wait ...');
for i=1:nimages
    img(i).img_org_cut=imcrop(img(i).imageorg,[leftmost,topmost,rightmost,bottommost]);
    img(i).img_bw=im2bw(img(i).img_org_cut,0.99);
    img(i).img_bw=bwareaopen(img(i).img_bw,500);
    [r, c] = find(img(i).img_bw == 1);
    ir=min(r);ic=min(c);
    tr=max(r);tc=max(c);
    [nr,nc]=size(img(i).img_org_cut);
    img(i).img_cut=imcrop(img(i).img_org_cut,[0,0,tc,nr]);
    img(i).img_cut=imcrop(img(i).img_cut,[ic,ir,tc,nr]);
    
    [row,col,n]=size(img(i).img_cut);
    img(i).img_cut=imresize(img(i).img_cut,[row/col*standardcol ,standardcol]);
    [row,col,n]=size(img(i).img_cut);
    if row<rowcut
        rowcut=row;
    end
    mywaitbar(i/nimages);
end

for i=1:nimages
    img(i).imagereg=imcrop(img(i).img_cut,[0,0,standardcol,rowcut]);
    img(i).image=img(i).imagereg;
end

close(h);
imagedraw(others.cimage);
return