function row=getrow(int_month,int_year,year,month)
%   根据int_month,int_year和输入的year，month求得所在行号（公共）
[m1,~]=find(int_year==year);
[m2,~]=find(int_month==month);
row=intersect(m1,m2);
end