%根据国家统计局数据绘制地下水储量等效水高(cm)变化时间序列
function [time_series,time]=get_natidata_series(acreage,natidata_name)
%   acreage:区域面积，面积单位，km^2
%   natidata_name：国家统计局数据（根据read_naturaldata函数计算所得）完整路径，包含两列，第一列为年份，第二列为地下水数据
%
% gw_nationdata=load('G:\国家统计局数据\地下水年数据\natudata_bj.mat');
S=acreage;
gw_nationdata=load(natidata_name);

yeardata=gw_nationdata.yeardata;
data_region=gw_nationdata.data_region;
%计算华北平原总地下水量（不同年份），国家统计局资料
gw_yeardata_hbpy=zeros(size(yeardata,1),2);%第一列为年份，第二列为总地下水储量(亿立方米）
for i=1:size(yeardata,1)
    str_year=cell2mat(yeardata(i,1,1));
    data_tmp=yeardata(i,2,:);%获取同一年份不同地区的数据
    data_doub=cell2double(data_tmp);
    data_sum=sum(data_doub);
    gw_yeardata_hbpy(i,1)=str2double(str_year);
    gw_yeardata_hbpy(i,2)=data_sum;
end
%计算地下水高
gwh=zeros(size(yeardata,1),2);%第一列为年份，第二列为总地下水水高（cm）
gw_tmp=gw_yeardata_hbpy(:,2);
gwh_tmp=100*gw_tmp*10^8./(S*10^6);%换算为cm
gwh(:,1)=gw_yeardata_hbpy(:,1);
gwh(:,2)=gwh_tmp;

%计算地下水高变化量
Delta_gwh=zeros(size(gwh));
gw_mean=mean(gwh(:,2));%
Delta_gwh(:,1)=gwh(:,1);
Delta_gwh(:,2)=gwh(:,2)-gw_mean;
time=Delta_gwh(:,1)';
time_series=Delta_gwh(:,2)';
% plot(time,time_series,'-s','marker','.','markersize',12);

