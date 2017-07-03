function [branchPtsPosi,topology,tipPtsdata,tiplabledata] =toplgy(branchPts,endPts,L,im)
%Topology analysis of root systems
%extract the primary root,the branching points and 1-st order laterals roots

num=0;seqmain=1;seqlat=1;topology=[];distance=[];
branchPtsrow=1;branchPtsPosi=[];
[branchrow,branchcol]=size(branchPts);
tipPtsdata=[];
tiplabledata=[];
if branchrow~=0
    %find the first primary root segment
    a=[];
    a=endPts(:,1);
    minposition=find(a==min(a));
    label_end= L(endPts(minposition,1),endPts(minposition,2));
    
    end_endImg    = bwmorph(L==label_end, 'endpoints');
    [row, column] = find(end_endImg);
    end_endPts        = [row column];
    if end_endPts(1,1)>  end_endPts(2,1)
        endpoint=end_endPts(1,:);
    else
        endpoint=end_endPts(2,:);
    end
    
    [n,m]=size(endPts);
    for i =1:n
        distance(i)=norm(endpoint-endPts(i,:));
    end
    dis=distance';
    minvalue=min(dis);
    
    while minvalue~=0
        [n,m]=size(branchPts);
        for i =1:n
            distance(i)=norm(endpoint-branchPts(i,:));
        end
        dis=distance';
        minposition=find(dis==min(dis));
        pixelslength=length(minposition);
        minposition=max(minposition);
        % figure(1); imshow(L); hold on; plot(branchPts(minposition,2),branchPts(minposition,1),'r*');
        
        %log each branching point on the primary root
        branchPtsPosi(branchPtsrow,1:2)=branchPts(minposition,:);
        
        %find the segment around the branching point
        matrix5=[];k=1;
        matrix5= L(branchPts(minposition,1)-4:branchPts(minposition,1)+4,branchPts(minposition,2)-3:branchPts(minposition,2)+3);
        for i=1:9
            for j=1:7
                if matrix5(i,j)~=0
                    label(k)=matrix5(i,j);
                    k=k+1;
                end
            end
        end
        label=unique(label);
        number=numel(label);
        
        k=5;l=4;
        while number==1
            matrix5= L(branchPts(minposition,1)-k:branchPts(minposition,1)+k,branchPts(minposition,2)-l:branchPts(minposition,2)+l);
            for i=1:2*k+1
                for j=1:2*l+1
                    if matrix5(i,j)~=0
                        label(k)=matrix5(i,j);
                        k=k+1;
                    end
                end
            end
            label=unique(label);
            number=numel(label);
            k=k+1;l=l+1;
        end
        
        %identify the lateral-order of the selected root segments
        label_a=0;label_b=0;label_c=0;
        if number==3
            if label(1)==label_end
                label_a=label(2);
                label_c=label(3);
            elseif label(2)==label_end
                label_a=label(1);
                label_c=label(3);
            elseif label(3)==label_end
                label_a=label(1);
                label_c=label(2);
            end
            label_b=label_end;%identified primary root segment
            
            braPts1=branchPts(minposition,1);
            braPts2=branchPts(minposition,2);
            
            angle_ab=angle_2label(L,label_b,label_a,braPts1,braPts2);
            angle_bc=angle_2label(L,label_b,label_c,braPts1,braPts2);
            
            [label_aendpoint_row,label_aendpoint_col,label_alateralnumber]=find_farthestPts(L,label_a,branchPts,minposition,endPts);
            [label_cendpoint_row,label_cendpoint_col,label_clateralnumber]=find_farthestPts(L,label_c,branchPts,minposition,endPts);
            
            %determine the root order based on the root segment angle
            if angle_ab>angle_bc & label_cendpoint_row>branchPts(minposition,1)
                topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;%primary
                topology(num+2,1)=label_a;topology(num+2,2)=1;topology(num+2,4)=seqlat;topology(num+2,5)=label_alateralnumber;%laterals
                if label_alateralnumber==1
                    %calculate the angle and diameter of lateral root tip
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_a,branchPts,minposition,endPts,im);
                    topology(num+2,6)=tipangle;
                    topology(num+2,7)=branchPts(minposition,1);
                    topology(num+2,8)=branchPts(minposition,2);
                    topology(num+2,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+3,1)=label_c;topology(num+3,2)=0;topology(num+3,4)=seqmain+1;topology(num+3,5)=0;%primary
                L=deletelabel(L,label_end); L=deletelabel(L,label_a);
                
                if label_aendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+2,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+2,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
            else
                topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;
                topology(num+2,1)=label_c;topology(num+2,2)=1;topology(num+2,4)=seqlat;topology(num+2,5)=label_clateralnumber;
                if label_clateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_c,branchPts,minposition,endPts,im);
                    topology(num+2,6)=tipangle;
                    topology(num+2,7)=branchPts(minposition,1);
                    topology(num+2,8)=branchPts(minposition,2);
                    topology(num+2,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+3,1)=label_a;topology(num+3,2)=0;topology(num+3,4)=seqmain+1;topology(num+3,5)=0;
                L=deletelabel(L,label_end); L=deletelabel(L,label_c);
                if label_cendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+2,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+2,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
            end
            
            label_end=topology(num+3,1);%new identified primary segment
            num=num+2;
            seqlat=seqlat+1;
            seqmain=seqmain+1;
            endpoint=judge_endPts(L,label_end);
            [n,m]=size(endPts);
            for i =1:n
                distance(i)=norm(endpoint-endPts(i,:));
            end
            dis=distance';
            minvalue=min(dis);
            
        elseif number==2
            if label(1)==label_end
                label_a=label(2);
            elseif label(2)==label_end
                label_a=label(1);
            end
            label_b=label_end;
            
            topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;
            topology(num+2,1)=label_a;topology(num+2,2)=0;topology(num+2,4)=seqmain+1;topology(num+2,5)=0;
            L=deletelabel(L,label_end);
            branchPtsPosi(branchPtsrow,3)=0;
            
            label_end=topology(num+2,1);
            num=num+1;
            seqmain=seqmain+1;
            endpoint=judge_endPts(L,label_end);
            [n,m]=size(endPts);
            for i =1:n
                distance(i)=norm(endpoint-endPts(i,:));
            end
            dis=distance';
            minvalue=min(dis);
            
        elseif number==4
            if label(1)==label_end
                label_a=label(2);
                label_c=label(3);
                label_d=label(4);
            elseif label(2)==label_end
                label_a=label(1);
                label_c=label(3);
                label_d=label(4);
            elseif label(3)==label_end
                label_a=label(1);
                label_c=label(2);
                label_d=label(4);
            elseif label(4)==label_end
                label_a=label(1);
                label_c=label(2);
                label_d=label(3);
            end
            label_b=label_end;
            
            braPts1=branchPts(minposition,1);
            braPts2=branchPts(minposition,2);
            
            angle_ab=angle_2label(L,label_b,label_a,braPts1,braPts2);
            angle_bc=angle_2label(L,label_b,label_c,braPts1,braPts2);
            angle_bd=angle_2label(L,label_b,label_d,braPts1,braPts2);
            
            [label_aendpoint_row,label_aendpoint_col,label_alateralnumber]=find_farthestPts(L,label_a,branchPts,minposition,endPts);
            [label_cendpoint_row,label_cendpoint_col,label_clateralnumber]=find_farthestPts(L,label_c,branchPts,minposition,endPts);
            [label_dendpoint_row,label_dendpoint_col,label_dlateralnumber]=find_farthestPts(L,label_d,branchPts,minposition,endPts);
            
            %determine the root order based on the root segment angle
            if angle_ab>angle_bc && angle_bd>angle_bc
                topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;
                topology(num+2,1)=label_a;topology(num+2,2)=1;topology(num+2,4)=seqlat;topology(num+2,5)=label_alateralnumber;
                if label_alateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_a,branchPts,minposition,endPts,im);
                    topology(num+2,6)=tipangle;
                    topology(num+2,7)=branchPts(minposition,1);
                    topology(num+2,8)=branchPts(minposition,2);
                    topology(num+2,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+4,1)=label_c;topology(num+4,2)=0;topology(num+4,4)=seqmain+1;topology(num+4,5)=0;
                topology(num+3,1)=label_d;topology(num+3,2)=1;topology(num+3,4)=seqlat+1;topology(num+3,5)=label_dlateralnumber;
                if label_dlateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_d,branchPts,minposition,endPts,im);
                    topology(num+3,6)=tipangle;
                    topology(num+3,7)=branchPts(minposition,1);
                    topology(num+3,8)=branchPts(minposition,2);
                    topology(num+3,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                L=deletelabel(L,label_end); L=deletelabel(L,label_a);L=deletelabel(L,label_d);
                
                if label_aendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+2,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+2,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
                branchPtsPosi(branchPtsrow,1:2)=branchPts(minposition,:);
                if label_dendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+3,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+3,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
            elseif angle_ab<angle_bc && angle_bd>angle_ab
                topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;
                topology(num+2,1)=label_c;topology(num+2,2)=1;topology(num+2,4)=seqlat;topology(num+2,5)=label_clateralnumber;
                if label_clateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_c,branchPts,minposition,endPts,im);
                    topology(num+2,6)=tipangle;
                    topology(num+2,7)=branchPts(minposition,1);
                    topology(num+2,8)=branchPts(minposition,2);
                    topology(num+2,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+4,1)=label_a;topology(num+4,2)=0;topology(num+4,4)=seqmain+1;topology(num+4,5)=0;
                topology(num+3,1)=label_d;topology(num+3,2)=1;topology(num+3,4)=seqlat+1;topology(num+3,5)=label_dlateralnumber;
                if label_dlateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_d,branchPts,minposition,endPts,im);
                    topology(num+3,6)=tipangle;
                    topology(num+3,7)=branchPts(minposition,1);
                    topology(num+3,8)=branchPts(minposition,2);
                    topology(num+3,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                L=deletelabel(L,label_end); L=deletelabel(L,label_c);L=deletelabel(L,label_d);
                
                if label_cendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+2,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+2,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
                branchPtsPosi(branchPtsrow,1:2)=branchPts(minposition,:);
                if label_dendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+3,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+3,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
            elseif angle_ab>angle_bd && angle_bd<angle_bc
                topology(num+1,1)=label_end;topology(num+1,2)=0;topology(num+1,4)=seqmain;topology(num+1,5)=0;
                topology(num+2,1)=label_a;topology(num+2,2)=1;topology(num+2,4)=seqlat;topology(num+2,5)=label_alateralnumber;
                if label_alateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_a,branchPts,minposition,endPts,im);
                    topology(num+2,6)=tipangle;
                    topology(num+2,7)=branchPts(minposition,1);
                    topology(num+2,8)=branchPts(minposition,2);
                    topology(num+2,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+3,1)=label_c;topology(num+3,2)=1;topology(num+3,4)=seqlat+1;topology(num+3,5)=label_clateralnumber;
                if label_clateralnumber==1
                    [tipPts,tiplable,tipangle,tipdiameter]=roottipangle(L,label_c,branchPts,minposition,endPts,im);
                    topology(num+3,6)=tipangle;
                    topology(num+3,7)=branchPts(minposition,1);
                    topology(num+3,8)=branchPts(minposition,2);
                    topology(num+3,9)=tipdiameter;
                    tipPtsdata=[tipPtsdata;tipPts];
                    tiplabledata=[tiplabledata;tiplable];
                end
                topology(num+4,1)=label_d;topology(num+4,2)=0;topology(num+4,4)=seqmain+1;topology(num+4,5)=0;
                L=deletelabel(L,label_end); L=deletelabel(L,label_c);L=deletelabel(L,label_a);
                
                if label_aendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+2,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+2,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
                branchPtsPosi(branchPtsrow,1:2)=branchPts(minposition,:);
                if label_cendpoint_col>branchPts(minposition,2)
                    branchPtsPosi(branchPtsrow,3)=2;
                    topology(num+3,3)=2;
                else
                    branchPtsPosi(branchPtsrow,3)=1;
                    topology(num+3,3)=1;
                end
                branchPtsrow=branchPtsrow+1;
            end
            
            label_end=topology(num+4,1);%new identified segment
            num=num+3;
            seqmain=seqmain+1;
            seqlat=seqlat+2;
            endpoint=judge_endPts(L,label_end);
            [n,m]=size(endPts);
            for i =1:n
                distance(i)=norm(endpoint-endPts(i,:));
            end
            dis=distance';
            minvalue=min(dis);
        end
    end
    num=num+1;
else
    topology(1,1)=1;topology(1,2)=0;topology(1,3)=0;topology(1,4)=1;
end