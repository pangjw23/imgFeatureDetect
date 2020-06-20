%---------------------------------------------------------------------------
%���ڵ����⣺
%�費��Ҫ���ü�֮���ϸ��ͼͳһ��Ϊ256��256
%�����Ƿ��ܹ���Ӧ��ʵ��ϸ��״̬���Ƿ��ܹ��ɹ�ʶ��
%���ɼ���ϸ���Ƿ�Ҫ���з���
%---------------------------------------------------------------------------
%file_path---���ԭʼͼƬ·��   file_change_path---��ת,��ת�Ȳ������ŵ�·��   file_crop_path---�ü����ŵ�·��·��
%file_detect_path---ʶ������ϸ����֮����ô�ŵ�·��
file_path = 'C:\Users\61746\Desktop\file\';
file_change_path = 'C:\Users\61746\Desktop\file_change\';
file_crop_path = 'C:\Users\61746\Desktop\file_crop\';
file_detect_path = 'C:\Users\61746\Desktop\file_detect\';







%��ǿ����
%β��X������ǿ���
make_dataset(file_path, file_change_path, file_crop_path);

%ϸ��ʶ��
%β��0X����ʶ�������ϸ����ǿ���
detect(file_path, file_detect_path);

%%���������ٵ�ϸ��������ǿ
img_path_list = dir(strcat(file_detect_path,'*.bmp'));
img_num = length(img_path_list);
for i = 1:img_num
    img_name = img_path_list(i).name;
    if img_path_list(i).name(1) ~=1 && img_path_list(i).name(1) ~=2
        img = imread(strcat(file_detect_path,img_name));
        
        %���뽷������,֮���˲�
        img_new = imnoise(img,'salt & pepper',0.08);
        img_new = built_filter(img_new);
        img_new_name = strcat(img_path_list(i).name(1:5),'-05.bmp');
        img_new_path = fullfile(file_detect_path, img_new_name);
        imwrite(img_new, img_new_path);
        
        %ͼ����
        H = fspecial('unsharp');
        img_new = imfilter(img,H,'replicate');
        img_new_name = strcat(img_path_list(i).name(1:5),'-06.bmp');
        img_new_path = fullfile(file_detect_path, img_new_name);
        imwrite(img_new, img_new_path);
    end
end

%������ȡ��д��excel
%%������ȡ��Ϊԭͼ��ü�֮�󣬴����ȫ���ǲ��ɼ��ϸ����
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

%%������ȡ��detect���ϸ����
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
    
 
%a = write_excel(file_crop_path); д��excel

%a = write_excel(file_detect_path);д��excel