clear;clc;
[filenames,file_num] = GetFiles('J:\orbit');
data_tab=zeros(file_num,1);
name=cell2mat(filenames);
for i=1:file_num
    data_tab(i,1)=str2double(name(i,43:50));
end
data_tab=data_tab+1;