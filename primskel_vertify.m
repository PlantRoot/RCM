function [primskel_V,branchzoneskel] = primskel_vertify(topology,nn,L,branchPts,primskel_prev,lastimage1stbranPts)
%straighten primary root

startrow=1;
primaryskel=[];
for i = 1:nn
    k=topology(i,1);
    order=topology(i,2);
    if order==0
        [x0,y0]=find(L==topology(i,1));
        [pixlesnumber,col]=size(x0);
        primaryskel(startrow:startrow+pixlesnumber-1,:)=[x0,y0];
        startrow=startrow+pixlesnumber;
    end
end

minrow=lastimage1stbranPts-20;
maxrow=max(primskel_prev(:,1));
[prerow,precol]=size(primskel_prev);

if prerow~=0
    skel_replace_position=find(primskel_prev(:,1)>=minrow&primskel_prev(:,1)<=maxrow);
    skel_nonreplace_position=find(primaryskel(:,1)<minrow|primaryskel(:,1)>maxrow);
    replacedskel=[primskel_prev(skel_replace_position,:);primaryskel(skel_nonreplace_position,:)];
    primskel_V=replacedskel;
else
    primskel_V=primaryskel;
end

branchzone_position=find(primskel_V(:,1)>lastimage1stbranPts-10);
branchzoneskel=primskel_V(branchzone_position,:);
end
