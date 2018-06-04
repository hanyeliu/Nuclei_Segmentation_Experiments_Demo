%==========================================================================
% This code is used to cut the images into many pieces for training and
% testing.
%-------------------------------------------------------------------------
% Author:Lipeng Xie
% Date:2016-12-14
%==========================================================================


function [Img_mask_refine,Img_mixed_edge] = NucleiSeg_postProcess_watershed(Img_ori,Img_mask)
bw = im2bw(Img_mask);
%% step1: ���˵����ظ������ٵİ߿�
bw2 = bwareaopen(bw, 90); %���˵����ظ������� xx �İ߿飨block��

%% step2:����任
D = -bwdist(~bw2);

%% step3:Ϊ������ȷָȷ����С����
mask = imextendedmin(D,2);

%% step4���޸ľ���任�Ľ��������ֻ����Ҫ��λ�þ��оֲ���С
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);

%% step5����ʾ��ֵ�ָ���
bw3 = bw2;
bw3(Ld2 == 0) = 0;
% figure;imshow(bw3)
bw4 = imfill(bw3,'holes'); % ��ն�
bw4 = bwareaopen(bw4, 90); % 2�� ���˵����ظ������� xx �İ߿飨block��

%% step6��Gaussian filter
gausFilter = fspecial('gaussian',[3 3],0.5);
Img_mask_refine = imfilter(bw4,gausFilter,'replicate');

%% step7�����ָ�����ԭʼͼ��Ӧ
Imed = bwperim(bw4); %find edge
Imed = bwmorph(Imed,'dilate',1);

Labelmask = logical(Imed);
mycolormap = zeros(3,3);
mycolormap(1,:)=[0,1,0];
mycolormap(2,:)=[0,0,0];
mycolormap(3,:)=[1,1,0];
%% step8:��edge����ͼ����
Labelimg_black = label2rgb(Labelmask,mycolormap,'k'); 
Labelmask_uint8 = uint8(~Labelmask);
Img_mixed_edge = zeros(size(Img_ori));
for i=1:3
    Img_mixed_edge(:,:,i) = Labelmask_uint8.*Img_ori(:,:,i) + Labelimg_black(:,:,i);
end
Img_mixed_edge = uint8(Img_mixed_edge);
