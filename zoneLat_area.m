function [branch_meanarea] = zoneLat_area(label_branchPtsPosi,branchzoneskel,maininterval,label_area)
%calculate the mean area of lateral root for different primary zones

label_branchPtsPosi=sortrows(label_branchPtsPosi,1);
label_count=tabulate(label_branchPtsPosi(:,4));

L_area=[];
VarNames1={'Label' 'Area'};
L_area=dataset(label_area(:,1),label_area(:,2),'VarNames',VarNames1);

L_count=[];
VarNames2={'Label' 'Count'};
L_count=dataset(label_count(:,1),label_count(:,2),'VarNames',VarNames2);

labelarea_merge=[];label_meanarea=[];
labelarea_merge = join(L_count,L_area,'key','Label','Type','outer', 'MergeKeys',true);
varnames = get(labelarea_merge,'VarNames');
area=eval(cell2mat(strcat('labelarea_merge.',varnames(3))));
count=eval(cell2mat(strcat('labelarea_merge.',varnames(2))));

label_meanarea(:,1)=eval(cell2mat(strcat('labelarea_merge.',varnames(1))));
label_meanarea(:,2)= area./count;

L_branch=[];
VarNames3={'X' 'Y' 'Label' 'Side'};
L_branch=dataset(label_branchPtsPosi(:,1),label_branchPtsPosi(:,2),label_branchPtsPosi(:,4),label_branchPtsPosi(:,5),'VarNames',VarNames3);
L_meanarea=[];
VarNames4={'Label' 'Area'};
L_meanarea=dataset(label_meanarea(:,1),label_meanarea(:,2),'VarNames',VarNames4);
branch_meanarea_merge=[];
branch_meanarea_merge = join(L_branch,L_meanarea,'key','Label','Type','outer', 'MergeKeys',true);

[row col] = size(branch_meanarea_merge);
varnames = get(branch_meanarea_merge,'VarNames');
branch_meanarea=[];
for n=1:col
    branch_meanarea(:,n)=eval(cell2mat(strcat('branch_meanarea_merge.',varnames(n))));
end

branchzoneskel=sortrows(branchzoneskel,1);
X_corrdinate=branchzoneskel(:,1);
equal_dis_X=X_corrdinate(1:maininterval:length(X_corrdinate));
for i=1:row
    X=branch_meanarea(i,1);
    for j=1:length(equal_dis_X)-1
        Xmin=equal_dis_X(j);
        Xmax=equal_dis_X(j+1);
        if  Xmin<X & X<Xmax
            branch_meanarea(i,6)=j;
        end
    end
end