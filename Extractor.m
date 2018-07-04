saveRoot = "C:\Users\Jan\Desktop\Training\CarImages2\";
files = getAllFiles('C:\Users\Jan\Desktop\Training\17343');
%files = getAllFiles('C:\Users\Jan\Desktop\Training\17343');
%files = getAllFiles('C:\Users\Jan\Desktop\Training\04\00');
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

% Configurate Optical Flow
opticFlow = opticalFlowFarneback;
opticFlow.NeighborhoodSize=5;
opticFlow.FilterSize = 25;

 flow = estimateFlow(opticFlow,rgb2gray(next)); 
 
 % Configurate Blob analysis
 blob = vision.BlobAnalysis(...
   'CentroidOutputPort', false, ...
   'AreaOutputPort', false, ...
   'BoundingBoxOutputPort', true, ...
   'MinimumBlobAreaSource', 'Property', ...
   'MinimumBlobArea', 5000, ...
   'MaximumBlobArea', 640*480/4);
shapeInserter = vision.ShapeInserter('BorderColor','White');


tracker = BoxTracker([trackLeftY trackleftX1 trackleftX2], ...
                     [trackMidY trackMidX1 trackMidX2], ...
                     [trackRightY trackRightX1 trackRightX2]);
carImg = [];
 
while findex <= file_count
    % progression
    findex / file_count * 100
    
    % Read Next Fuke
    nextFile = fullfile(char(files(findex)));
    prev = next;
    
    next = imread(nextFile);
    nextGray = rgb2gray(next);
    findex = findex+1;
    
    % Calculate optical glow
    flow = estimateFlow(opticFlow,nextGray); 
    
    % Apply threshhold to flow field
    myflow = flow.Magnitude;
    s = 2;
    myflow(flow.Magnitude < s) = 0;
    myflow(flow.Magnitude >= s) = 1;
    
    % Cut of upmoving stuff
    myflow(flow.Vy <0) = 0;
    
    % Apply Lane mask
    myflow(laneSepMask) = 0;
    
    % Analyse blobs
    bbox   = step(blob, myflow > 0);
        
    % Keep track of Bounding Boxes
    cti = tracker.NewFrame(bbox);
        
    % Loop through boxes wich reached the classify position
    for i=1:size(cti,1)
        % Crop car image
        carImg = imcrop(next,[cti(i,2) cti(i,3) cti(i,4) cti(i,5)]);
        
        % Save car image
        imwrite(carImg,fullfile(char( strcat(strcat(saveRoot,  strrep(nextFile(end-15:end-4),"\","_"), "-" + string(cti(i,1))  + ".jpg")))));
    end
    
     % ============== Visualisation ===========
     % (decomment for visualisation)
  %{
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
 %}
    
end

