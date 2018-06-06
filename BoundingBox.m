classdef BoundingBox < handle
   properties
      ID
      Untouched
      X
      Y
      Width
      Height
      Center
      identified
      history = [];
   end
   methods
     function obj = BoundingBox(bbox)
         obj.Untouched = 0;
         obj.X = bbox(1);
         obj.Y = bbox(2);
         obj.Width = bbox(3);
         obj.Height = bbox(4);
         obj.Center = [obj.X + obj.Width/2, obj.Y + obj.Height/2];
         obj.identified = false;
     end
     function AddNext(obj,bbox)
         obj.history = [obj.history, bbox];
     end
     function lc = GetLastCenter(obj)
         lc = obj.Center;
         if length(obj.history) > 0
             lc = obj.history(length(obj.history)).Center;
         end
     end
      function [x y w h] = GetLastRect(obj)
         x = obj.X;
         y = obj.Y;
         w = obj.Width;
         h = obj.Height;
         if length(obj.history) > 0
             x = obj.history(length(obj.history)).X;
             y = obj.history(length(obj.history)).Y;
             w = obj.history(length(obj.history)).Width;
             h = obj.history(length(obj.history)).Height;
         end
     end
   end
end