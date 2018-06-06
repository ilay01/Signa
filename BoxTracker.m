classdef BoxTracker < handle
   properties
       idCounter = 1;
       boxes = [];
       identificationDistance = 50;
       deleteAfterUntouched = 10;
       track1 = [0 0 0];
       track2 = [0 0 0];
       track3 = [0 0 0];
       ignoreStartsAfter = 200;
   end
   methods
       function obj = BoxTracker(track1, track2, track3)
           obj.track1 = track1;
           obj.track2 = track2;
           obj.track3 = track3;
       end
       
       function toIdentify = NewFrame(obj, bboxes)
           toIdentify = [];
          boxCount = size(bboxes,1);
          
          % Increment untouched
          for i=1:length(obj.boxes)
              obj.boxes(i).Untouched = obj.boxes(i).Untouched + 1;
          end
          
          for i=1:boxCount
              b = BoundingBox(bboxes(i,:));
              
              found = false;
              minIndex = 0;
              minDistance = 100000000;
              % Is bin list?
              for j=1:length(obj.boxes)
                  n =  norm(double(obj.boxes(j).GetLastCenter() - b.Center));
                  if n < minDistance && n < obj.identificationDistance
                    minIndex =j;
                     minDistance = n;
                  end
              end
              
              if minIndex > 0
                   obj.boxes(minIndex).AddNext(b);
                   obj.boxes(minIndex).Untouched = 0;
                   found = true;
              end
              
              if found == false && b.Y < obj.ignoreStartsAfter
                  b.ID = obj.idCounter;
                  obj.idCounter = obj.idCounter + 1;
                  obj.boxes = [obj.boxes b];
              end
              
             
          end
          
          keep = [];
           del = [];
           idenfify = [];
           for i=1:length(obj.boxes)
               [a,b,c,d] = obj.boxes(i).GetLastRect();
               
               bottom = b + d;
               centerX = a+c/2;
               
               % check of bottom 
               trackNo = 0;
               isLeftTrack = centerX > obj.track1(2) && centerX < obj.track1(3);
               isCenterTrack =  centerX > obj.track2(2) && centerX < obj.track2(3);
               isRightTrack = centerX > obj.track3(2) && centerX < obj.track3(3);
               checkBottom = 100000;
               
               if isLeftTrack
                   trackNo = 1;
                   checkBottom = obj.track1(1);
               elseif isCenterTrack
                   trackNo = 2;
                   checkBottom = obj.track2(1);
               else
                   trackNo = 3;
                   checkBottom = obj.track3(1);
               end
               
               if(bottom > checkBottom && ...
                   bottom < 470 && ...
                  obj.boxes(i).Untouched < obj.deleteAfterUntouched)
                  if(obj.boxes(i).identified == false)
                       v = [trackNo a b c d];
                       obj.boxes(i).identified = true;
                       toIdentify = vertcat(toIdentify,v);
                  end
                  keep = [keep i];
               elseif obj.boxes(i).Untouched >= obj.deleteAfterUntouched
                    del = [del i];
               else
                   keep = [keep i];
               end
           end
           obj.boxes = obj.boxes(keep);
      end
   end
end