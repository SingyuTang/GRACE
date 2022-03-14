%绘制地区地下水变化时序图(一组数据，年数据或月数据)
%读取文件为get_time_series计算出的time_series文件
function plot_time_series(time_series_dir,str_xlabel,str_ylabel,str_title,str_legend,data_type)
%    time_series_dir: 时间序列文件路径,cm
%    横坐标名称，纵坐标名称，标题，图例名称
%    data_type:month、year

%time_series月文件包含:time_series,str_month,str_year,time
if(strcmp(data_type,'month'))
    ts=load(time_series_dir);
    time_series=ts.time_series;
    time=ts.time;
    plot(time,time_series,'-s','marker','.','markersize',12);
    xlabel(str_xlabel);
    ylabel(str_ylabel);
    title(str_title);
    legend(str_legend);
    box on;
end
if(strcmp(data_type,'year'))
    ts=load(time_series_dir);
    time_series=ts.time_series;
    year=ts.int_year;
    plot(year,time_series,'-s','marker','.','markersize',12);
    xlabel(str_xlabel);
    ylabel(str_ylabel);
    title(str_title);    
    legend(str_legend);
    box on;
end