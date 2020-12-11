function result = colorcorrection2(img)
% Alex Hankin wrote this code! 
% In 2019 for EE193 class _ was used for final project 

% White Patch Algorithm
S=sum(img,3);
[M,I] = maxk(S(:),1000);

% get indices of 1000 brightest pixels
[I_row, I_col] = ind2sub(size(S),I); 

% initialize
white_r_sum=0;
white_g_sum=0;
white_b_sum=0;

for i=1:1000
    white_r_sum = white_r_sum + img(I_row(i), I_col(i),1);
    white_g_sum = white_g_sum + img(I_row(i), I_col(i),2);
    white_b_sum = white_b_sum + img(I_row(i), I_col(i),3);
end
% get channel values associated with average of 1000 brightest pixels
white_r_avg=white_r_sum/1000;
white_g_avg=white_g_sum/1000;
white_b_avg=white_b_sum/1000;

% max channel val at brightest pixel
max_channel=max([white_r_avg white_g_avg white_b_avg]); 

% scale factors to make red=blue=green at brightest pixel
rc_w=max_channel/white_r_avg; 
gc_w=max_channel/white_g_avg;
bc_w=max_channel/white_b_avg; 

% Gray World Algorithm
gray_val=127.5;
mean_r=sum(sum(img(:,:,1)))/numel(img(:,:,1));
mean_g=sum(sum(img(:,:,2)))/numel(img(:,:,2));
mean_b=sum(sum(img(:,:,3)))/numel(img(:,:,3));

% scale factors to make average channel val equal to "gray"
rc_g= gray_val/mean_r;
gc_g= gray_val/mean_g; 
bc_g= gray_val/mean_b; 

% Average the Gray World and White Patch scale factors
mean_rc=mean([rc_g rc_w]);
mean_gc=mean([gc_g gc_w]);
mean_bc=mean([bc_g bc_w]);

% figure(5)
% histogram(img(:,:,1));
% figure(6)
% histogram(img(:,:,2));
% figure(7)
% histogram(img(:,:,3));

% scale all the pixels with the averaged scale factors
img_cc_r=img(:,:,1);
img_cc_g=img(:,:,2);
img_cc_b=img(:,:,3);
img_cc_r= img_cc_r.*mean_rc;
img_cc_g = img_cc_g.*mean_gc;
img_cc_b = img_cc_b.*mean_bc;

% clip values !! Very important
img_cc_r(img_cc_r > 255) = 255;
img_cc_g(img_cc_g > 255) = 255;
img_cc_b(img_cc_b > 255) = 255;
img_cc_r(img_cc_r < 0) = 0;
img_cc_g(img_cc_g < 0) = 0;
img_cc_b(img_cc_b < 0) = 0;

% add all the image pieces together
img_cc=cat(3,img_cc_r,img_cc_g,img_cc_b);

result=img_cc;

