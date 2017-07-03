function L=deletelabel(L,label)
%function to remove the already identified root segments from the image

[r,c]=find(L==label);
label_coordinate=[r,c];
for i=1:length(label_coordinate)
    L(label_coordinate(i,1),label_coordinate(i,2))=0;
end