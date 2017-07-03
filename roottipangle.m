function [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label,branchPts,minposition,endPts,im);
%calculater the angle and diameter of root tip segment of lateral roots

tiplable=[];k=1;
[row, column]=find(L==label);
labelPts=[row, column];
labelPts=sortrows(labelPts,2);
end_endImg    = bwmorph(L==label, 'endpoints');
[row, column] = find(end_endImg);
label_endPts=[row, column];

for i =1:2
    a_distance(i)=norm(label_endPts(i,:)-branchPts(minposition,:));
end
adis=a_distance';
max_aposition=find(adis==max(adis));
tipPts=label_endPts(max_aposition,:);

if length(labelPts(:,1))>=60
    for i=1:length(labelPts(:,1))
        dis(i)=norm(labelPts(i,2)-tipPts(:,2));
    end
    
    segposition=find(dis==50);
    segPts=labelPts(segposition,:);
    % root tip angle
    if length(segPts(:,2))~=0
        bx_vector=abs(segPts(1,1)-tipPts(1,1));
        by_vector=abs(segPts(1,2)-tipPts(1,2));
        cos=by_vector/sqrt(bx_vector^2+by_vector^2);
        angle=acos(cos);
        tipangle=rad2deg(angle);
    else
        tipangle=0;
    end
    
    for i=1:length(labelPts(:,1))
        maxcol=max(segPts(1,2),tipPts(1,2));
        mincol=min(segPts(1,2),tipPts(1,2));
        if labelPts(i,2)>=mincol
            if labelPts(i,2)<=maxcol
                tiplable(k,:)=labelPts(i,:);
                k=k+1;
            end
        end
    end
    
    % root tip diameter
    cannyImg=edge(im, 'canny');
    [x0,y0]=find(cannyImg);n=length(x0);
    m=length(tiplable(:,1));
    diam=[];
    point2skeldistance=[];
    for i=1:m
        p1=tiplable(i,1);
        q1=tiplable(i,2);
        Pmax=p1+100;
        Pmin=p1-100;
        Qmax=q1+100;
        Qmin=q1-100;
        for j=1:n
            p2=x0(j);
            q2=y0(j);
            if Pmin<p2<Pmax
                if Qmin<q2<Qmax
                    point2skeldistance(j)=sqrt((p1-p2)^2+(q1-q2)^2);
                end
            end
        end
        [mindistance,position]=min(point2skeldistance);
        minposi=find(point2skeldistance==mindistance);
        diam(i)=mindistance;
        point2skeldistance=[];
    end
    tipdiameter=mean(diam);
else
    tipangle=0;tipdiameter=0;
end
end

