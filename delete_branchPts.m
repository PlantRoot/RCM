function segImg=delete_branchPts(skelImg,branchPts)
%delete points around the branching points

branchPtsaround1=[];branchPtsaround2=[];branchPtsaround3=[];branchPtsaround4=[];
branchPtsaround1(:,1) =branchPts(:,1)+1;
branchPtsaround1(:,2) =branchPts(:,2);
branchPtsaround2(:,1) =branchPts(:,1)-1;
branchPtsaround2(:,2) =branchPts(:,2);
branchPtsaround3(:,1) =branchPts(:,1);
branchPtsaround3(:,2) =branchPts(:,2)+1;
branchPtsaround4(:,1) =branchPts(:,1);
branchPtsaround4(:,2) =branchPts(:,2)-1;
n=length(branchPts(:,1));
for i=1:n
    skelImg(branchPtsaround1(i,1),branchPtsaround1(i,2))=0;
    skelImg(branchPtsaround2(i,1),branchPtsaround1(i,2))=0;
    skelImg(branchPtsaround3(i,1),branchPtsaround1(i,2))=0;
    skelImg(branchPtsaround4(i,1),branchPtsaround1(i,2))=0;
end
segImg=skelImg;
