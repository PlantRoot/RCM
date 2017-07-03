function [primaryrootarea,lateralrootarea,Label_cutlaterals] =calprimlat_area( Img_cutlaterals )
%function to calculate the total area of primary and lateral roots

thresh=graythresh(Img_cutlaterals);
Img_cutlaterals=im2bw(Img_cutlaterals,thresh);
Img_cutlaterals=bwareaopen(Img_cutlaterals,100);
Label_cutlaterals=bwlabel(Img_cutlaterals);

%find the label of primary root
[row, column]=find(Img_cutlaterals~=0);
cutLaterals  = [row, column];
a=cutLaterals(:,1);
minposition=find(a==min(a));
label_number= Label_cutlaterals(cutLaterals(minposition(1,:),1),cutLaterals(minposition(1,:),2));
[row, column]=find(Label_cutlaterals==label_number);
primartpts  = [row, column];
primaryrootarea=length(primartpts(:,1));
for i=1:length(primartpts)
    Label_cutlaterals(primartpts(i,1),primartpts(i,2))=0;%delete the primary root
end
[row, column]=find(Label_cutlaterals);
lateralpts = [row, column];
lateralrootarea=length(lateralpts(:,1));
end

