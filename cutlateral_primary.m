function [ Img_cutlateralsandmain,Img_cutlaterals] = cutlateral_primary(Img_cutlaterals,interval,maininterval,im,primskel_prev,branchzoneskel)
%function to separate primary root and laterals roots,and to divide different zone of primary root

cf=[];
[cf] = Dis_skeltocanny(im,primskel_prev,interval);
[a,b]=size(cf);

% separate primary root and laterals roots
cf=sortrows(cf,6);
for i=1:a-1
    Img_cutlaterals = insertShape(Img_cutlaterals,'Line',[cf(i,7),cf(i,6),cf(i+1,7),cf(i+1,6)],'LineWidth',4,'Color', {'black'});
end
cf=sortrows(cf,4);
for i=1:a-1
    Img_cutlaterals = insertShape(Img_cutlaterals,'Line',[cf(i,5),cf(i,4),cf(i+1,5),cf(i+1,4)],'LineWidth',4,'Color', {'black'});
end
Img_cutlateralsandmain=Img_cutlaterals;

% divide different zone of primary root
cf=[];
[cf] = Dis_skeltocanny(im,branchzoneskel,maininterval);
cf=sortrows(cf,2);
[m,n]=size(cf);
for i=1:m
    Img_cutlateralsandmain = insertShape(Img_cutlateralsandmain,'Line',[cf(i,7),cf(i,6),cf(i,5),cf(i,4)],'LineWidth',4,'Color', {'black'});
end
end

