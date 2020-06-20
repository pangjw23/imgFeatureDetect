function [a] = img_feature(img_name,file_rgb, file_gray)

%��Ԥ����֮���ͼ�����������ȡ
a = {};
%1������ɫ����������ȡ��������ɫ�غͻҶ�ֱ��ͼ
a{1} = img_name;
%��ɫ��(����һ�׶��׺����ף�
firstMoment = mean(mean(file_rgb)); % һ����ɫ��
for m = 1:3
    difference = file_rgb(:,:,m) - firstMoment(1,1,m); %�����ɫ��
    secondMoment(m,1) = sqrt(mean(mean(difference.*difference))); % ������ɫ��
    thirdMoment(m,1) = nthroot(mean(mean(difference.*difference.*difference)),3); % ������ɫ��
end
a{2} = firstMoment;
a{3} = secondMoment;
a{4} = thirdMoment;
%�Ҷ�ֱ��ͼ 
hist_im = imhist(file_gray);

a1 = [0:255];
hist = hist_im/sum(hist_im);

img_mean = a1 * hist;
img_var = (a1-img_mean).^2 * hist; 
img_skewness = ((a1-img_mean).^3 * hist)/((sqrt(img_var))^3);
img_energy = transpose(hist) * hist;
img_entropy = -transpose(hist) * log(hist);

a{5}= img_mean;
a{6}= img_var;
a{7}= img_skewness;
a{8}= img_energy;
a{9}= img_entropy;
%--------------------------------------------------------------------------------------------------------------------------
%2���������������ûҶȹ�������
offsets = [0 1;-1 1;-1 0;-1 -1];
glcm = graycomatrix(file_gray,'GrayLimits',[],'NumLevels',8,'Of',offsets);
stats = graycoprops(glcm,{'contrast','homogeneity','Energy','Correlation'});
a{10}= stats;
%-------------------------------------------------------------------------------------------------------------------------
%3����״����������Ϊ����֮���ϸ������״������Ҫ�����ϸ���˽���������ȡ,����ʵ����ò���أ����Ҷ�ϸ�����ڲ�������䣩

%��ͼ��������������ת����˫������
image=double(file_gray);      

%����Ҷ�ͼ�����׼��ξ� 
m00=sum(sum(image));     
m10=0;
m01=0;
[row,col]=size(image);
for i=1:row
    for j=1:col
        m10=m10+i*image(i,j);
        m01=m01+j*image(i,j);
    end
end
%%%=================���� �� ================================
u10=m10/m00;
u01=m01/m00;
%%%=================����ͼ��Ķ��׼��ξء����׼��ξ�============
m20 = 0;m02 = 0;m11 = 0;m30 = 0;m12 = 0;m21 = 0;m03 = 0;
for i=1:row
    for j=1:col
        m20=m20+i^2*image(i,j);
        m02=m02+j^2*image(i,j);
        m11=m11+i*j*image(i,j);
        m30=m30+i^3*image(i,j);
        m03=m03+j^3*image(i,j);
        m12=m12+i*j^2*image(i,j);
        m21=m21+i^2*j*image(i,j);
    end
end
%%%=================����ͼ��Ķ������ľء��������ľ�============
y00=m00;
y10=0;
y01=0;
y11=m11-u01*m10;
y20=m20-u10*m10;
y02=m02-u01*m01;
y30=m30-3*u10*m20+2*u10^2*m10;
y12=m12-2*u01*m11-u10*m02+2*u01^2*m10;
y21=m21-2*u10*m11-u01*m20+2*u10^2*m01;
y03=m03-3*u01*m02+2*u01^2*m01;
%%%=================����ͼ��Ĺ�����ľ�====================
        n20=y20/m00^2;
        n02=y02/m00^2;
        n11=y11/m00^2;
        n30=y30/m00^2.5;
        n03=y03/m00^2.5;
        n12=y12/m00^2.5;
        n21=y21/m00^2.5;
%%%=================����ͼ����߸������======================
h1 = n20 + n02;                      
h2 = (n20-n02)^2 + 4*(n11)^2;
h3 = (n30-3*n12)^2 + (3*n21-n03)^2;  
h4 = (n30+n12)^2 + (n21+n03)^2;
h5 = (n30-3*n12)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2)+(3*n21-n03)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2);
h6 = (n20-n02)*((n30+n12)^2-(n21+n03)^2)+4*n11*(n30+n12)*(n21+n03);
h7 = (3*n21-n03)*(n30+n12)*((n30+n12)^2-3*(n21+n03)^2)+(3*n12-n30)*(n21+n03)*(3*(n30+n12)^2-(n21+n03)^2);
inv_m7= [h1 h2 h3 h4 h5 h6 h7];  
a{11} = inv_m7;


