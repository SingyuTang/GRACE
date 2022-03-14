%把(lmax+1)*(lmax+1)的二维矩阵转化为1*(lmax+1)*(lmax+1)的三维矩阵
function dim3=dim22dim3(dim2)
[y,z]=size(dim2);
for i=1:y
    for j=1:z
        dim3(1,i,j)=dim2(i,j);
    end
end