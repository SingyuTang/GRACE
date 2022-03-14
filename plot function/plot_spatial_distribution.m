%批量绘制地下水空间分布图（等效水高变化）
%%绘制全球地下水储量等效水高变化分布图,读取grid_data，以及对应的年月份，年变化只有年，月变化就包含年月
%月mat文件数据包含：grid_data,str_month,str_year,time
%年mat文件数据包含：grid_data，int_year
function plot_spatial_distribution(grid_data_dir,colorbar_unit,title_string,save_folder,type,c11cmn,colorbar_value)
%   grid_data           filename of grid_data
%   colorbar_unit       unit of colorbar
%   title_string        title above the figure(不用加日期)
%   save_folder         output folder of figure,用之前需要先创建文件夹
%   type                year,month
%   c11cmn              绘图区域经纬度范围[左经度 右经度 上纬度 下纬度]
% load('G:\Auxiliary function\result\GW\grid_gw_year\grace_gldas_gw_year_clm_2002_2015');
% plot_folder='G:\Auxiliary function\result\plot\gw year plot\';
% filename=[plot_folder num2str(int_year(i)) '.jpg'];

if nargin==5

    if(strcmp(type,'year'))
        grid_load=load(grid_data_dir);
        grid_data1=grid_load.grid_data;
        colorbar_value=get_max(grid_data1);
        int_year1=grid_load.int_year;
    for i=1:length(int_year1)
        title_string_tmp=[num2str(int_year1(i)) '年' title_string];
        gmt_grid2map(grid_data1(:,:,i),colorbar_value,colorbar_unit,title_string_tmp);
        filename=[save_folder num2str(int_year1(i))];
        export_fig(gcf,filename);
        close;
    end
    end
    if(strcmp(type,'month'))
        grid_load=load(grid_data_dir);
        grid_data1=grid_load.grid_data;
        colorbar_value=get_max(grid_data1);
        str_year1=grid_load.str_year;
        str_month1=grid_load.str_month;
        [k,~]=size(str_year1);
        for i=1:k
            title_string_tmp=[str_year1(i,:) '年' str_month1(i,:) '月' title_string];
            gmt_grid2map(grid_data1(:,:,i),colorbar_value,colorbar_unit,title_string_tmp);
            filename=[save_folder str_year1(i,:) str_month1(i,:)];
            export_fig(gcf,filename);
            close;
        end
    end
end

if nargin==7
    if(strcmp(type,'month'))
        lon_left=c11cmn(1);
        lon_right=c11cmn(2);
        lat_top=c11cmn(3);
        lat_bottom=c11cmn(4);
        lonlimit=[lon_left lon_right];
        latlimit=[lat_bottom lat_top];
        grid_load=load(grid_data_dir);
        grid_data1=grid_load.grid_data;
        str_year1=grid_load.str_year;
        str_month1=grid_load.str_month;
        [k,~]=size(str_year1);
        jj = size(grid_data1,1);
        ii=size(grid_data1,2);
        if (jj==721 && ii==1440)
            lon=0:0.25:359.75;
            lat=90:-.25:-90;
        elseif (jj==720 && ii==1440) % for altimetry data 0.25
            lon = 0.125:0.25:359.875;
            lat = 89.875:-0.25:-89.875;
        elseif (jj==180 && ii==360)
            lon=0.5:359.5;
            lat=89.5:-1:-89.5;
        elseif (jj==360 && ii==720)
            lon=0.25:0.5:359.75;
            lat=89.75:-0.5:-89.75;
        elseif (jj==361 && ii==720)
            lon=0.25:0.5:359.75;
            lat=90:-0.5:-90;
        elseif (jj==181 && ii==360) % for GIA grid file
            lon=0:360;
            lat=90:-1:-90;
        else
            error('Wrong input grid in function plot_spatial_distribution!');
        end
        [LON,LAT]=meshgrid(lon,lat);
        for i=1:k
            title_string_tmp=[str_year1(i,:) '年' str_month1(i,:) '月' title_string];
%             gmt_grid2map(grid_data1(:,:,i),colorbar_value,colorbar_unit,title_string_tmp);
            m_proj('Equidistant Cylindrical','long',lonlimit,'lat',latlimit);
            m_pcolor(LON,LAT,grid_data1(:,:,i));
            shading flat;
            m_coast('linewidth',1,'color','k');
            m_grid('xtick',6,'ytick',7,'tickdir','in','xlabeldir','middle',...
            'TickLength',0.008,'LineWidth',1.,'FontName', 'Helvetica','FontSize',15,'fontweight','bold');
            caxis([-colorbar_value,colorbar_value]);
            title(title_string_tmp,'fontsize',15,'FontName', 'Helvetica','fontweight','bold');
            colormap('jet')
            h=colorbar('v','FontSize',15,'fontweight','bold');
            set(get(h,'title'),'string',colorbar_unit,'FontSize',15,'fontweight','bold');
            h_pos=get(h,'Position');
            h_pos(1)=h_pos(1)+0.05;
            h_pos(2)=h_pos(2)*1.2;
            h_pos(3)=h_pos(3)*0.8;
            h_pos(4)=h_pos(4)*0.8;
            set(h,'Position',h_pos);
            filename=[save_folder str_year1(i,:) str_month1(i,:)];
            export_fig(gcf,filename);
            close;
        end
    end
end

disp('save plot successfully');
end

% 获取格网中的最大值，也可获得指定行列号范围获取范围内的最大值
function max_value=get_max(grid,region)
%   matrix: 格网矩阵
%   region：边界范围[上边界行号 下边界行号 左边界列号 右边界列号]
if nargin==1
    w=ndims(grid);
    if w==2
        max_value=max(max(grid));
    end
    if w==3
        max_value=max(max(max(grid)));
    end
end
if nargin==2
    w=ndims(grid);
    row_top=region(1);
    row_bottom=region(2);
    col_left=region(3);
    col_right=region(4);
    if w==2
        grid1=grid(row_top:row_bottom,:);
        grid2=grid1(:,col_left:col_right);
        max_value=max(max(grid2));
    end
    if w==3
        grid1=grid(row_top:row_bottom,:,:);
        grid2=grid1(:,col_left:col_right,:);
        max_value=max(max(max(grid2)));
    end
end
end