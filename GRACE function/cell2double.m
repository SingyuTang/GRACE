%将cell类型矩阵转化为double类型矩阵
function doubmat=cell2double(cellmat)
%二维则输出n行一列
w=ndims(cellmat);
if (w==2) 
    doubmat=zeros(size(cellmat,1),1);
    if(size(cellmat,1)==1)
        cellmat=cellmat';
        row=size(cellmat,1);
        for i=1:row
            str=cellmat(i);
            doubmat(i,1)=str2double(str);
        end
    end
    if(size(cellmat,1)>1)
        row=size(cellmat,1);
        for i=1:row
            str=cell2mat(cellmat(i));
            doubmat(i,1)=str2double(str);
        end
    end
end
if(w==3)
    [r,c,h]=size(cellmat);
    doubmat=zeros(size(cellmat));
    for i=1:r
        for j=1:c
            for k=1:h
                str=cell2mat(cellmat(i,j,k));
                doubmat(i,j,k)=str2double(str);
            end
        end
    end
end