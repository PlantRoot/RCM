function [farthestPts_row,farthestPts_col,lateralnumber]=find_farthestPts(L,label,branchPts,minposition,endPts)
%find the farthest endpoint of the root segment
%determine whether the root segment is an individual first-order laterals

end_endImg    = bwmorph(L==label, 'endpoints');
[row, column] = find(end_endImg);
label_endPts=[row, column];

%find the farthest endpoint of the root segment
for i =1:2
    a_distance(i)=norm(label_endPts(i,:)-branchPts(minposition,:));
end
adis=a_distance';
max_aposition=find(adis==max(adis));
farthestPts_row=label_endPts(max_aposition,1);
farthestPts_col=label_endPts(max_aposition,2);

%determine whether the root segment is an individual first-order laterals
for i =1:length(endPts(:,1))
    b_distance(i)=norm(label_endPts(max_aposition,:)-endPts(i,:));
end
if min(b_distance)==0
    lateralnumber=1;%tag as an individual first-order laterals
else
    lateralnumber=2;
end
