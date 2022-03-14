function row=getrow(yearlist,monthlist,year,month)
%   从年向量和月向量中获取指定年月份的行号

if(iscell(yearlist))
    yearlist=cell2double(yearlist);
    monthlist=cell2double(monthlist);
end
if(size(yearlist,2)~=1)
    yearlist=yearlist';
end
if(size(monthlist,2)~=1)
    monthlist=monthlist';
end
row1=find(yearlist==year);
row2=find(monthlist==month);
row=intersect(row1,row2);