%---------------------------------------------------------------------------
%存在的问题：
%需不需要将裁剪之后的细胞图统一变为256×256
%特征是否能够反应真实的细胞状态（是否能够成功识别）
%不可检测的细胞是否还要进行分类
%---------------------------------------------------------------------------
%file_path---存放原始图片路径   file_change_path---翻转,旋转等操作后存放的路径   file_crop_path---裁剪后存放的路径路径
%file_detect_path---识别最大的细胞核之后剪裁存放的路径
file_path = 'C:\Users\61746\Desktop\file\';
file_change_path = 'C:\Users\61746\Desktop\file_change\';
file_crop_path = 'C:\Users\61746\Desktop\file_crop\';
file_detect_path = 'C:\Users\61746\Desktop\file_detect\';







%增强数据
%尾号X代表增强后的
make_dataset(file_path, file_change_path, file_crop_path);

%细胞识别
%尾号0X代表识别出来的细胞增强后的
detect(file_path, file_detect_path);

%%对类数较少的细胞继续增强
img_path_list = dir(strcat(file_detect_path,'*.bmp'));
img_num = length(img_path_list);
for i = 1:img_num
    img_name = img_path_list(i).name;
    if img_path_list(i).name(1) ~=1 && img_path_list(i).name(1) ~=2
        img = imread(strcat(file_detect_path,img_name));
        
        %加入椒盐噪音,之后滤波
        img_new = imnoise(img,'salt & pepper',0.08);
        img_new = built_filter(img_new);
        img_new_name = strcat(img_path_list(i).name(1:5),'-05.bmp');
        img_new_path = fullfile(file_detect_path, img_new_name);
        imwrite(img_new, img_new_path);
        
        %图像锐化
        H = fspecial('unsharp');
        img_new = imfilter(img,H,'replicate');
        img_new_name = strcat(img_path_list(i).name(1:5),'-06.bmp');
        img_new_path = fullfile(file_detect_path, img_new_name);
        imwrite(img_new, img_new_path);
    end
end

%特征提取，写入excel
%%特征提取（为原图像裁剪之后，大概率全部是不可检测细胞）
img_path_list = dir(strcat(file_crop_path,'*.bmp'));
img_num = length(img_path_list);
a_crop = {};
for i = 1:img_num
    img_name = img_path_list(i).name;
    img = imread(strcat(file_crop_path,img_name));
    img_gray = rgb2gray(img);
    b =  img_feature(img_name,img, img_gray);
    a_crop = [a_crop; b];
end

%%特征提取（detect后的细胞）
img_path_list = dir(strcat(file_detect_path,'*.bmp'));
img_num = length(img_path_list);
a_detect = {};
for i = 1:img_num
    img_name = img_path_list(i).name;
    img = imread(strcat(file_detect_path,img_name));
    img_gray = rgb2gray(img);
    c =  img_feature(img_name,img, img_gray);
    a_detect = [a_detect; c];
end
    
 
%a = write_excel(file_crop_path); 写入excel

%a = write_excel(file_detect_path);写入excel