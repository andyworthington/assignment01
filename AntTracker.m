clc;close all;clear;
pause on;

startingFrame = 1;
endingFrame = 448;

Xcentroid = [];
Ycentroid = [];
rgb = imread('ant/img001.jpg');
for k = startingFrame+1 : endingFrame-1
    pos1 = rgb;
    rgb = imread(['ant/img', sprintf('%2.3d',k), '.jpg']);
    pos2 = rgb;
    
    hsvPos1 = rgb2hsv(pos1);
    hsvPos2 = rgb2hsv(pos2);
    subPos1 = hsvPos1(:,:,3);
    subPos2 = hsvPos2(:,:,3);
    
 
    dPos = abs(subPos1-subPos2);
    

    Ithresh = dPos  > 0.035;
 
    
    
    SE = strel('disk', 4,0);
    Iopen = imopen(Ithresh, SE);
   
    Iclose = imclose(Iopen, SE);
    SE = strel('disk', 2,0);
   
    [labels, number] = bwlabel(Iclose, 8);
    Icolor = label2rgb(labels, 'jet', 'k', 'shuffle');
  
    if(number > 0)
        
        Istats = regionprops(labels, 'basic', 'Centroid');
        [values, index] = sort([Istats.Area], 'descend');
        [maxVal, maxIndex] = max([Istats.Area]);
      
        imshow(rgb,'Border', 'Tight')
        hold on;
        
        % Plot centroid
        plot(Istats(maxIndex).Centroid(1), Istats(maxIndex).Centroid(2), 'r*');
    
        Xcentroid = [Xcentroid Istats(maxIndex).Centroid(1)];
        Ycentroid = [Ycentroid Istats(maxIndex).Centroid(2)];
        plot(Xcentroid, Ycentroid, 'k-', 'Linewidth', 30);
        pause(0.005)
%         clf;
    end
end