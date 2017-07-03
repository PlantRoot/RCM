function [singlelabellength,singlelabeldiameter,diam] = Label_LenDiam(L,im,skelImg)
%Calculate the length and diameter of each root segment

% Calculate the length
s = regionprops(L, {'Centroid','Perimeter','PixelIdxList'} );
for k = 1:numel(s)
    area(k,2)=s(k).Perimeter/2;
    area(k,1)=k;
end
start=1;labelpoint=[];
for k = 1:numel(s)
    [x0,y0]=find(L==k);
    n=length(x0);
    labelpoint(start:start+n-1,1)=k;%label
    labelpoint(start:start+n-1,2)=x0;
    labelpoint(start:start+n-1,3)=y0;
    labelpoint(start:start+n-1,4)=area(k,2);%length
    start=start+n;
end

% Calculate the diameter
cannyImg=edge(im, 'canny');
[x0,y0]=find(cannyImg);
m=length(labelpoint(:,1));
n=length(x0);
diam=[];
point2skeldistance=[];
for i=1:m
    p1=labelpoint(i,2);
    q1=labelpoint(i,3);
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
    diam(i,1)=mindistance;diam(i,2)=p1;diam(i,3)=q1;diam(i,4)=x0(position);diam(i,5)=y0(position);diam(i,6)=labelpoint(i,1);
    point2skeldistance=[];
end

% merge the root segment length and diameter information
VarNames1={ 'Label' 'X' 'Y' 'L'};
a = dataset(labelpoint(:,1),labelpoint(:,2),labelpoint(:,3),labelpoint(:,4),'VarNames',VarNames1);
VarNames2={'R' 'X' 'Y'};
b = dataset(diam(:,1),diam(:,2),diam(:,3), 'VarNames',VarNames2);
singlelabeldata = join(a,b,'key',{'X' 'Y'},'Type','outer',...
    'MergeKeys',true);
varnames = get(singlelabeldata,'VarNames');
[row col] = size(singlelabeldata);
dicell = cell(row,col);
for n=1 : col
    pdata = eval(cell2mat(strcat('singlelabeldata.',varnames(n))));
    try
        dicell(:,n) = pdata;
    catch ME
        if isa(pdata,'char')
            dicell(:,n) = cellstr(pdata);
        else
            dicell(:,n) = mat2cell(pdata(:),repmat(1,row,1),1);
        end
    end
end
singlelabeldiameter = grpstats(singlelabeldata,'Label',{'mean','median'},'DataVars','R');
singlelabellength = grpstats(singlelabeldata,'Label',{'mean'},'DataVars','L');
end