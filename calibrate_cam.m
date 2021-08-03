function water = calibrate_cam()
% script to calibrate NIR camera to reflectance
% TODO: replace impoly with impoint and floodfill
clear; close all
%% user params
selectpanels=1; % load panels from file
tolerance=0.008; % for flood fill
%% other params
panel_colors={'pink', 'grey', 'black', 'yellow', 'white', 'red'};
labels=categorical(panel_colors);

%% load image
% RGN=imread('C:\Users\lsmith.DESKTOP-JJ8STSU\Desktop\ETHAN\mapir_cal_test\2019_0811_183448_349.JPG');
% RGN=imread('C:\Users\lsmith.DESKTOP-JJ8STSU\Desktop\ETHAN\mapir_cal_test\part3\Processed_1\2019_0812_160547_213.tif');
% RGN=imread('C:\Users\lsmith.DESKTOP-JJ8STSU\Desktop\ETHAN\mapir_cal_test\part3\Processed_1\2019_0812_122030_127.tif');
% RGN=imread('F:\PAD2019\mapir_cal_test\part3\Processed_1\2019_0812_122030_127.tif');
%RGN=imread('/Users/kawtherrouabhi/Documents/Peace-Athabasca Research/Sample Images/2019_0812_122030_127.tif');
%RGN=imread('/Users/kawtherrouabhi/Documents/Peace-Athabasca Research/Sample Images/2019_0812_115517_184.JPG');
%RGN=imread('/Users/kawtherrouabhi/Documents/Peace-Athabasca Research/Sample Images/2019_0812_122149_150.JPG');
RGN=imread('/Users/kawtherrouabhi/Documents/Peace-Athabasca Research/Sample Images/2019_0812_160410_186.JPG');

for i=1:3
    RGN_stretch(:,:,i)=imadjust(RGN(:,:,i),[0,0.3]);
end
h=imshow(RGN_stretch);
mp=numel(RGN(:,:,1)); % size in megapixels
R=RGN(:,:,1);
G=RGN(:,:,2);
N=RGN(:,:,3);

%% select cal panels
% panel order: 1-pink, 2-grey, 3-black, 4-yellow, 5-white, 6-red
if selectpanels==1
    zoom on
    disp('Zoom in to calibration panels, then press any key.'); pause
    zoom off
    for i=1:6
%         p(i).poly=impoly(gca);
%         panel(i).mask=p(i).poly.createMask;
        fprintf('Select %s calibration panel.\n', panel_colors{i})
        %panel(i).seed = impoint(gca);
        disp('Select top left corner');
        panel(i).topLeft=impoint(gca);
        disp('Select top right corner');
        panel(i).topRight=impoint(gca);
        disp('Select bottom left corner');
        panel(i).bottomLeft=impoint(gca);
        disp('Select bottom right corner');
        panel(i).bottomRight=impoint(gca);
        xy(1,:) = panel(i).topLeft.getPosition;
        xy(2,:) = panel(i).topRight.getPosition;
        xy(3,:) = panel(i).bottomLeft.getPosition;
        xy(4,:) = panel(i).bottomRight.getPosition;
        xy = round(xy);
        panel(i).mask = floodFillFromCorners(RGN,xy);
        
        %panel(i).mask=floodFillFromPt(RGN, panel(i).seed.getPosition, tolerance);
        panel(i).vals_R=R(panel(i).mask);
        panel(i).vals_G=G(panel(i).mask);
        panel(i).vals_N=N(panel(i).mask);
        panel(i).meanValueR=mean(panel(i).vals_R);
        panel(i).meanValueG=mean(panel(i).vals_G);
        panel(i).meanValueN=mean(panel(i).vals_N);
        fprintf('Panel %d mask created.\n', i)
    end
else load('panels.mat');
end;
fprintf('\tFinished selecting panels.\n')
all_panels = panel(1).mask+2*panel(2).mask+3*panel(3).mask+4*panel(4).mask+5*panel(5).mask+6*panel(6).mask;
%%%%%%%%%%%%%%%%%%%%%%figure; imagesc(all_panels)
% all_panels(:,:,1:3) = all_panels;
% panel_check=double(RGN_stretch) +  300*all_panels;
% for i=1:3
%     panel_check(:,:,i)=imadjust(panel_check(:,:,i));
% end
% all_masks = int(panel(1).mask+panel(2).mask+panel(3).mask+panel(4).mask+panel(5).mask+panel(6).mask);
% panel_check = RGN_stretch;
% panel_check(all_masks) = 0; % ---- how is all_masks 3d? find a way to display rng stretch with panel mask overlay
% figure;
% imagesc(panel_check)
disp('Are the panels selected properly?')
%%%%%%%%%%%%%%%%%%%drawnow
%% plot cal panel reflectances
% figure;
% subplot(311); h1=bar([panel.meanValueR], 'r'); title('Red band'); set(gca, 'XTickLabel', {})
% subplot(312); h2=bar([panel.meanValueG], 'g'); title('Green band'); set(gca, 'XTickLabel', {})
% subplot(313); h3=bar(labels, [panel.meanValueN], 'm'); title('NIR band')

%% load actual reflectance values per panel color

% TODO!  

%% select water via flood fill

disp('Select open water pixels without shadow or glint.')
%panel(i).seed = impoint(gca);
disp('Select top left corner');
water(1).topLeft=impoint(gca);
disp('Select top right corner');
water(1).topRight=impoint(gca);
disp('Select bottom left corner');
water(1).bottomLeft=impoint(gca);
disp('Select bottom right corner');
water(1).bottomRight=impoint(gca);
xy(1,:) = water(1).topLeft.getPosition;
xy(2,:) = water(1).topRight.getPosition;
xy(3,:) = water(1).bottomLeft.getPosition;
xy(4,:) = water(1).bottomRight.getPosition;
xy = round(xy);
water(1).mask = floodFillFromCorners(RGN,xy);

%panel(i).mask=floodFillFromPt(RGN, panel(i).seed.getPosition, tolerance);
water(1).vals_R=R(water(1).mask);
water(1).vals_G=G(water(1).mask);
water(1).vals_N=N(water(1).mask);
water(1).meanValueR=mean(water(1).vals_R);
water(1).meanValueG=mean(water(1).vals_G);
water(1).meanValueN=mean(water(1).vals_N);
disp('Water pixels mask created.')

water(1).metric = log(water(1).meanValueN/water(1).meanValueR);

%% Compute water reflectance using calibration curve

% TODO!  
