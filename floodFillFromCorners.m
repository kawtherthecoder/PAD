% floodFillFromCorners.m
% Uses corners of rectangle selected by user and returns the shape filled as a binary mask in the image
% Inputs:
% RGN -- image
% xy -- array of corner coordinates (top left, top right, bottom left, bottom right)
% Outputs:
% maskedImage -- binary mask of shape RGN, 1 where shape is filled, 0 else
function maskedImage = floodFillFromCorners(RGN, xy)

maskedImage = false(size(RGN));

maskedImage(xy(1,2):xy(3,2),xy(1,1):xy(2,1)) = 1;
