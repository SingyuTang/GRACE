% %由GRACE,GLDAS数据计算GW,单位cm,数据文件包含grid_data,str_month,str_year,time
% 输出的grid_data是按东经：西经，北纬：南纬排列
%GRACE 数据(东经：西经，北纬：南纬排列）包含： grid_data,str_year(cell型),str_month(cell型),time
%GLDAS 数据（东经：西经，南纬：北纬排列，需转为GRACE 中的grid_data格式）包含：grid_data,int_month,int_year,radius_filter,time,type,destrip_method
%GRACE和GLDAS的0.25°数据都为721*1440格式，因此利用这两个数据计算出来的gw也为721*1440格式的
function grace_gldas_gw(grace_dir,gldas_dir,gw_savedir)
%   grace_dir: GRACE数据处理后的等效水高，陆地水
%   gldas_dir: GLDAS数据处理后的等效水高，地表水
% clc;clear;
% save_dir= 'G:\result\GW\grid_gw month_025\grace_gldas_gw_noah025_2002_2015.mat';
% gldas_id=load('G:\result\GLDAS\NOAH025\grid_swenson_300_land_GLDAS_NOAH025_025_200001_202102');%clm dat
% grace_id=load('G:\result\GRACE\GRACE025\grid_data_025_leakagefree');%m

save_dir=gw_savedir;
gldas_id=load(gldas_dir);
grace_id=load(grace_dir);

% %计算地下水
grid_gldas=getfield(gldas_id,'grid_data');%gldas,mm
grid_gldas=mask_convert_NS(grid_gldas);%交换南纬北纬
gldas_year_month=[getfield(gldas_id,'int_year') getfield(gldas_id,'int_month')];
grid_grace=getfield(grace_id,'grid_data');%grace,m
grace_year_month=[ str2num(cell2mat(getfield(grace_id,'str_year')')) str2num(cell2mat(getfield(grace_id,'str_month')')) ];

%读取两个grid数据中的相同年月份并读取在其数据中的行数，第二列为grace中的行号，第三列为gldas中的行号
time_row=read_year_month(grace_year_month,gldas_year_month);
[k,~]=size(time_row);
for i=1:k
    row1=time_row(i,2);
    row2=time_row(i,3);
    grid_data(:,:,i)=grid_grace(:,:,row1)*100-grid_gldas(:,:,row2)/10;%units,cm
end
strtime=num2str(time_row(:,1));
str_year=strtime(:,1:4);
str_month=strtime(:,5:6);
for i=1:length(str_year)
    time(i)=str2double(str_year(i,:))+str2double(str_month(i,:))/12;
end
save(save_dir,'grid_data','str_year','str_month','time');

clear;clc;
disp(['Save grid_gw successfully.']);