%--------------------------------------------------------------------------
%�ӽ��е�ͼƬ�н���������ǿ,ͬʱ�����˲�
%--------------------------------------------------------------------------
%����file_path����ͼƬ��ǿ  file_path   img_new_path
%file_path = 'C:\matlab\';
%img_new_path = 'C:\matlab\';
function [] = make_dataset(file_path, file_change_path,file_crop_path)
img_path_list = dir(strcat(file_path,'*.bmp'));
img_num = length(img_path_list);%��ȡϸ����Ƭ����

for i = 1:img_num
    img_name = img_path_list(i).name;
    img = imread(strcat(file_path,img_name));
    img_name = erase(img_name,'.bmp');
    %��ͼƬ���з�ת
    img_new = flip(img,2);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-1.bmp');
    img_new_path = fullfile(file_change_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %�Աȶ�����
    img_new = imadjust(img, [0.3,1], []);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-2.bmp');
    img_new_path = fullfile(file_change_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %ͼ��ƽ��
    [R C] = size(img);
    se = translate(strel(1),[0 round(R/1.5)]);
    img_new = imdilate(img,se);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-3.bmp');
    img_new_path = fullfile(file_change_path, img_new_name);
    imwrite(img_new, img_new_path);
    
    %��ͼ������˹����
    img_new = imnoise(img,'gaussian',0.1,0.02);
    img_new = built_filter(img_new);
    img_new_name = strcat(img_name,'-4.bmp');
    img_new_path=fullfile(file_change_path,img_new_name);   
    imwrite(img_new,img_new_path);

end
%img_new_path = 'C:\matlab\';
img_change_path_list = dir(strcat(file_change_path,'*.bmp'));
img_change_num = length(img_change_path_list);%��ȡϸ����Ƭ����

for k = 1:img_change_num
    img_change_name = img_change_path_list(k).name;
    img_change = imread(strcat(file_change_path,img_change_name));
    img_change_name = erase(img_change_name,'.bmp');
    a=256;%�ü����
    b=256;%�ü�����
    c=10;%ÿ����Ƭ�ü�����
    %size(��һ���������ڶ�������)
    X=size(img_change,1); %��������--
    Y=size(img_change,2); %��������|
    for i = 1:c
        y=randperm(X-128,1);  %x=unidrnd(X-150,1,1);%������������
        x=randperm(Y-128,1);  %y=unidrnd(Y-150,1,1);%������������
        C=imcrop(img_change,[x y a b]);
        img_new_name = strcat(img_change_name,'-',num2str(i),'.bmp');
        img_new_path=fullfile(file_crop_path,img_new_name);   
        imwrite(C,img_new_path);
    end
end