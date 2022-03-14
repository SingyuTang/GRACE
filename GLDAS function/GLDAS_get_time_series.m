function GLDAS_get_time_series(grid_data_dir,lg_msk,type,saveseries_filename,data_type)
% 处理GRACE,GLDAS grid数据成为time_series（单位m）

%    grid_data_dir, grid_data数据（gw等效水高）的文件路径，程序包自动生成的格式
%    lg_msk,掩膜文件路径，可为bln或mat
%    type : bln文件选择line, mat文件选择mask
%    saveseries_filename,保存文件完整路径
%    data_type:数据类型：GRACE、GLDAS

%    输出数据包含time_series, int_year,int_month,time
%    lg_msk按照东经：西经，北纬：南纬排列
%GRACE 数据(东经：西经，北纬：南纬排列）包含： grid_data,str_year(cell型),str_month(cell型),time
%GLDAS 数据（东经：西经，南纬：北纬排列，需转为GRACE 中的grid_data格式）包含：grid_data,int_month,int_year,radius_filter,time,type,destrip_method
filename=grid_data_dir;
if(strcmp(data_type,'GRACE'))
    data=load(filename);
    grid_data=data.grid_data;
    str_year=data.str_year;
    str_month=data.str_month;
    int_year=cell2double(str_year);
    int_month=cell2double(str_month);
    time_series=gmt_grid2series(grid_data,lg_msk,type,89.5);
    time=data.time;
    save(saveseries_filename,'time_series','int_year','int_month','time');
end
if(strcmp(data_type,'GLDAS'))
    data=load(filename);
    grid_data_SN=data.grid_data;%GLDAS数据是按南纬：北纬排列的，需要转换为grid_data格式
    grid_data=mask_convert_NS(grid_data_SN);
    int_month=data.int_month;
    int_year=data.int_year;
    time=data.time;
    time_series=gmt_grid2series(grid_data,lg_msk,type,89.5);
    save(saveseries_filename,'time_series','int_year','int_month','time');
end

disp('save time series successfully');