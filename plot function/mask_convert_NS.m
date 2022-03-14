%转换数据的上下边，南北纬交换（GLDAS数据读取出来为上为南纬，下为北纬,需转化为grid_data格式）,同样适用grid_data数据和lg_msk等数据
%关于赤道镜像对称
function new_msk=mask_convert_NS(lg_msk)
if ndims(lg_msk)==2
new_msk=flipud(lg_msk);
end
if ndims(lg_msk)==3
    [~,~,kk]=size(lg_msk);
    new_msk=zeros(size(lg_msk));
    for i=1:kk
        msk_tmp=lg_msk(:,:,i);
        new_msk_tmp=flipud(msk_tmp);
        new_msk(:,:,i)=new_msk_tmp;
    end
end

