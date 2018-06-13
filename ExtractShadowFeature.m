function f = ExtractShadowFeature(file)
    im = double(imread(fullfile(char(file))));
    area = size(im,1)*size(im,2);
    r = reshape(im(:,:,1),1,area);
    g = reshape(im(:,:,2),1,area);
    b = reshape(im(:,:,3),1,area);
        
    f = reshape(imresize(im(:,:,1),[4 4]),16,1);
    f = [f ;size(im,1);size(im,2)];
    %f = [mean(g);mean(b);std(r);std(b);size(im,1);size(im,2)];
    %;std(g)
    
    %f = [mean(im(:)); std(im(:))];
end