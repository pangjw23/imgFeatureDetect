%------------------------------------------------------------------------------------------------
%detect�������ܣ���ͼƬ���ҵ����ϸ���˵�ϸ������������Ϊ��Ҫ��������ϸ��������ֵΪ���м���֮���ͼƬ
%����ͼƬ��1��ʼ���ε�������������
%˫���˲�
%------------------------------------------------------------------------------------------------
function [] = detect(file_path, file_detect_path)
%ʶ��һ��ͼƬ�еĵ���ϸ��
img_path_list = dir(strcat(file_path,'*.bmp'));
img_num = length(img_path_list);%��ȡϸ����Ƭ����
%figure,imshow(RGB)
for i =1:img_num
    img_name = img_path_list(i).name;
    img_rgb = imread(strcat(file_path,img_name));
    img_name = erase(img_name,'.bmp');
    I = rgb2gray(img_rgb);
    se = strel('disk',20);
    I2 = imbothat(I,se);  % ��ñ�任��ȥ�������ȱ���
    %figure,imshow(I2) 
    I3 = imadjust(I2);   % ���ڻҶȶԱȶ�
    
    % �Ҷ�ͼ���ֵ����ȫ����ֵ�ָ������䷽�� 
    level = graythresh(I3);
    BW = im2bw(I3,level);
    imLabel = bwlabel(BW);                %�Ը���ͨ����б��
    stats = regionprops(imLabel,'Area');    %�����ͨ��Ĵ�С
    area = cat(1,stats.Area);
    index = find(area == max(area));        %�������ͨ�������
    img = ismember(imLabel,index); 
    F1 = imfill(img,'holes');
    %figure,imshow(F1)   %�������ͨ������ڲ��������
    BB=regionprops(img,'BoundingBox');%�õ����ο� ȥ��סÿһ����ͨ��
    %��ÿ�����ο���м�¼����¼�����Ͻǵ㣬������   Ȼ��ת���ɾ�����ʽ
    BB1=struct2cell(BB);
    BB2=cell2mat(BB1);
    img_max = imcrop(img_rgb,[BB2(1),BB2(2),BB2(3),BB2(4)]);
    
    %�ü�֮���ԭͼ��
    img_max = built_filter(img_max);
    img_new_name = strcat(img_name,'-01.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_max, img_new_path);
    
    %�ü�֮���ͼ����з�ת
    img_new = flip(img_max,2);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-02.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %�ü�֮���ͼ�����ӶԱȶ�
    img_new = imadjust(img_max, [0.3,1], []);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-03.bmp');
    img_new_path = fullfile(file_detect_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %�����˹����
    img_new = imnoise(img_max,'gaussian',0.1,0.02);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-04.bmp');
    img_new_path=fullfile(file_detect_path,img_new_name);   
    imwrite(img_new,img_new_path);
%figure,imshow(img_max)
end