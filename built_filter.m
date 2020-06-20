function res = built_filter(img)
% ����˫���˲��Ĳ�����˫���˲�����Ϊ bfilt_gray
r = 3;    % �˲��뾶
a = 3;    % ȫ�ַ���
b = 0.1;  % �ֲ�����

[~,~,ch] = size(img);
% �ж��ǻҶ�ͼ���ǲ�ɫͼ��
if ch == 1   
    res = bfilt_gray(img,r,a,b);
else
    res = bfilt_rgb(img,r,a,b);
end
end
%%  �Ҷ�ͼ˫���˲�
function res = bfilt_gray(img,r,a,b)
% f�Ҷ�ͼ;r�˲��뾶 ;aȫ�ַ���;b�ֲ�����
[x,y] = meshgrid(-r:r);

% ����� �����ĵ㵱��ԭ����ô���������ĵ�ľ����Ϊ(i-k)^2 +(j-l)^2 =k^2+l^2.
% ����(i,j)�����ĵ�����,(k,l)�������������
w_spatial = exp(-( x.^2+y.^2 )/(2*a^2));   % ��ά��˹����Ϊ G(x,y) = 1/(2�Ц�) *  exp(-(x^2 + y^2)/2*��^2)
img = im2double(img); 
 
[m,n] = size(img);
f_temp = padarray(img,[r r],'symmetric');  % ��Ե���֮���ͼ��
res = zeros(m,n);
count = 0; % ��¼�ж��ٸ��������

for i = r+1:m+r
    for j = r+1:n+r
        
        count = count +1;
        temp = f_temp(i-r:i+r,j-r:j+r); % һ���ֲ��������ֵ
       
        w_pixel = exp(  -( temp- img(i-r,j-r) ).^2/(2*b^2)); % ֵ���
        w = w_spatial .* w_pixel;
        s = temp.*w;
    
        res(i-r,j-r) = sum(s(:)) / sum(w(:)); % ����õ��µ�����ֵ
    end

end


end
 
%% ��ɫͼ˫���˲�
% ��ɫͼ��ÿ��ͨ������������
function res = bfilt_rgb(img,r,a,b)
% f�Ҷ�ͼ��r�˲��뾶��aȫ�ַ��b�ֲ�����

res = zeros(size(img)) ;
for i = 1:3
     res(:,:,i) = bfilt_gray(img(:,:,i),r,a,b);
end

end