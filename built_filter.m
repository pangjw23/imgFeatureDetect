function res = built_filter(img)
% 设置双边滤波的参数，双边滤波函数为 bfilt_gray
r = 3;    % 滤波半径
a = 3;    % 全局方差
b = 0.1;  % 局部方差

[~,~,ch] = size(img);
% 判断是灰度图还是彩色图像
if ch == 1   
    res = bfilt_gray(img,r,a,b);
else
    res = bfilt_rgb(img,r,a,b);
end
end
%%  灰度图双边滤波
function res = bfilt_gray(img,r,a,b)
% f灰度图;r滤波半径 ;a全局方差;b局部方差
[x,y] = meshgrid(-r:r);

% 空域核 把中心点当做原点那么各点与中心点的距离就为(i-k)^2 +(j-l)^2 =k^2+l^2.
% 其中(i,j)是中心点坐标,(k,l)是邻域各点坐标
w_spatial = exp(-( x.^2+y.^2 )/(2*a^2));   % 二维高斯函数为 G(x,y) = 1/(2πσ) *  exp(-(x^2 + y^2)/2*σ^2)
img = im2double(img); 
 
[m,n] = size(img);
f_temp = padarray(img,[r r],'symmetric');  % 边缘填充之后的图像
res = zeros(m,n);
count = 0; % 记录有多少个点计算了

for i = r+1:m+r
    for j = r+1:n+r
        
        count = count +1;
        temp = f_temp(i-r:i+r,j-r:j+r); % 一个局部块的像素值
       
        w_pixel = exp(  -( temp- img(i-r,j-r) ).^2/(2*b^2)); % 值域核
        w = w_spatial .* w_pixel;
        s = temp.*w;
    
        res(i-r,j-r) = sum(s(:)) / sum(w(:)); % 计算该点新的像素值
    end

end


end
 
%% 彩色图双边滤波
% 彩色图像每个通道单独处理即可
function res = bfilt_rgb(img,r,a,b)
% f灰度图；r滤波半径；a全局方差；b局部方差

res = zeros(size(img)) ;
for i = 1:3
     res(:,:,i) = bfilt_gray(img(:,:,i),r,a,b);
end

end