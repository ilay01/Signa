%% Read Images:

%im = imread('ng_00_20.851-1.jpg');
im = imread('C:\Users\Jan\Desktop\Training\17343\04\02\23.483.jpg');
figure, imshow(im);

% Medianfilter
r = medfilt2(double(im(:,:,1)), [3,3]); 
g = medfilt2(double(im(:,:,2)), [3,3]);
b = medfilt2(double(im(:,:,3)), [3,3]);

%% Calculate Shadow Mask

shadow_ratio = ((4/pi).*atan(((b-g))./(b+g)));
figure(1), imshow(shadow_ratio, []); colormap(jet); colorbar;

% Threshold auf 0.05 gesetzt. Bei gr??eren Werten weniger Schatten
% detektiert
shadow_mask = shadow_ratio>0.05;
figure(2), imshow(shadow_mask, []); 

%% 
shadow_mask(1:5,:) = 0;
shadow_mask(end-5:end,:) = 0;
shadow_mask(:,1:5) = 0;
shadow_mask(:,end-5:end) = 0;

% Treshold f?r die Gr??e der Schatten
shadow_mask = bwareaopen(shadow_mask, 1000);
[x,y] = find(imdilate(shadow_mask,strel('disk',2))-shadow_mask);

figure, imshow(im); hold on,
plot(y,x,'.b'), title('Shadow Boundaries');
