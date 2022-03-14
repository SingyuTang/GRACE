% hdf文件中的数据是按西经：东经排列，读取hdf文件数据中的降水数据（mm/hr）
% 输出为mat文件，按东经：西经，南纬：北纬排列,720*1440的矩阵
% 输出precipitation （mm/hr），转化为降水量时需乘上24h*该月的天数
function [precipitation,time,str_year,str_month]=read_TRMM_3B43(file_folder)
%   file_foilder:  数据所在的文件夹名

% 读取3B43降雨数据（1440*400），50°S~50°N, 180°W~180°E, 0.25*0.25
% file_folder='G:\Data\TRMM\3B43\';
% save_dir='G:\Auxiliary function\result\TRMM\';
[filelists,file_num] = GetFiles(file_folder);
for k=1:file_num
    filename=[file_folder cell2mat(filelists(k))];
    tmp=cell2mat(filelists(k));
    str_year(k,:)=tmp(6:9);
    str_month(k,:)=tmp(10:11);
    str_day(k,:)=tmp(12:13);
    days=gmt_get_days(str2double(tmp(6:9)),str2double(tmp(10:11)),str2double(tmp(12:13)));
    if(mod(str2double(tmp(6:9)),4)==0)%闰年
        time_tmp=days/366+str2double(tmp(6:9));
    end
    if(mod(str2double(tmp(6:9)),4)~=0)%非闰年
        time_tmp=days/365+str2double(tmp(6:9));
    end
    time(k)=time_tmp;
    precip = permute(hdfread(filename,'precipitation'),[2 1]);%相当于转置，转为地图经纬网那样的排列
    precip(precip < 0) = 0;
    precipitation(:,:,k)=precip;
end

% % 补全纬度信息，并转化为东经：西经格式,0.25*0.25

nan_data=zeros(160,1440,file_num);%纬度大于50没有数据
precipitation=[nan_data;precipitation;nan_data];
%把西经:东经格式改为东经：西经格式（grid_data格式）
precip_tmpp=zeros(size(precipitation));
for i=1:file_num
    precip_tmp=mask_convert(precipitation(:,:,i));
    precip_tmpp(:,:,i)=precip_tmp;
end
precipitation=precip_tmpp;