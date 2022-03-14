% %读取GPCP数据中的降水数据保存为mat（东经：西经；北纬：南纬）,空间分辨率为2.5°,72*144，单位mm/day，转化为月降水量需乘上当月天数
% clear;clc;
% datadir='G:\Data\GPCP_data\2021\';
% savedir='G:\Data\GPCP_Precip_mat\GCPC_72_144_2.5_2021.mat';
function read_GPCP4Precip(datadir,savedir)
%   datadir:GPCP一年总的降雨数据存放的文件夹
%   savedir:保存完整路径，从GPCP文件中读取的降雨数据，保存为mat（东经：西经；北纬：南纬）,空间分辨率为2.5°,72*144，单位mm/day，转化为月降水量需乘上当月天数
filelist=dir([datadir,'*.nc']);%指定批量数据的类型
k=length(filelist);
for i=1:k
    name=filelist(i).name;
    filename=[datadir,name];
    ncid=netcdf.open(filename,'NC_NOWRITE');
    info=ncinfo(filename);
    int_year(i,:)=str2double(name(22:25));
    int_month(i,:)=str2double(name(26:27));
    PrecipDataSN= ncread(filename,'precip')';%转置后为东经：西经，南纬：北纬排列
    lon(i,:)=ncread(filename,'longitude')';
    lat(i,:)=fliplr(ncread(filename,'latitude')');
    days=gmt_get_days(int_year(i,:),int_month(i,:),15);
    if(mod(int_year,4)==0)%闰年
        time_tmp=days/366+int_year(i,:);
    end
    if(mod(int_year,4)~=0)%非闰年
        time_tmp=days/365+int_year(i,:);
    end
    time(i,:)=time_tmp;
    netcdf.close(ncid);
    PrecipData_conv=mask_convert_NS(PrecipDataSN);%将转置后的数据上下翻转，翻转后为东经：西经，北纬：南纬格式（grid_data格式）
    PrecipData(:,:,i)=double(PrecipData_conv);
end
longitude=double(lon);
latitude=double(lat);
save(savedir,'PrecipData','longitude','latitude','time','int_year','int_month');
display('save GPCP data successfully');