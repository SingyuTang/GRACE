%读取txt文件形式的国家统计局数据（年）并转换为mat文件
function read_naturaldata(data_dir,save_filename)
%         data_dir,txt文件所在的文件夹
%         save_filename:保存mat文件的完整路径，该文件包括yeardata,data_region两个变量,都为cell类型储存
% data_dir='G:\国家统计局数据\地下水资源量\';
%save_filename='G:\国家统计局数据\地下水年数据\gw_yeardata.mat';
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
    yeardata(:,:,i1)=year_data;
    data_region(i1)=cellstr(region);
end

save(save_filename,'yeardata','data_region');
disp('save natural data successfully');