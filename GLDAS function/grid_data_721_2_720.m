%当采样间隔设置为0.25时，GRACE数据处理所得的grid_data为721*1440的矩阵,GLDAS数据的grid也为721*1440的矩阵，该函数也用于0.25°的GLDAS的grid
%与GLDAS处理的矩阵有所不同，GLDAS的矩阵为720*1440，
%我们可以利用该函数通过插值，将GRACE处理所得的721*1440（经度0-359.75，纬度90- -90）的矩阵转化为720*1440（经度0-359.75，纬度 89.875- -89.875）的格式的矩阵
%处理后可得到720*1440的矩阵（东经：西经，北纬：南纬）

function new_grid_data=grid_data_721_2_720(grid_data)
%   grid_data:721*1440的矩阵，为GRACE_Matlab_Toolbox_preprocessing_core.m处理后所得的矩阵
%   new_grid_data:720*1440的矩阵，利用插值转化格式，方便与GLDAS数据（720*1440）进行计算
%   插值刚好为数据的中点处，故可取平均，如要得到new_grid_data中0.125°N的数据，只需将grid_data中的0°和0.25°N的数据取平均即可，因为到两边距离相等
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