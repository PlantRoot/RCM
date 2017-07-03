function [datacell] = savdata(dataframe)

varnames = get(dataframe,'VarNames');
[row col] = size(dataframe);
datacell = cell(row,col);
for n=1 : col
    pdata = eval(cell2mat(strcat('dataframe.',varnames(n))));
    try
        datacell(:,n) = pdata;
    catch ME
        if isa(pdata,'char')
            datacell(:,n) = cellstr(pdata);
        else
            datacell(:,n) = mat2cell(pdata(:),repmat(1,row,1),1);
        end
    end
end

end

