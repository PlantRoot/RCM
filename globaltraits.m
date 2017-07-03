function globaltraits
% Function to automatically extract the global traits of sequence images
% Function to automatically extract the completed individual lateral root traits for sequence images

global img morphologycell;

% find the first branching point for the last image
nimages=length(img);
im=img(nimages).img_bw;
skelImg  = bwmorph(im,'thin',Inf);
skelImg(1:30,:)=0;
skelImg= bwmorph(skelImg,'spur',3);
branchImg = bwmorph(skelImg, 'branchpoints');
[row, column] = find(branchImg);branchPts= [row column];
lastimage1stbranPts=min(branchPts(:,1));

% Sequence images analysis
primskel_prev=[];prebranchPtsPosi=[];branchPtsPosi=[]; pre_indi_root_topology=[];indi_dynamic=[];
h=mywaitbar(0,'Images processing, please wait ...');
dataframe=zeros(nimages,12);
for  i=1:nimages
    im=img(i).img_bw;
    [row, column] = find(im);
    bwPts = [row column];
    totalsurface = sum(im(:));
    [r, c] = find(im == 1);
    width=max(c)-min(c);
    depth=max(r)-min(r);
    img_reg = regionprops(im,'ConvexHull','ConvexImage','ConvexArea');
    Con_areas = [img_reg.ConvexArea];
    
    % skeleton
    skelImg  = bwmorph(im,'thin',Inf);
    skelImg(1:30,:)=0;
    totallength = sum(skelImg(:))+30;
    [row, column] = find(skelImg);
    skelPts        = [row column];
    
    % primary root tip diameter
    [ tipsegmentdiameter ] = pritipdiameter( bwPts,skelPts );
    
    % burring
    skelImg= bwmorph(skelImg,'spur',12);
    [row, column] = find(skelImg);
    skelPts        = [row column];
    img(i).skel=skelPts;
    
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
    s = regionprops(L, {'Centroid','Perimeter','PixelIdxList'});
    
    % each root segment length and diameter
    [singlelabellength,singlelabeldiameter,diam] = Label_LenDiam(L,im,segImg);
    
    [Branchrow,Branchcol]=size(branchPts);
    primaryrootarea=totalsurface;lateralrootarea=0;primskellen=totallength;branchnumber=0;apicalunbranchzonelength=0;
    % if branch number>1
    if Branchrow>1
        
        %calculate the length of apcial unbranched zone of primary root
        apicalunbranchzonelength=max(singlelabellength.mean_L);
        
        % topology analysis
        [branchPtsPosi,topology,tipPtsdata,tiplabledata] =toplgy(branchPts,endPts,L,im);
        [nn,~]=size(topology);
        [PrmiBranPtsNum,~]=size(branchPtsPosi);
        branchnumber=PrmiBranPtsNum;
        img(i).BraPts=branchPtsPosi;
        img(i).tipPts=tipPtsdata;
        img(i).tiplable=tiplabledata;
        VarNames1={'Label' 'Topology' 'sequence' 'rootnum' 'Side' 'Tipangle' 'branchPts_X' 'branchPts_Y' 'TipDiam'};
        dataform=[];
        dataform = dataset(topology(:,1),topology(:,2),topology(:,4),topology(:,5),topology(:,3),topology(:,6),topology(:,7),topology(:,8),topology(:,9), 'VarNames',VarNames1);
        lengthmerge=[];
        lengthmerge = join(singlelabellength,dataform,'key','Label','Type','outer', 'MergeKeys',true);
        diametermerge=[];
        diametermerge = join(singlelabeldiameter,lengthmerge,'key','Label','Type','outer', 'MergeKeys',true);
        topology_seg=diametermerge;
        img(i).topology_seg=topology_seg;
        
        %         %% individual root diameter
        %         indi_root_diameter_1=[];indi_root_Pts_1=[];indi_root_diameter_2=[];indi_root_Pts_2=[];
        %         for rootsegnum=1:length(topology(:,1))
        %             if topology(rootsegnum,5)==1
        %                 individualrootlabel=topology(rootsegnum,1);
        %                 if topology(rootsegnum,3)==1
        %                     indi_root_Pts_1=diam((diam(:,6)==individualrootlabel),:);
        %                     indi_root_diameter_1=[indi_root_diameter_1;indi_root_Pts_1];
        %                 else topology(rootsegnum,3)==2
        %                     indi_root_Pts_2=diam((diam(:,6)==individualrootlabel),:);
        %                     indi_root_diameter_2=[indi_root_diameter_2;indi_root_Pts_2];
        %                 end
        %             end
        %         end
        %         indi_root_diameter_1(:,7)=1;indi_root_diameter_2(:,7)=2;
        %         indi_root_diameter=[indi_root_diameter_1;indi_root_diameter_2];
        %         indi_root_diameter(:,8)=imagenumber;
        %         VarNames1={'Diameter' 'X' 'Y' 'BX' 'BY' 'Label' 'Side' 'ImageNum'};
        %         indiroot=[];
        %         indiroot = dataset(indi_root_diameter(:,1),indi_root_diameter(:,2),indi_root_diameter(:,3),indi_root_diameter(:,4),indi_root_diameter(:,5),indi_root_diameter(:,6),indi_root_diameter(:,7),indi_root_diameter(:,8), 'VarNames',VarNames1);
        %         [indirootcell] = savdata(indiroot);
        %         indirootname=strcat('E:\MATLAB\Images Proccessing\EIP\example\sequence-bw\individualrootdiameter_1_',num2str(imagenumber),'.csv');
        %         header={'Radius' 'Skel_Row' 'Skel_Col' 'Boundary_Row' 'Boundary_Col' 'Label' 'Side' 'ImageNum'};
        %         csvwriteh(indirootname, indirootcell, header);
        
        % Straighten primary root
        [primskel_V,branchzoneskel] = primskel_vertify(topology,nn,L,branchPts,primskel_prev,lastimage1stbranPts);
        primskel_prev=primskel_V;
        [primskellen]=prim_len(primskel_prev,im);%primary root length
        img(i).priskel=primskel_prev;
        img(i).branchzonekel=branchzoneskel;
        
        % primary and laterals separation
        imwrite(img(i).img_bw,'A.jpg');
        Img_cutlaterals=imread('A.jpg');
        maininterval=200;
        interval=10;
        [~,Img_cutlaterals] = cutlateral_primary(Img_cutlaterals,interval,maininterval,im,primskel_prev,branchzoneskel);
        
        % Total area of primary and lateral roots
        [primaryrootarea,lateralrootarea,~] =calprimlat_area(Img_cutlaterals);
    else
        primskel_prev=skelPts;
        img(i).priskel=primskel_prev;
        img(i).BraPts=[0,0];
        img(i).tipPts=[];
        img(i).tiplable=[];
        img(i).topology_seg=[];
    end
    mywaitbar(i/nimages);
    dataframe(i,1)=i;
    dataframe(i,2)=totalsurface;
    dataframe(i,3)=totallength;
    dataframe(i,4)=width;
    dataframe(i,5)=depth;
    dataframe(i,6)=Con_areas(1,1);
    dataframe(i,7)=primaryrootarea;
    dataframe(i,8)=lateralrootarea;
    dataframe(i,9)=primskellen;
    dataframe(i,10)=branchnumber;
    dataframe(i,11)=tipsegmentdiameter;
    dataframe(i,12)=apicalunbranchzonelength;
end
VarNames1={ 'Image' 'Area' 'Length' 'Width' 'Depth' 'ConvexHull' 'PrimaryArea' 'LateralArea' 'PrimaryLength' 'BranchNum' 'PrimTipDiam' 'ApicalunBranLen'};
morphologymerge = dataset(dataframe(:,1),dataframe(:,2),dataframe(:,3),dataframe(:,4),dataframe(:,5),dataframe(:,6),dataframe(:,7),dataframe(:,8),dataframe(:,9),dataframe(:,10),dataframe(:,11),dataframe(:,12),'VarNames',VarNames1);
[morphologycell] = savdata(morphologymerge);
close(h);
return