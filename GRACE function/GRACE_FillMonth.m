function [ cs_insect,cs_sigma_insect,int_year_insect,int_month_insect,time_insect] = GRACE_FillMonth(cs,cs_sigma,int_year,int_month,time,lmax)
%补全GRACE和GRACE-FO中间缺失的11个月份，采用的方法为取已有所有年份同一月份的平均值
% input:
%     cs:从文件直接读取的cs矩阵
%     cs_insect:补充缺失的11月份数据后的cs矩阵
%     lmax:位系数最大阶数
%     int_year,int_month:n*1的矩阵，与gmt_readgsm_GRACE_RL06中的int_year,int_month一样

% output:
%       cs_insect，cs_sigma_insect:插值后的cs数据、cs_sigma数据
%       int_year_insect，int_month_insect:插值后的年份和月份（N*1的矩阵）
missmonth=1:12;%缺失月份为2017.7-2018.5
missmonth(6)=[];

% int_year=cell2double(str_year);
% int_month=cell2double(str_month);

% cs_spline=zeros(11,lmax+1,lmax+1);
cs_mean=zeros(11,lmax+1,lmax+1);
cs_sigma_mean=zeros(11,lmax+1,lmax+1);
time_mean=zeros(11,1);
DOY=zeros(11,1);
for month=1:11
    [rowlist,~]=find(int_month==missmonth(month));
    yearlist=int_year(rowlist);
    cs_tmp=cs(rowlist,:,:);%提取指定月份的所有数据
    cs_sigma_tmp=cs_sigma(rowlist,:,:);
    time_tmp=time(rowlist,:);
    
    cs_mean(month,:,:)=mean(cs_tmp,1);%1月到12月的位系数平均值，其中6月份不用插值，其中2017年月数据（7,8,9,10,11,12)
    %   2018年月数据（1,2,3,4,5)
    cs_sigma_mean(month,:,:)=mean(cs_sigma_tmp,1);
    
    %只用对time小数位（年积日，DOY）进行求平均，故要减去年份
    timeint=fix(time_tmp);
    DOY_tmp=time_tmp-timeint;
    DOY(month,1)=mean(DOY_tmp);
end
%   将cs_mean数据按正常时间顺序重新排列
cs_mean_tmp=cs_mean(6:11,:,:);%2017.07-2017.12
cs_mean_tmpp=cs_mean(1:5,:,:);%2018.01-2018.05
cs_mean1=cat(1,cs_mean_tmp,cs_mean_tmpp);


cs_sigma_mean_tmp=cs_sigma_mean(6:11,:,:);%2017.07-2017.12
cs_sigma_mean_tmpp=cs_sigma_mean(1:5,:,:);%2018.01-2018.05
cs_sigma_mean1=cat(1,cs_sigma_mean_tmp,cs_sigma_mean_tmpp);

DOY_tmp=DOY(6:11,1);%2017.07-2017.12
DOY_tmpp=DOY(1:5,1);%2018.01-2018.05
DOY1=[DOY_tmp;DOY_tmpp];

%   获取2017.6月的行号(row)以用于插值后续的位系数
year=2017;month=6;
[m1,~]=find(int_year==year);
[m2,~]=find(int_month==month);
row=intersect(m1,m2);

cs_tmp=cs(1:row,:,:);
cs_tmpp=cs(row+1:end,:,:);
cs_insect=cat(1,cs_tmp,cs_mean1,cs_tmpp);

cs_sigma_tmp=cs_sigma(1:row,:,:);
cs_sigma_tmpp=cs_sigma(row+1:end,:,:);
cs_sigma_insect=cat(1,cs_sigma_tmp,cs_sigma_mean1,cs_sigma_tmpp);

year1=[2017;2017;2017;2017;2017;2017;2018;2018;2018;2018;2018];%缺失年份
month1=[7;8;9;10;11;12;1;2;3;4;5];%缺失月份
time_mean1=year1+DOY1;

time_tmp=time(1:row,1);
time_tmpp=time(row+1:end,1);
time_insect=[time_tmp;time_mean1;time_tmpp];


int_year_insect=[int_year(1:row);year1;int_year(row+1:end)];
int_month_insect=[int_month(1:row);month1;int_month(row+1:end)];

end



