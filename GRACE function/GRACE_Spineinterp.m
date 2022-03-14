function [ cs_insect,cs_sgi_insect,int_year_insect,int_month_insect,time_insect] = GRACE_Spineinterp(cs,cs_sgi,int_year,int_month,time,lmax)
%补全GRACE和GRACE-FO中间缺失的11个月份，采用的方法为三次样条函数
% input:
%     cs:从文件直接读取的cs矩阵
%     cs_insect:补充缺失的11月份数据后的cs矩阵
%     lmax:位系数最大阶数
%     int_year,int_month:n*1的矩阵，与gmt_readgsm_GRACE_RL06中的int_year,int_month一样

% output:
%       cs_insect，cs_sigma_insect:插值后的cs数据、cs_sigma数据
%       int_year_insect，int_month_insect:插值后的年份和月份（N*1的矩阵）
% clear;clc;
% load('tmp.mat');
% lmax=60;
year_in=[2017;2017;2017;2017;2017;2017;2018;2018;2018;2018;2018];%缺失年份
month_in=[7;8;9;10;11;12;1;2;3;4;5];%缺失月份

%根据三次样条法计算缺失月份的cs_in和cs_sigma_in
cs_in=zeros(11,lmax+1,lmax+1);
cs_sigma_in=zeros(11,lmax+1,lmax+1);
timef_in=zeros(11,1);%根据三次样条法计算出来的缺失时间（time）的小数部分
time_in=zeros(11,1);%根据三次样条法计算出来的缺失时间（time）


for i=1:11
    [rowlist,~]=find(int_month==month_in(i));
%提取指定月份的所有数据
    yearlist=int_year(rowlist);
    cs_tmp=cs(rowlist,:,:);
    cs_sigma_tmp=cs_sgi(rowlist,:,:);
    time_tmp=time(rowlist,:);
%判断time_tmp中是否有重复年份并去除
    year_tmp=num2str(fix(time_tmp));
    [year_ttmp,year_order]=unique(year_tmp,'rows','stable');%year_ttmp为去重复项后的year，year_order为去掉重复项后year在year_tmp所在位置
    time_tmp=time_tmp(year_order);
    cs_tmp=cs_tmp(year_order,:,:);
    cs_sigma_tmp=cs_sigma_tmp(year_order,:,:);
%只用对time小数位进行三次样条函数，故要减去年份
    timeint=fix(time_tmp);
    timefloat=time_tmp-timeint;
    timef_in(i)=spline(timeint,timefloat,year_in(i));
    time_in(i)=year_in(i)+timef_in(i);% 待插值的time
    cs_in_tmp=insect_cs(cs_tmp,lmax,time_tmp,time_in(i));
    cs_in(i,:,:)=cs_in_tmp;
    cs_sigma_in_tmp=insect_cs(cs_sigma_tmp,lmax,time_tmp,time_in(i));
    cs_sigma_in(i,:,:)=cs_sigma_in_tmp;
end


%   获取2017.6月的行号(row)以用于插值后续的位系数
iyear=2017;imonth=6;itime=2017.44109589041;
[m1,~]=find(int_year==iyear);
[m2,~]=find(int_month==imonth);
row=intersect(m1,m2);

cs_tmp=cs(1:row,:,:);
cs_tmpp=cs(row+1:end,:,:);
cs_insect=cat(1,cs_tmp,cs_in,cs_tmpp);

cs_sigma_tmp=cs_sgi(1:row,:,:);
cs_sigma_tmpp=cs_sgi(row+1:end,:,:);
cs_sgi_insect=cat(1,cs_sigma_tmp,cs_sigma_in,cs_sigma_tmpp);


time_tmp=time(1:row,1);
time_tmpp=time(row+1:end,1);
time_insect=[time_tmp;time_in;time_tmpp];


int_year_insect=[int_year(1:row);year_in;int_year(row+1:end)];
int_month_insect=[int_month(1:row);month_in;int_month(row+1:end)];

end

