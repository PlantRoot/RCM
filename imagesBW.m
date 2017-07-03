function imagesBW
%Image binarization
global img threshvalue others thresh;

h=mywaitbar(0,'Images thresholding, please wait ...');
nimages=length(img);
for i=1:nimages
    mywaitbar(i/nimages);
    [r,c,n]=size(img(i).imagereg);
    if length(str2num(threshvalue))~=0
        thresh=str2num(threshvalue);
    else
        thresh=graythresh(img(i).imagereg)+0.22;
    end
    img(i).img_bw=im2bw(img(i).imagereg,thresh);    
    filled = imfill(img(i).img_bw, 'holes');
    holes = filled & ~img(i).img_bw;
    bigholes = bwareaopen(holes, 5);
    smallholes = holes & ~bigholes;
    img(i).img_bw = img(i).img_bw | smallholes;
    img(i).img_bw=bwareaopen(img(i).img_bw,10000);
    img(i).img_bw(1:500,1:500)=0;
    img(i).img_bw(1:500,c-500:c)=0;% remove the white block
    img(i).image=img(i).img_bw;
end
close(h);
imshow(img(others.cimage).image);
return