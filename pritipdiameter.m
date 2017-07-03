function [ tipsegmentdiameter ] = pritipdiameter( bwPts,skelPts )
% calculater the root tip diameter

bwPts=sortrows(bwPts,1);
a=bwPts(:,1);
h_position=max(a)-13;
b=skelPts(:,1);
maxposition=find(b==h_position);

p1=skelPts(maxposition,1);
q1=skelPts(maxposition,2);
k=1;tipsegment=[];
for i=1:length(bwPts(:,2))
    if bwPts(i,1)<p1
        if bwPts(i,1)>(p1-50)
            tipsegment(k,:)=bwPts(i,:);
            k=k+1;
        end
    end
end
tipsegmentdiameter=length(tipsegment(:,2))/50;
end

