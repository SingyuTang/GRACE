%当采样间隔设置为0.25时，GRACE数据处理所得的grid_data为721*1440的矩阵,GLDAS数据的grid也为721*1440的矩阵，该函数也用于0.25°的GLDAS的grid
%与lg_msk处理的矩阵有所不同，lg_msk的矩阵为720*1440
%我们可以利用该函数通过插值，将GRACE处理所得的721*1440（经度0-359.75，纬度90- -90）的矩阵转化为720*1440（经度0-359.75，纬度 89.875- -89.875）的格式的矩阵
%处理后可得到720*1440的矩阵（东经：西经，北纬：南纬）
% grid_data_filepath='G:\GRACE_processing\hbpy2018_2021\grid_data_721_1440.mat';
% savepath='G:\GRACE_processing\hbpy2018_2021\grid_data_720_1440.mat';
% datatype='GRACE';
function new_grid_data=grid_data_721_2_720_vary(grid_data_filepath,savepath,datatype)
%   grid_data_filepath:grid_data的文件路径，包含grid_data,str_month,str_year,time
%%%   grid_data:721*1440的矩阵，为GRACE_Matlab_Toolbox_preprocessing_core.m处理后所得的矩阵
%   new_grid_data:720*1440的矩阵，利用插值转化格式，方便与GLDAS数据（720*1440）进行计算
%   插值刚好为数据的中点处，故可取平均，如要得到new_grid_data中0.125°N的数据，只需将grid_data中的0°和0.25°N的数据取平均即可，因为到两边距离相等
%   savepath：生成的新的new_grid_data保存路径，共保存new_grid_data,str_month,str_year,time,需要注意的是new_grid_data这里已经重命名为grid_data
%   type:'GRACE','GLDAS','GW','GCPC'
if strcmp(datatype,'GRACE')||strcmp(datatype,'GW')
    load(grid_data_filepath);
    w=ndims(grid_data);
    if(w==2)
        for i=1:720
            grid_row1=grid_data(i,:);
            grid_row2=gird_data(i+1,:);
            grid_row_tmp=(grid_row1+grid_row2)/2;
            new_grid_data(i,:)=grid_row_tmp;
        end
    end
    if(w==3)
        for k=1:size(grid_data,3)
            for i=1:720
                grid_row1=grid_data(i,:,k);
                grid_row2=grid_data(i+1,:,k);
                grid_row_tmp=(grid_row1+grid_row2)/2;
                new_grid_data(i,:,k)=grid_row_tmp;
            end
        end
    end
    clear grid_data
    grid_data=new_grid_data;
    save(savepath,'grid_data','str_month','str_year','time');
    display('GRACE or GW grid_data has converted successfully');
end
if strcmp(datatype,'GLDAS')
    load(grid_data_filepath);
    w=ndims(grid_data);
    if(w==2)
        for i=1:720
            grid_row1=grid_data(i,:);
            grid_row2=gird_data(i+1,:);
            grid_row_tmp=(grid_row1+grid_row2)/2;
            new_grid_data(i,:)=grid_row_tmp;
        end
    end
    if(w==3)
        for k=1:size(grid_data,3)
            for i=1:720
                grid_row1=grid_data(i,:,k);
                grid_row2=grid_data(i+1,:,k);
                grid_row_tmp=(grid_row1+grid_row2)/2;
                new_grid_data(i,:,k)=grid_row_tmp;
            end
        end
    end
    clear grid_data
    grid_data=new_grid_data;
    save(savepath,'grid_data','int_month','int_year','time','radius_filter','type','destrip_method','-v7.3');
    display('GLDAS grid_data has converted successfully');
end
if strcmp(datatype,'GCPC')
    load(grid_data_filepath);
    grid_data=PrecipData;
    clear PrecipData;
    w=ndims(grid_data);
    if(w==2)
        for i=1:720
            grid_row1=grid_data(i,:);
            grid_row2=gird_data(i+1,:);
            grid_row_tmp=(grid_row1+grid_row2)/2;
            new_grid_data(i,:)=grid_row_tmp;
        end
    end
    if(w==3)
        for k=1:size(grid_data,3)
            for i=1:720
                grid_row1=grid_data(i,:,k);
                grid_row2=grid_data(i+1,:,k);
                grid_row_tmp=(grid_row1+grid_row2)/2;
                new_grid_data(i,:,k)=grid_row_tmp;
            end
        end
    end
    clear grid_data
    PrecipData=new_grid_data;
    save(savepath,'PrecipData','int_month','int_year','time','lon','lat','LON','LAT');
    display('GCPC grid_data has converted successfully');
end