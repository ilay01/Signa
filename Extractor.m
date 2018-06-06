saveRoot = "C:\Users\Jan\Desktop\Training\CarImages\";
files = getAllFiles('C:\Users\Jan\Desktop\Training\17343\04\41');
%files = getAllFiles('C:\Users\Jan\Desktop\Training\17343');
%files = getAllFiles('C:\Users\Jan\Desktop\42');
laneSepMask =  rgb2gray(imread('seplanes.jpg')) < 100;

% --------- Track Identification -----------
trackLeftY = 380;
trackleftX1= 0; 
trackleftX2 = 250;

trackMidY = 370;
trackMidX1= 250; 
trackMidX2 = 520;

trackRightY = 220;
trackRightX1= 520; 
trackRightX2 = 680;
% ------------------------------------



file_count = length(files);
findex = 1;
next = imread(fullfile(char(files(findex))));
findex = findex+1;


opticFlow = opticalFlowFarneback;
opticFlow.NeighborhoodSize=5;
opticFlow.FilterSize = 25;

 flow = estimateFlow(opticFlow,rgb2gray(next)); 
 
 % ---------- Shadow -----------
 mgp = [0.000204345345141426];
 SigmaInv = [0.104952610092160,-0.119012800639940,0.0224817048646620;-0.119012800639940,0.204757787612976,-0.0862513240676164;0.0224817048646620,-0.0862513240676164,0.0591157280007801];
% ----------------------------
 
 blob = vision.BlobAnalysis(...
   'CentroidOutputPort', false, ...
   'AreaOutputPort', false, ...
   'BoundingBoxOutputPort', true, ...
   'MinimumBlobAreaSource', 'Property', ...
   'MinimumBlobArea', 5000, ...
   'MaximumBlobArea', 640*480/4);
shapeInserter = vision.ShapeInserter('BorderColor','White');

hdinterlacer = vision.Deinterlacer;

tracker = BoxTracker([trackLeftY trackleftX1 trackleftX2], ...
                     [trackMidY trackMidX1 trackMidX2], ...
                     [trackRightY trackRightX1 trackRightX2]);
carImg = [];
 
while findex <= file_count
    % progression
    findex / file_count * 100
    
    nextFile = fullfile(char(files(findex)));
    prev = next;
    
    next = imread(nextFile);
    %next = hdinterlacer(next);
    nextGray = rgb2gray(next);
    findex = findex+1;
    
    flow = estimateFlow(opticFlow,nextGray); 
    
    myflow = flow.Magnitude;
    s = 2;
    myflow(flow.Magnitude < s) = 0;
    myflow(flow.Magnitude >= s) = 1;
    myflow(flow.Vy <0) = 0;
    myflow(laneSepMask) = 0;
    
    % --------Shadow -------------------
   %{
    b = size(next,2);
    h = size(next,1);
    shadowMask = zeros(h,b);
    for y=1:h
        for x=1:b
           px = double([next(y,x,1) next(y,x,2) next(y,x,3)])';
           pxm =px-m;
           gx = mgp*exp(-.5*(pxm)'*SigmaInv*pxm);
           if(gx >  0.00000001)
                %next(y,x,1) = 255;
                %next(y,x,2) = 0;
                %next(y,x,3) = 0;
                shadowMask(y,x) = 1;
             end
        end
    end
    % next(shadowMask == 1) = 255;
    %}
    %-------------------------------------------------------------
    
    %imshow(shadowMask) ;
    %myflow(shadowMask == 1) = 0;
    %imshow(myflow);
    
    bbox   = step(blob, myflow > 0);
    
    
    % Analyse boxes
    cti = tracker.NewFrame(bbox);
    
    
    for i=1:size(cti,1)
        carImg = imcrop(next,[cti(i,2) cti(i,3) cti(i,4) cti(i,5)]);
        imwrite(carImg,fullfile(char( strcat(strcat(saveRoot,  strrep(nextFile(end-15:end-4),"\","_"), "-" + string(cti(i,1))  + ".jpg")))));
    end
    
     % ============== Visualisation ===========
     
    out    = step(shapeInserter, next, bbox);
    
    % Redraw frames
    for i=1:length(tracker.boxes)
        out = insertShape(out,'Line',[tracker.boxes(i).Center  tracker.boxes(i).GetLastCenter()],'LineWidth',5,'Color','Red');
    end
    
    % Draw bounding rects
    out = insertShape(out,'Line',[trackleftX1 trackLeftY trackleftX2 trackLeftY; 
                                  trackMidX1 trackMidY  trackMidX2 trackMidY;
                                  trackRightX1 trackRightY  trackRightX2 trackRightY;],'LineWidth',5,'Color','Blue');
    
    subplot(1,3,1), imshow(out);
    
    %hold on
    %plot(flow,'DecimationFactor',[5 5],'ScaleFactor',2);
    %hold off 
    subplot(1,3,2), imshow(myflow);
    subplot(1,3,3), imshow(carImg);
    pause(0.05);
    
end



function fileList = getAllFiles(dirName)

  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    fileList = cellfun(@(x) fullfile(dirName,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    fileList = [fileList; getAllFiles(nextDir)];  %# Recursively call getAllFiles
  end
end