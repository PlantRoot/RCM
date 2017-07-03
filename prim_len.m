function [ primskellen ] = prim_len( primskel_prev,im )
%calculate primary root length

primskellen=0;
[m,n]=size(im);
primskel_im=zeros(m,n);
for i=1:length(primskel_prev(:,1))
    primskel_im(primskel_prev(i,1),primskel_prev(i,2))=1;
end
primskel_im=bwlabel(primskel_im);
prim_region = regionprops(primskel_im, {'Perimeter','PixelIdxList'} );
for k=1:numel(prim_region)
    area(k)=prim_region(k).Perimeter/2;
    primskellen=primskellen+area(k);
end
end

