%对cs矩阵进行插值，插值位置位time_in
function cs_in=insect_cs(cs,lmax,time,time_in)
%   input:
%       cs：三维cs矩阵
%       lmax：l最大阶数
%       time:cs对应的time向量
%       time_in:插入的时间
%   output:
%       cs_in:根据三次样条法和time_in计算得出的cs矩阵
k=size(cs,1);
cs_in=zeros(lmax+1,lmax+1);
for i=1:k
    lmcosi(:,:,i)=gmt_cs2lmcosi(dim32dim2(cs(i,:,:)));
end
gc_in=zeros(size(lmcosi,1),1);
gs_in=zeros(size(gc_in));
for i1=1:size(lmcosi,1)
    lmcosi_gc1=lmcosi(i1,3,:);
    lmcosi_gs1=lmcosi(i1,4,:);
    lmcosi_gc2=lmcosi_gc1(1,:);
    lmcosi_gs2=lmcosi_gs1(1,:);
    gc_in(i1,1)=spline(time,lmcosi_gc2,time_in);
    gs_in(i1,1)=spline(time,lmcosi_gs2,time_in);
end
lmcosi_in=[lmcosi(:,1:2,1) gc_in gs_in];
cs_in=gmt_lmcosi2cs(lmcosi_in);
end