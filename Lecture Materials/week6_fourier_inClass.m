clean; 
load('epith.mat');
% x = [randn(1,20),zeros(1,20)];
% y = [randn(1,20),zeros(1,20)];
% X = fft(x);
% Y = fft(y);
% figure; subplot(2,2,1); stem(x); title('x');
% subplot(2,2,2); stem(y); title('y');
% subplot(2,2,3); stem(X); title('X');
% subplot(2,2,4); stem(Y); title('Y');
% 
% convolution = conv(x,y);
% multiplication = X.*Y;
% figure; subplot(1,2,1); stem(convolution);
% subplot(1,2,2); stem(ifft(multiplication));


filter_size = 30;
filter = ones(filter_size);

epith_filtered = conv2(epith,filter);
filter0 = zeros(size(epith)+filter_size);
filter0(1:size(filter,1),1:size(filter,2)) = filter;
epith0(1:size(epith,1),1:size(epith,2)) = epith;

figure; subplot(1,2,1); imagesc(epith0);
subplot(1,2,2); imagesc(filter0);

EPITH0 = fft2(epith0);
FILTER0 = fft2(filter0);
EPITH_FILTERED0 = EPITH0.*FILTER0;

epith_filtered0 = ifft2(EPIHT_FILTERED0);

figure; imagesc(epith_filtered0);
