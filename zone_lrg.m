function [ LRG_IM,LRG_Pts ] = zone_lrg( Label_cutlaterals,branch_meanarea,plantnumber,label_branchPtsPosi,maininterval)
%normalization of lateral root groups for the same zone of primary root

label=[];LRG=[];
branch_meanarea(isnan(branch_meanarea)==1) = 0;
branch_meanarea=sortrows(branch_meanarea,6);
[r,c]=size(branch_meanarea);
zonecount=branch_meanarea(r,6);
LRG_IM=zeros(1600,1600);
LRG_Pts=[];

for zonenumber=1:zonecount
    zoneposition=find(branch_meanarea(:,6)==zonenumber);
    LRG_label=unique(branch_meanarea(zoneposition,3));
    [m,n]=size(LRG_label);
    if m>=1
        for i=1:m
            matrixLRG=zeros(1600,1600);
            if LRG_label(i)~=0
                label=LRG_label(i);
                posi=find(label_branchPtsPosi(:,4)==label);
                side=unique(label_branchPtsPosi(posi,3));
                if side==2
                    [row, column] = find(Label_cutlaterals==LRG_label(i));
                    LRG = [row column];
                elseif side==1
                    Label_cutlaterals=fliplr(Label_cutlaterals);
                    [row, column] = find(Label_cutlaterals==LRG_label(i));
                    LRG = [row column];
                    Label_cutlaterals=fliplr(Label_cutlaterals);
                end
                
                mincol=min(LRG(:,2));
                LRG(:,2)=LRG(:,2)-mincol+1;
                [rnum,rcol]=size(LRG);
                LRG_basal=[];k=1;
                
                for i=1:rnum
                    if LRG(i,2)<=30
                        LRG_basal(k,:)=LRG(i,:);
                        k=k+1;
                    end
                end
                
                minrowbasal=min(LRG_basal(:,1));
                maxrowbasal=max(LRG_basal(:,1));
                thikness=maxrowbasal-minrowbasal;
                if thikness>=50
                    toprows=find(LRG(:,1)>=minrowbasal&LRG(:,1)<=minrowbasal+30);
                    topleftposition=min(LRG(toprows,2));
                    downrows=find(LRG(:,1)>=maxrowbasal-30&LRG(:,1)<=maxrowbasal);
                    downleftposition=min(LRG(downrows,2));
                    midleftposition=round((topleftposition+downleftposition)/2);
                    LRG(:,2)=LRG(:,2)-midleftposition+50;
                else
                    LRG(:,2)=LRG(:,2)+50;
                end
                
                shift=floor(thikness/2);
                LRG(:,1)=LRG(:,1)-minrowbasal+1-shift+maininterval*zonenumber;
                for i=1:length(LRG(:,1))
                    matrixLRG(LRG(i,1),LRG(i,2))=1;
                end
                
                LRG_IM=LRG_IM+matrixLRG;
                LRG(:,3)=zonenumber;
                LRG(:,4)=plantnumber;
                LRG_Pts=[LRG_Pts;LRG];
                LRG=[];
            end
        end
        label=[];
    end
end