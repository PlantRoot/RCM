function angle=angle_2label(L,label_a,label_b,braPts1,braPts2)
%function to calculate the angle between two root segments,label_a and label_b

%identified primary root segment
a_endImg    = bwmorph(L==label_a, 'endpoints');
[row, column] = find(a_endImg);
a_endPts        = [row column];
if a_endPts(2,1)>a_endPts(1,1)
    ax_vector=a_endPts(2,1)-a_endPts(1,1);
    ay_vector=0;
else
    ax_vector=a_endPts(1,1)-a_endPts(2,1);
    ay_vector=0;
end

%unidentified root segment
b_endImg    = bwmorph(L==label_b, 'endpoints');
[row, column] = find(b_endImg);
b_endPts        = [row column];

[row, column] =find(L==label_b);
label_b_point=[row, column];
labellength=length(label_b_point(:,1));
label_b_point=sortrows(label_b_point,1);

if labellength>60
    b_endPts(2,1)=braPts1;
    b_endPts(2,2)=braPts2;
    b_endPts(1,1)=label_b_point(30,1);
    b_endPts(1,2)=label_b_point(30,2);
end
if b_endPts(2,1)>b_endPts(1,1)
    bx_vector=b_endPts(2,1)-b_endPts(1,1);
    by_vector=b_endPts(2,2)-b_endPts(1,2);
else
    bx_vector=b_endPts(1,1)-b_endPts(2,1);
    by_vector=b_endPts(1,2)-b_endPts(2,2);
end

% angle
cos=((ax_vector*bx_vector)+(ay_vector*by_vector))/(sqrt(ax_vector^2+ay_vector^2)*sqrt(bx_vector^2+by_vector^2));
angle=acos(cos);
angle=rad2deg(angle);
end