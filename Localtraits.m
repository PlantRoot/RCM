function Localtraits
% Function to extract the local traits of different zone of primary root for sequence images
global img maininterval;

% find the first branching point for the last image
nimages=length(img);
im=img(nimages).img_cutroot;
skelImg  = bwmorph(im,'thin',Inf);
skelImg(1:30,:)=0;
skelImg= bwmorph(skelImg,'spur',3);
branchImg = bwmorph(skelImg, 'branchpoints');
[row, column] = find(branchImg);branchPts= [row column];
lastimage1stbranPts=min(branchPts(:,1));

% Sequence images analysis
primskel_prev=[];branchPtsPosi=[];
pre_indi_root_topology=[];indi_dynamic=[];
h=mywaitbar(0,'Images processing, please wait ...');

for  i=1:nimages
    LRG_MultiIM=zeros(1600,1600);Midline_all=[];LRG_Pts=[];totallateralsarea=0;Basal_LRG_Pts=[];
    im=img(i).img_cutroot;
    
    % skeleton
    skelImg  = bwmorph(im,'thin',Inf);
    skelImg(1:30,:)=0;
    totallength = sum(skelImg(:))+30;
    [row, column] = find(skelImg);
    skelPts        = [row column];
    skelImg= bwmorph(skelImg,'spur',12);
    [row, column] = find(skelImg);
    skelPts        = [row column];
    
    % crossing points and endpoints
    branchImg = bwmorph(skelImg, 'branchpoints');
    endImg    = bwmorph(skelImg, 'endpoints');
    [row, column] = find(endImg);
    endPts        = [row column];
    [row, column] = find(branchImg);
    branchPts     = [row column];
    
    % root segmention
    segImg=delete_branchPts(skelImg,branchPts);
    segImg=bwareaopen(segImg,2);
    L=[];L = bwlabel((segImg >0).*(~branchImg),8);
    
    [Branchrow,Branchcol]=size(branchPts);
    % if branch number>1
    if Branchrow>1
        
        % topology analysis
        [branchPtsPosi,topology] =toplgy(branchPts,endPts,L,im);
        [BranPtsRow,BranPtsCol]=size(branchPtsPosi);
        
        % Straighten primary root
        [nn,mm]=size(topology);
        [primskel_V,branchzoneskel] = primskel_vertify(topology,nn,L,branchPts,primskel_prev,lastimage1stbranPts);
        primskel_prev=primskel_V;
        
        % primary and laterals separation
        imwrite(img(i).img_cutroot,'A.jpg');
        Img_cutlaterals=imread('A.jpg');
        interval=10;
        [Img_cutlateralsandmain,Img_cutlaterals] = cutlateral_primary(Img_cutlaterals,interval,maininterval,im,primskel_prev,branchzoneskel);
        thresh=graythresh(Img_cutlateralsandmain);
        Img_cutlateralsandmain=im2bw(Img_cutlateralsandmain,thresh);
        Img_cutlateralsandmain=bwareaopen(Img_cutlateralsandmain,100);
        Img_cutlateralsandmain=bwlabel(Img_cutlateralsandmain);
        img(i).rgbLabel = label2rgb(Img_cutlateralsandmain,'lines');
        img(i).image=img(i).rgbLabel;
        
        if BranPtsRow~=0
            L_row_index = branchPtsPosi(:,3) == 1;
            L_branchPtsPosi=branchPtsPosi(L_row_index,:);
            R_row_index = branchPtsPosi(:,3) == 2;
            R_branchPtsPosi=branchPtsPosi(R_row_index,:);
        end
        % Total area of primary and lateral roots
        [primaryrootarea,lateralrootarea,Label_cutlaterals] =calprimlat_area(Img_cutlaterals);
        
        % calculater the total area, basal area and mean length of laterals in different zone of primary root
        LateralGroup = regionprops(Label_cutlaterals, {'Area','Centroid'});
        label_area=[];
        for k = 1:length(LateralGroup)
            label_area(k,2)=LateralGroup(k).Area;
            label_area(k,1)=k;
        end
        if BranPtsRow~=0
            [L_branchPtsPosi,R_branchPtsPosi]=LateralGrouptobranchpts(L_branchPtsPosi,R_branchPtsPosi,Label_cutlaterals);
            label_branchPtsPosi=[R_branchPtsPosi;L_branchPtsPosi];%  合并左右两面的分枝
        end
        if BranPtsRow~=0 & length(label_area)~=0
            [branch_meanarea] = zoneLat_area(label_branchPtsPosi,branchzoneskel,maininterval,label_area);
        end
        [LRG_IM,LRG_Pts] = zone_lrg( Label_cutlaterals,branch_meanarea,i,label_branchPtsPosi,maininterval);
        row=1;
        for j=1:length(LRG_Pts)
            if LRG_Pts(j,2)<=65 & LRG_Pts(j,2)>=53
                Basal_LRG_Pts(row,:)= LRG_Pts(j,:);
                row=row+1;
            end
        end
        LRGpoints=[];
        VarNames={'Row' 'Col' 'Zone' 'ImageNum'};
        LRGpoints=dataset(LRG_Pts(:,1),LRG_Pts(:,2),LRG_Pts(:,3),LRG_Pts(:,4),'VarNames',VarNames);
        img(i).LRGpoints=LRGpoints;
        basaldiameter=[];
        basaldiameter=dataset(Basal_LRG_Pts(:,1),Basal_LRG_Pts(:,2),Basal_LRG_Pts(:,3),Basal_LRG_Pts(:,4),'VarNames',VarNames);
        img(i).basaldiameter=basaldiameter;
    else
        primskel_prev=skelPts;
    end
    mywaitbar(i/nimages);
end
close(h);
return
