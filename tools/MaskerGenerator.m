%==========================================================================
% This functiom is used to generate interval between objects for image
%-------------------------------------------------------------------------
% Author:Lipeng Xie
% Date:2017-08-08
%==========================================================================
function [Masker_mask, Masker_weight ]= MaskerGenerator(mask, scalar)
[H,W]=size(mask);
%% step1:����任
D = -bwdist(~mask);

%% step2:Ϊ������ȷָȷ����С����
Masker_mask = imextendedmin(D,scalar);

%% step3:����Ȩֵ
Num1 = sum(Masker_mask(:));
TotalNum = H*W;
Num2 = TotalNum - Num1;
Weight_class = Masker_mask.*(Num2/TotalNum) + (~Masker_mask).*(Num1/TotalNum);

Masker_weight = double(Weight_class + Masker_mask.*(1./(1+exp(D./10))));
