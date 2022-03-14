%根据GRACE计算的grid_data数据、GLDAS中的land数据和soil数据、gw中的grid_data数据、降雨量数据、地区lg_msk文件绘制时间序列图
% function plot_series(grid_name_grace,grid_name_gldas_land,grid_name_gldas_soil,grid_gw_name,precipitation_name,lg_msk_name,dir_natidata)
% function plot_series(grid_name_grace,grid_name_gldas_land,grid_name_gldas_soil,grid_gw_name,precipitation_name,lg_msk_name)
function plot_series(grid_name_grace,grid_name_gldas_land,grid_name_gldas_soil,grid_gw_name,lg_msk_name,setAxis,precipitation_name)
%   所有参数都为grid文件完整路径
%   grid_name_grace：GRACE计算的grid_data文件路径，包含grid_data,str_month,str_year,time，东经：西经，北纬：南纬格式
%   grid_name_gldas_land:处理GLDAS数据所得的grid_data(land)数据文件路径，包含grid_data,int_month,int_year,time，东经：西经，南纬：北纬
%   grid_gw_name：地下水格网数据文件路径，包含grid_data,str_month,str_year,time，东经：西经，北纬：南纬排列
%   grid_name_gldas_soil:处理GLDAS数据所得的grid_data(soil)数据文件路径，包含grid_data,int_month,int_year,time，东经：西经，南纬：北纬
%   precipitation_name:降雨数据，包含precipitation,str_month,str_year,time，东经：西经，南纬：北纬(720*1440)
%   lg_msk_name:掩膜数据，东经：西经；北纬：南纬
%   setAxis :坐标轴的范围，如[2002 2018 -10 20]
%   上述文件必须矩阵大小相同
%   dir_natidata:国家统计局地下水数据

%   介于南纬：北纬和北纬：南纬两种分列的数据都有，因此在使用函数计算时间序列时，需要带入不同格式的lg_msk，
%   但都必须保证lg_msk和grid_data的格式相同（要不都是北纬：南纬，要不都是南纬：北纬

% region_acreage=16410;   %国家统计局数据区域的面积，需单独设置，单位km^2
[time_series_gw,~,~,time_gw]=get_time_series_gw(grid_gw_name,lg_msk_name,'mask','month');%cm
[time_series_land,~,~,time_land]=get_time_series_GRACE_GLDAS(grid_name_gldas_land,lg_msk_name,'mask','GLDAS');%mm
[time_series_soil,~,~,time_soil]=get_time_series_GRACE_GLDAS(grid_name_gldas_soil,lg_msk_name,'mask','GLDAS');%mm
[time_series_tws,~,~,time_tws]=get_time_series_GRACE_GLDAS(grid_name_grace,lg_msk_name,'mask','GRACE');%m
% [time_series_prec,~,~,time_prec]=get_time_series_prec_trmm(precipitation_name,lg_msk_name,'mask');%mm
[time_series_prec,~,~,time_prec]=get_time_series_prec_gcpc(precipitation_name,lg_msk_name,'mask');%mm

% [time_series_natigw,time_natigw]=get_time_series_natidata(dir_natidata,region_acreage);%cm

 f=figure;
 title('北京市地下水储量与降雨量发展趋势');
 yyaxis right%控制右纵轴
 bar(time_prec,time_series_prec);%绘柱状图

 xlabel('年');
 ylabel('降雨量(mm)');
 yyaxis left%控制左纵轴
 hold on;

 plot(time_gw,time_series_gw,'-s','color','r','marker','none');%绘折线图
 plot(time_tws,time_series_tws*100,'-s','color','b','marker','none');
 plot(time_land,time_series_land/10,'-s','color','g','marker','none');
 plot(time_soil,time_series_soil/10,'-s','color','k','marker','none');
%  plot(time_natigw,time_series_natigw,'-s','color','c','marker','none');
%  plot(time_nati,time_series_nati);
%  grid on;
 legend('underground water','land water','surface water','soil water');
 ylabel('等效水高(cm)');
 axis(setAxis);
 set(gca,'XTick',[setAxis(1):1:setAxis(2)]);
end


% 计算地下水时序time_series,加载地区边界文件（.mat），grid_data文件
%计算时间序列(月),读取grid_data,lg_msk,保存文件包含time_series,str_year,str_month,time(double)
function [time_series,str_year,str_month,time]=get_time_series_gw(grid_data_dir,lg_msk,type,data_type)
%   grid_data_dir, 由grace数据结算出来的grid_data数据（gw等效水高，格式为东经：西经，北纬，南纬）的文件路径
%   lg_msk,掩膜文件路径，可为bln或mat
%   type : bln文件选择line, mat文件选择mask
%   data_type:year、month
gw=load(grid_data_dir);
if(strcmp(data_type,'month'))
    grid_data=gw.grid_data;
    str_year=gw.str_year;
    str_month=gw.str_month;
    time=gw.time;
	time_series=gmt_grid2series(grid_data,lg_msk,type,89.875);
    for i=1:length(time_series)
        time(i)=str2double(gw.str_year(i,:))+str2double(gw.str_month(i,:))/12;
    end
end
end

% 处理GRACE,GLDAS grid数据生成time_series
function [time_series,int_year,int_month,time]=get_time_series_GRACE_GLDAS(grid_data_dir,lg_msk,type,data_type)

%    grid_data_dir, grid_data数据（GRACE或者GLDAS等效水高）的文件路径
%    lg_msk,掩膜文件路径，可为bln或mat
%    type : bln文件选择line, mat文件选择mask
%    saveseries_filename,保存文件完整路径
%    data_type:数据类型：GRACE、GLDAS

%    输出数据包含time_series, int_year,int_month,time
%    lg_msk按照东经：西经，北纬：南纬排列
%    GRACE 数据(东经：西经，北纬：南纬排列）包含： grid_data,str_year(cell型),str_month(cell型),time
%    GLDAS 数据（东经：西经，南纬：北纬排列，需转为GRACE 中的grid_data格式）包含：grid_data,int_month,int_year,radius_filter,time,type,destrip_method
filename=grid_data_dir;
if(strcmp(data_type,'GRACE'))
    data=load(filename);
    grid_data=data.grid_data;
    str_year=data.str_year;
    str_month=data.str_month;
    int_year=cell2double(str_year);
    int_month=cell2double(str_month);
    time_series=gmt_grid2series(grid_data,lg_msk,type,89.875);
    time=data.time;
end
if(strcmp(data_type,'GLDAS'))
    data=load(filename);
    grid_data_SN=data.grid_data;%GLDAS数据是按南纬：北纬排列的，需要转换为grid_data格式
    grid_data=mask_convert_NS(grid_data_SN);%上下翻转
    int_month=data.int_month;
    int_year=data.int_year;
    time=data.time;
    time_series=gmt_grid2series(grid_data,lg_msk,type,89.875);
end
end

%   处理降水数据生成time_series
function [time_series,str_month,str_year,time]=get_time_series_prec_trmm(prec_name,lg_msk,type)
%   降水数据呈东经：西经，南纬：北纬排列，须和lg_msk排列相同（东经：西经，北纬：南纬排列）
precipload=load(prec_name);
str_year=precipload.str_year;
str_month=precipload.str_month;
time=precipload.time;
precipSN=precipload.precipitation;
precipNS=mask_convert_NS(precipSN);   %将南纬：北纬转化为北纬：南纬
time_series=gmt_grid2series(precipNS,lg_msk,type,89.875);

end

function [time_series,str_month,str_year,time]=get_time_series_prec_gcpc(prec_name,lg_msk,type)
precipload=load(prec_name);
time_series=gmt_grid2series(precipload.PrecipData*30,lg_msk,type,90);
str_year=num2str(precipload.int_year);
str_month=num2str(precipload.int_month);
time=precipload.time;
end
%   读取地下水数据并计算等效水高（国家统计局）
function [time_series,time]=get_time_series_natidata(data_dir,region_acreage)
%       data_dir,国家统计局数据txt文件所在的文件夹,如'G:\国家统计局数据\北京\'

S=region_acreage;
filelist=dir(data_dir);
for i=3:length(filelist)
    filename(i-2,:)=fullfile(data_dir,filelist(i).name);
end
[k,~]=size(filename);
clear i;
for i1=1:k
    fid=fopen(filename(i1,:),'r');
    year_num=fgetl(fid);%第一行代表年份数
    region=fgetl(fid);%第二行代表地区名称
    for j1=1:str2num(year_num)
        tline=fgetl(fid);
        data_tmp=strsplit(tline,',');
        year_data(j1,:)=data_tmp;
    end
    yeardata(:,:,i1)=year_data;%亿立方米
    data_region(i1)=cellstr(region);
end

gw_yeardata=zeros(size(yeardata,1),2);%第一列为年份，第二列为总地下水储量(亿立方米）
for i=1:size(yeardata,1)
    str_year=cell2mat(yeardata(i,1,1));
    data_tmp=yeardata(i,2,:);%获取同一年份不同地区的数据
    data_doub=cell2double(data_tmp);
    data_sum=sum(data_doub);
    gw_yeardata(i,1)=str2double(str_year);
    gw_yeardata(i,2)=data_sum;
end
%计算地下水高
gwh=zeros(size(yeardata,1),2);%第一列为年份，第二列为总地下水水高（cm）
gw_tmp=gw_yeardata(:,2);
gwh_tmp=100*gw_tmp*10^8./(S*10^6);%换算为cm
gwh(:,1)=gw_yeardata(:,1);
gwh(:,2)=gwh_tmp;

%计算地下水高变化量
Delta_gwh=zeros(size(gwh));
gw_mean=mean(gwh(:,2));%
Delta_gwh(:,1)=gwh(:,1);
Delta_gwh(:,2)=gwh(:,2)-gw_mean;
time=Delta_gwh(:,1)';
time_series=Delta_gwh(:,2)';
end

