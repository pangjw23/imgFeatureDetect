%------------------------------------------------------------------------------------------------
%detect函数功能：从图片中找到最大细胞核的细胞，并将其作为需要检测种类的细胞，返回值为所有剪裁之后的图片
%测试图片以1开始依次递增的命名规则
%双边滤波
%------------------------------------------------------------------------------------------------
function [] = detect(file_path, file_detect_path)
%识别一张图片中的单个细胞
img_path_list = dir(strcat(file_path,'*.bmp'));
img_num = length(img_path_list);%获取细胞照片总量
%figure,imshow(RGB)
for i =1:img_num
    img_name = img_path_list(i).name;
    img_rgb = imread(strcat(file_path,img_name));
    img_name = erase(img_name,'.bmp');
    I = rgb2gray(img_rgb);
    se = strel('disk',20);
    I2 = imbothat(I,se);  % 底帽变换，去除不均匀背景
    %figure,imshow(I2) 
    I3 = imadjust(I2);   % 调节灰度对比度
    
    % 灰度图像二值化，全局阈值分割最大化类间方差 
    level = graythresh(I3);
    BW = im2bw(I3,level);
    imLabel = bwlabel(BW);                %对各连通域进行标记
    stats = regionprops(imLabel,'Area');    %求各连通域的大小
    area = cat(1,stats.Area);
    index = find(area == max(area));        %求最大连通域的索引
    img = ismember(imLabel,index); 
    F1 = imfill(img,'holes');
    %figure,imshow(F1)   %将最大连通区域的内部进行填充
    BB=regionprops(img,'BoundingBox');%得到矩形框 去框住每一个连通域
    %对每个矩形框进行记录，记录其左上角点，长，宽   然后转换成矩阵形式
    BB1=struct2cell(BB);
    BB2=cell2mat(BB1);
    img_max = imcrop(img_rgb,[BB2(1),BB2(2),BB2(3),BB2(4)]);
    
    %裁剪之后的原图像
    img_max = built_filter(img_max);
    img_new_name = strcat(img_name,'-01.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_max, img_new_path);
    
    %裁剪之后的图像进行翻转
    img_new = flip(img_max,2);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-02.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %裁剪之后的图像增加对比度
    img_new = imadjust(img_max, [0.3,1], []);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-03.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %加入高斯噪声
    img_new = imnoise(img_max,'gaussian',0.1,0.02);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-04.bmp');
    img_new_path=fullfile(file_detect_path,img_new_name);   
    imwrite(img_new,img_new_path);
%figure,imshow(img_max)
end