files = getAllFiles('C:\Users\Jan\Desktop\Training\CarImages\');
load('Trainingsdaten.mat');

timedifference = 7.886;

fileCount = length(files);
carTimes = []
 for j=1:size(Datentrain,1)
    carTimes = [carTimes datetime("25-Jun-2017 " + string(Datentrain{j,3}), 'InputFormat','dd-MM-yyyy HH:mm:ss.SSS') + seconds(timedifference)];
 end
 
 carClasses = [];

for i=1:fileCount
    path = fullfile(char(files(i)));
    hour = path(end-17:end-16);
    minute = path(end-14:end-13);
    second =  path(end-11:end-10);
    millisecond = path(end-8:end-6);
    track = str2double(path(end-4:end-4))-1;
    t = datetime("25-Jun-2017 " + hour + ":" + minute + ":" +second + "." + millisecond, 'InputFormat','dd-MM-yyyy HH:mm:ss.SSS');
    
    % find data index
    ti = 0;
    minTime = 10000000;
    for j=1:size(Datentrain,1)
        tableTime = carTimes(j);
        if  abs(t - tableTime) <  minTime && track == double(Datentrain{j,4})
            minTime = t - tableTime;
            ti = j;
        end
    end
    
   
   % d = abs(milliseconds(t - carTimes(ti)));
   % if(d > 1500)
   %     ti
   % end
   %}
    
    carClasses = [carClasses double(Datentrain{ti,5})];
    
end

save('classesForIndex.mat','carClasses')

