%获取文件夹下的所有文件名和文件数量
function [filenames,file_num] = GetFiles(FolderName)
% filenames, 文件夹下的所有文件名
% file_num, 文件数量
% FolderName,文件夹名
files = dir(FolderName);
size0 = size(files);
length = size0(1);
names = files(3:length);
class_num = size(names);
file_num=class_num(1);
filenames=cell(file_num,1);
for i=1:file_num
    filenames(i,1)=cellstr(names(i).name);%将char转为cell
end
end