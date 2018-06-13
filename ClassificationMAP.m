load('classesForIndex');
files = getAllFiles('C:\Users\Jan\Desktop\Training\CarImages\');
fileCount = length(files);

carsClass1Indizes = find(carClasses == 1);
carsClass2Indizes  = find(carClasses == 2);
carsClass3Indizes  = find(carClasses == 3);
carsClass4Indizes  = find(carClasses == 4);
carsClass5Indizes  = find(carClasses == 5);
carsClass6Indizes  = find(carClasses == 6);
carsClass7Indizes  = find(carClasses == 7);
carsClass8Indizes  = find(carClasses == 8);
carsClass9Indizes  = find(carClasses == 9);

L1 = size(carsClass1Indizes,2);
L2 = size(carsClass2Indizes,2);
L3 = size(carsClass3Indizes,2);
L4 = size(carsClass4Indizes,2);
L5 = size(carsClass5Indizes,2);
L6 = size(carsClass6Indizes,2);
L7 = size(carsClass7Indizes,2);
L8 = size(carsClass8Indizes,2);
L9 = size(carsClass9Indizes,2);



featureSize = length(featuresFromImage( imread(fullfile(char(files(1))))));
imageFeatures = zeros(fileCount,featureSize);

% Fill imageFeatures
for i=1:min(fileCount,length(carClasses))
    path = fullfile(char(files(i)));
    im = imread(path);
    c = carClasses(i);
    f = featuresFromImage(im);
    imageFeatures(i,:) = f;
end

carsClass1 = imageFeatures(carsClass1Indizes ,:)';
carsClass2 = imageFeatures(carsClass2Indizes ,:)';
carsClass3 = imageFeatures(carsClass3Indizes ,:)';
carsClass4 = imageFeatures(carsClass4Indizes ,:)';
carsClass5 = imageFeatures(carsClass5Indizes ,:)';
carsClass6 = imageFeatures(carsClass6Indizes ,:)';
carsClass7 = imageFeatures(carsClass7Indizes ,:)';
carsClass8 = imageFeatures(carsClass8Indizes ,:)';
carsClass9 = imageFeatures(carsClass9Indizes ,:)';

p1 = L1 / fileCount;
p2 = L2 / fileCount;
p3 = L3 / fileCount;
p4 = L4 / fileCount;
p5 = L5 / fileCount;
p6 = L6 / fileCount;
p7 = L7 / fileCount;
p8 = L8 / fileCount;
p9 = L9 / fileCount;

mean1 = mean(carsClass1,2);
mean2 = mean(carsClass2,2);
mean3 = mean(carsClass3,2);
mean4 = mean(carsClass4,2);
mean5 = mean(carsClass5,2);
mean6 = mean(carsClass6,2);
mean7 = mean(carsClass7,2);
mean8 = mean(carsClass8,2);
mean9 = mean(carsClass9,2);

carsClass1=carsClass1-mean1*ones(1,L1);
carsClass2=carsClass2-mean2*ones(1,L2);
carsClass3=carsClass3-mean3*ones(1,L3);
carsClass4=carsClass4-mean4*ones(1,L4);
carsClass5=carsClass5-mean5*ones(1,L5);
carsClass6=carsClass6-mean6*ones(1,L6);
carsClass7=carsClass7-mean7*ones(1,L7);
carsClass8=carsClass8-mean8*ones(1,L8);
carsClass9=carsClass9-mean9*ones(1,L9);

Sigma1=carsClass1*carsClass1'/L1;
Sigma2=carsClass2*carsClass2'/L2;
Sigma3=carsClass3*carsClass3'/L3;
Sigma4=carsClass4*carsClass4'/L4;
Sigma5=carsClass5*carsClass5'/L5;
Sigma6=carsClass6*carsClass6'/L6;
Sigma7=carsClass7*carsClass7'/L7;
Sigma8=carsClass8*carsClass8'/L8;
Sigma9=carsClass9*carsClass9'/L9;

if L1 > 0
    W1 = -0.5*pinv(Sigma1);
    w1 = pinv(Sigma1)*mean1;
    w10 = -0.5*mean1'*pinv(Sigma1)*mean1-0.5*log(det(Sigma1))+log(p1);
end

if L2 > 0
    W2 = -0.5*pinv(Sigma2);
    w2 = pinv(Sigma2)*mean2;
    w20 = -0.5*mean2'*pinv(Sigma2)*mean2-0.5*log(det(Sigma2))+log(p2);
end

if L3 > 0
    W3 = -0.5*pinv(Sigma3);
    w3 = pinv(Sigma3)*mean3;
    w30 = -0.5*mean3'*pinv(Sigma3)*mean3-0.5*log(det(Sigma3))+log(p3);
end

if L4 > 0
    W4 = -0.5*pinv(Sigma4);
    w4 = pinv(Sigma4)*mean4;
    w40 = -0.5*mean4'*pinv(Sigma4)*mean4-0.5*log(det(Sigma4))+log(p4);
end

if L5 > 0
    W5 = -0.5*pinv(Sigma5);
    w5 = pinv(Sigma5)*mean5;
    w50 = -0.5*mean5'*pinv(Sigma5)*mean5-0.5*log(det(Sigma5))+log(p5);
end

if L6 > 0
    W6 = -0.5*pinv(Sigma6);
    w6 = pinv(Sigma6)*mean6;
    w60 = -0.5*mean6'*pinv(Sigma6)*mean6-0.5*log(det(Sigma6))+log(p6);
end

if L7 > 0
    W7 = -0.5*pinv(Sigma7);
    w7 = pinv(Sigma7)*mean7;
    w70 = -0.5*mean7'*pinv(Sigma7)*mean7-0.5*log(det(Sigma7))+log(p7);
end

if L8 > 0
    W8 = -0.5*pinv(Sigma8);
    w8 = pinv(Sigma8)*mean8;
    w80 = -0.5*mean8'*pinv(Sigma8)*mean8-0.5*log(det(Sigma8))+log(p8);
end

if L9 > 0
    W9 = -0.5*pinv(Sigma9);
    w9 = pinv(Sigma9)*mean9;
    w90 = -0.5*mean9'*pinv(Sigma9)*mean9-0.5*log(det(Sigma9))+log(p9);
end


retestClasses = zeros(1,length(carClasses));
% Classifikation
for i=1:fileCount
    x = imageFeatures(i,:)';
    
    r = zeros(9,1) - 1e12;
    if L1 > 4
        r(1) = x'*W1*x+w1'*x+w10;
    end
    if L2 > 4
        r(2) = x'*W2*x+w2'*x+w20;
    end
    if L3 > 4
        r(3) = x'*W3*x+w3'*x+w30;
    end
    if L4 > 4
        r(4) = x'*W4*x+w4'*x+w40;
    end
    if L5 > 4
        r(5) = x'*W5*x+w5'*x+w50;
    end
    if L6 > 4
        r(6) = x'*W6*x+w6'*x+w60;
    end
    if L7 > 4
        r(7) = x'*W7*x+w7'*x+w70;
    end
    if L8 > 4
        r(8) = x'*W8*x+w8'*x+w80;
    end
    if L9 > 4
        r(9) = x'*W9*x+w9'*x+w90;
    end
    
    r = real(r);
    [a,classNumber] = max(r);
    retestClasses(i) = classNumber;
end

error = sum(abs(retestClasses(1,1:length(carClasses)) - carClasses) > 0) / fileCount

%plot (imageFeatures(:,1),imageFeatures(:,2),'g.')


function f = featuresFromImage(im)
    %s = [1 1];
    % f = double(reshape(imresize(rgb2gray(im), s),s(1)*s(2),1));
  
    s = [1 1];
    % aspect ratio? Width / height?

       
    f = [std(double(im(:)));mean(im(:));size(im,1);size(im,2)];
   
   
end
