% Modified from calibrate_cam.m: Function for selecting pixels in an image
% (corresponding to calibration panels).
function panel_info = select_all_panels(RGN,panel_colors)
%% apply stretching
for i=1:3
    RGN_stretch(:,:,i)=imadjust(RGN(:,:,i),[0,0.03]);
end
imshow(RGN_stretch);
mp=numel(RGN(:,:,1)); % size in megapixels
R=RGN(:,:,1);
G=RGN(:,:,2);
N=RGN(:,:,3);

%% zoom into panels
zoom on
disp('Zoom in to calibration panels, then press any key.'); pause
zoom off

%% panel four-corner selection
for i = 1:length(panel_colors)
    fprintf('Select %s calibration panel.\n', panel_colors{i})
    disp('Select top left corner');
    topLeft=impoint(gca);
    disp('Select top right corner');
    topRight=impoint(gca);
    disp('Select bottom left corner');
    bottomLeft=impoint(gca);
    disp('Select bottom right corner');
    bottomRight=impoint(gca);
    xy(1,:) = topLeft.getPosition;
    xy(2,:) = topRight.getPosition;
    xy(3,:) = bottomLeft.getPosition;
    xy(4,:) = bottomRight.getPosition;
    xy = round(xy);
    panel_info(i).xy = xy;
    panel_info(i).mask = floodFillFromCorners(RGN,xy);
    panel_info(i).name = panel_colors{i};

    panel_info(i).vals_R=R(panel_info(i).mask);
    panel_info(i).vals_G=G(panel_info(i).mask);
    panel_info(i).vals_N=N(panel_info(i).mask);
    panel_info(i).meanValueR=mean(panel_info(i).vals_R);
    panel_info(i).meanValueG=mean(panel_info(i).vals_G);
    panel_info(i).meanValueN=mean(panel_info(i).vals_N);
    fprintf('Panel %d mask created.\n', i)
end