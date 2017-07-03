function imagedraw(n)
global hslider img  others;

imagesc(img(n).image);
axis tight
axis equal
axis off
set(hslider,'value',n);
return