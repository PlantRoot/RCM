function endpoint=judge_endPts(L,label_end)
%find the end of primary root

end_endImg    = bwmorph(L==label_end, 'endpoints');
[row, column] = find(end_endImg);
end_endPts        = [row column];
[m,n]=size(end_endPts);
if m>1
    if end_endPts(1,1)>  end_endPts(2,1)
        endpoint=end_endPts(1,:);
    else
        endpoint=end_endPts(2,:);
    end
else
    endpoint=end_endPts(1,:);
end
