load('classesForIndex');
files = getAllFiles('C:\Users\Jan\Desktop\Training\CarImages\');
fileCount = length(files);

% Permutation
trainCount = int32(fileCount / 3 * 2);
trainIndizes = randperm(fileCount);
trainIndizes = trainIndizes(1:trainCount);
testIndizes = setdiff(1:fileCount,trainIndizes);
%

featureSize = length(featuresFromImage( imread(fullfile(char(files(1))))));
imageFeatures = zeros(fileCount,featureSize);

% Fill imageFeatures
for i=1:min(fileCount,length(carClasses))
    path = fullfile(char(files(i)));
    im = imread(path);
    f = featuresFromImage(im);
    imageFeatures(i,:) = f;
end

[wcoeff,~,~,~,explained] = pca(imageFeatures);

subImageFeatures = zeros(size(imageFeatures,1), ...
                         length(subFeatureSelection(imageFeatures(1,:),wcoeff)));

% Subfeature Selection
for i=1:size(imageFeatures,1)
     subImageFeatures(i,:) = subFeatureSelection(imageFeatures(i,:),wcoeff);
end

X = double(subImageFeatures(trainIndizes,:));
Y = int32(carClasses(trainIndizes))';

XTest = double(subImageFeatures(testIndizes,:));
YTest = int32(carClasses(testIndizes))';

 Mdl = fitcecoc(X,Y,'Learners','tree');
 
 errorTrain = sum(abs(predict(Mdl,X) - Y) > 0) / double(trainCount)
 errorTest = sum(abs(predict(Mdl,XTest) - YTest) > 0) / length(YTest)
 
 
 function f = featuresFromImage(im)
    s = [64 64];
    f = [size(im,1);size(im,2);double(reshape(imresize(rgb2gray(im), s),s(1)*s(2),1))];
    %f = [std(double(im(:)));mean(im(:));size(im,1);size(im,2)];
 end

 function f = subFeatureSelection(v,w)
    tran = w*v';
    f = tran(:);
    %f = v;
 end
