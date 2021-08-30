% select_panels.m
% Conducting user input of water and panel extraction from an image.
% Inputs:
% RGN -- image of three layers (bands)
% panel_colors -- cell containing color names
% bright -- brightness index used to make the images easier to see (used
% for stretching only to view the image)
% Outputs:
% panel_info -- structure containing information on water and panel
% extraction, such as the pixel values in each band and the mean
function panel_info = select_panels(RGN,panel_colors,bright)
%% apply stretching
for x = 1:3
    RGN_stretch(:,:,x)=imadjust(RGN(:,:,x),[0,bright]);
end
imshow(RGN_stretch);
mp=numel(RGN(:,:,1)); % size in megapixels
R=RGN(:,:,1);
G=RGN(:,:,2);
N=RGN(:,:,3);

%% first, select four corners surrounding water pixels
panel_info(1).name = 'water';
disp('Select open water pixels without shadow or glint.')
disp('Select top left corner');
topLeft=impoint(gca);
disp('Select top right corner');
topRight=impoint(gca);
disp('Select bottom left corner');
bottomLeft=impoint(gca);
disp('Select bottom right corner');
bottomRight=impoint(gca);
xy(1,:) = topLeft.getPosition; % stores coordinates of corners of selected water pixels
xy(2,:) = topRight.getPosition;
xy(3,:) = bottomLeft.getPosition;
xy(4,:) = bottomRight.getPosition;
xy = round(xy);
panel_info(1).xy = xy;
panel_info(1).mask = floodFillFromCorners(RGN,xy); % binary mask of selected water pixels in the picture

% DN values of all pixels (for each band)
panel_info(1).vals_R=R(panel_info(1).mask);
panel_info(1).vals_G=G(panel_info(1).mask);
panel_info(1).vals_N=N(panel_info(1).mask);
% mean of all DN values (for each band)
panel_info(1).meanValueR=mean(panel_info(1).vals_R);
panel_info(1).meanValueG=mean(panel_info(1).vals_G);
panel_info(1).meanValueN=mean(panel_info(1).vals_N);
disp('Water pixels mask created.')

%% zoom into panels
zoom on
disp('Zoom in to calibration panels, then press any key.'); pause
zoom off

%% panel four-corner selection
for i = 2:length(panel_colors)+1
    fprintf('Select %s calibration panel.\n', panel_colors{i-1})
    disp('Select top left corner');
    topLeft=impoint(gca);
    disp('Select top right corner');
    topRight=impoint(gca);
    disp('Select bottom left corner');
    bottomLeft=impoint(gca);
    disp('Select bottom right corner');
    bottomRight=impoint(gca);
    xy(1,:) = topLeft.getPosition; % stores coordinates of corners of panel
    xy(2,:) = topRight.getPosition;
    xy(3,:) = bottomLeft.getPosition;
    xy(4,:) = bottomRight.getPosition;
    xy = round(xy);
    panel_info(i).xy = xy;
    panel_info(i).mask = floodFillFromCorners(RGN,xy); % binary mask of panel within the image
    panel_info(i).name = panel_colors{i-1}; % panel color name
    
    % DN values of all pixels (for each band)
    panel_info(i).vals_R=R(panel_info(i).mask);
    panel_info(i).vals_G=G(panel_info(i).mask);
    panel_info(i).vals_N=N(panel_info(i).mask);
    % mean of all DN values (for each band)
    panel_info(i).meanValueR=mean(panel_info(i).vals_R);
    panel_info(i).meanValueG=mean(panel_info(i).vals_G);
    panel_info(i).meanValueN=mean(panel_info(i).vals_N);
    fprintf('Panel %d mask created.\n', i-1)
        
end
close

%% SAVE? -- gives user option to not save the panel if mistake was made during water/panel selection
disp('SAVE OR DISCARD?');
disp('PRESS 0 TO DISCARD');
disp('PRESS 1 TO SAVE');
in = input('>');
if in == 0
    panel_info = struct([]);
end