function [ L_branchPtsPosi,R_branchPtsPosi ] = LateralGrouptobranchpts( L_branchPtsPosi,R_branchPtsPosi,Label_cutlaterals )
% find the lateral root groups that the branching point connected to

num=1;laterallabel=[];
for i=1:length(L_branchPtsPosi(:,1))
    num=1;
    while length(laterallabel)==0 & num<=500
        matrix= Label_cutlaterals(L_branchPtsPosi(i,1)-2:L_branchPtsPosi(i,1)+2,L_branchPtsPosi(i,2)-num:L_branchPtsPosi(i,2));
        for k=1:num+1
            if matrix(1,k)~=0
                laterallabel=matrix(1,k);
            end
        end
        num=num+1;
    end
    if num<=500
        L_branchPtsPosi(i,4)=laterallabel;
    else
        L_branchPtsPosi(i,4)=0;
    end
    L_branchPtsPosi(i,5)=1;
    laterallabel=[];
end

num=1;laterallabel=[];
for i=1:length(R_branchPtsPosi(:,1))
    num=1;
    if R_branchPtsPosi(i,1)~=0
        while length(laterallabel)==0 & num<=900
            matrix= Label_cutlaterals(R_branchPtsPosi(i,1)-2:R_branchPtsPosi(i,1)+2,R_branchPtsPosi(i,2):R_branchPtsPosi(i,2)+num);
            for k=1:num+1
                if matrix(1,k)~=0
                    laterallabel=matrix(1,k);
                end
            end
            num=num+1;
        end
        if num<=900
            R_branchPtsPosi(i,4)=laterallabel;
        else
            R_branchPtsPosi(i,4)=0;
        end
        R_branchPtsPosi(i,5)=2;
        laterallabel=[];
    end
end



