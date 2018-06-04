%==========================================================================
% This code is used to generate images by image augmentation methods.
%-------------------------------------------------------------------------
% Author:Lipeng Xie
% Date:2017-08-7
%==========================================================================
function ImageDataGenerator_withmask(Img_ori,mask_ori,save_prefix,save_to_dir,para_imgaug)
Img_ori = im2double(Img_ori);
mask_ori = mask_ori(:,:,1)>0;
%% step 1: remove points
[H,W,C] = size(Img_ori);
[r,c] = find(mask_ori);
hsize = ceil(para_imgaug.cropsize/2);
toremove = r-hsize<1 | r+hsize>H | c-hsize<1 | c+hsize>W;
r(toremove)=[]; %remove them from the list
c(toremove)=[]; %remove them from the list
idx=randperm(length(r)); %generate a permuted list
r=r(idx);   %permute the list
c=c(idx);
ni=min(length(r),round(para_imgaug.maxnum)); %figure out how many we're going to take,

parfor i=1:ni
    %% step 2: random crop
     randH = r(i);
     randW = c(i);
     patch_img = Img_ori(randH-hsize:randH+hsize-1,randW-hsize:randW+hsize-1,:);
     patch_mask = mask_ori(randH-hsize:randH+hsize-1,randW-hsize:randW+hsize-1,:);
     
    %% step 3: random fliplr
    if para_imgaug.random_fliplr
        if randi([0,1],1,1)
            patch_img = fliplr(patch_img);
            patch_mask = fliplr(patch_mask);
        end
    end
 %% step 4: random flipup
     if para_imgaug.random_flipup
          if randi([0,1],1,1)
              patch_img = flipud(patch_img);
              patch_mask = flipud(patch_mask);
          end
     end
  %% step5: random dropout
    if para_imgaug.random_dropout
        randnM = randi([1,100],para_imgaug.cropsize,para_imgaug.cropsize);
        randnM = randnM > 3;
        patch_img = patch_img.* repmat(randnM,1,1,C);
    end
   %% step6: save patch and mask
   imwrite(patch_img,[save_to_dir save_prefix '_' int2str(i) para_imgaug.save_format]);
   imwrite(patch_mask,[save_to_dir save_prefix '_' int2str(i) '_l' para_imgaug.save_format]);
end

