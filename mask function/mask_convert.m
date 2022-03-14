%转换lg_msk的左右边，-180-180（西经：东经）和0-360（东经：西经）格式间转换,同样适用grid_data数据和gldas等数据
function newlg_msk=mask_convert(lg_msk)
[~,col]=size(lg_msk);
res=mod(col,2);
if(res==1)
    halfcol=(col-1)/2;
    msk_tmp=lg_msk(:,1:halfcol);
    newlg_msk=[lg_msk(:,halfcol+2:end) lg_msk(:,halfcol+1) msk_tmp];
end
if(res==0)
    halfcol=col/2;
    msk_tmp=lg_msk(:,1:halfcol);
    newlg_msk=[lg_msk(:,halfcol+1:end) msk_tmp];
end