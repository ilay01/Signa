shadows = getAllFiles('C:\Users\Jan\Desktop\Training\ShadowTrain\Shadow');
noneShadow = getAllFiles('C:\Users\Jan\Desktop\Training\ShadowTrain\NoneShadow');

featureLength = length(ExtractShadowFeature(shadows(1)));
shadowFeatures = zeros(featureLength, length(shadows));
noneShadowFeatures = zeros(featureLength, length(noneShadow));


for i=1:length(shadows)
    shadowFeatures(:,i) = ExtractShadowFeature(shadows(i));
end
for i=1:length(noneShadow)
    noneShadowFeatures(:,i) = ExtractShadowFeature(noneShadow(i));
end

mean1 =  mean(shadowFeatures,2);
mean2 =  mean(noneShadowFeatures,2);

shadowFeaturesMF = shadowFeatures - mean1*ones(1,length(shadows));
noneShadowFeaturesMF = noneShadowFeatures - mean2*ones(1,length(noneShadowFeatures));

Sigma1 = shadowFeaturesMF*shadowFeaturesMF'/length(shadows);
Sigma2 = noneShadowFeaturesMF*noneShadowFeaturesMF'/length(noneShadow);

W1 = -0.5*pinv(Sigma1);
w1 = pinv(Sigma1)*mean1;
w10 = -0.5*mean1'*pinv(Sigma1)*mean1-0.5*log(det(Sigma1));

W2 = -0.5*pinv(Sigma2);
w2 = pinv(Sigma2)*mean2;
w20 = -0.5*mean2'*pinv(Sigma2)*mean2-0.5*log(det(Sigma2));

% INFO: A priory wahrscheinlichkeit weggelassen

% Test
allFeatures = [shadowFeatures noneShadowFeatures];
label = [ones(1,length(shadows)) zeros(1,length(noneShadowFeatures)) ];
retestClasses = zeros(1,length(label));
for i=1:length(allFeatures)
     x = allFeatures(:,i);
     r = zeros(2,1) - 1e12;
     r(1) = x'*W1*x+w1'*x+w10;
     r(2) = x'*W2*x+w2'*x+w20;
     [a,classNumber] = max(r);
     retestClasses(i) = 2-classNumber;
end

error = sum(abs(retestClasses - label) > 0)
    

%scatter(shadowFeatures(:,1),shadowFeatures(:,2));
%hold on;
%scatter(noneShadowFeatures(:,1),noneShadowFeatures(:,2));

