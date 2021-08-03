function maskedImage = floodFillFromCorners(RGN, xy)

maskedImage = false(size(RGN));

maskedImage(xy(1,2):xy(3,2),xy(1,1):xy(2,1)) = 1;

% % Convert RGB image into L*a*b* color space.
% X = rgb2lab(RGB);
% 
% % Create empty mask.
% BW = false(size(X,1),size(X,2));
% 
% % Flood fill
% row = round(xy(2));
% column = round(xy(1));
% for i=1:3
%     normX{i} = sum((X - X(row,column,i)).^2,3);
%     normX{i} = mat2gray(normX{i});
%     %addedRegion{i} = grayconnected(normX{i}, row, column, tolerance);
%     BW_band{i} = BW | addedRegion{i};
% end
% % Now take intersection of flood fill in each band
% 
% BW=BW_band{1} & BW_band{2} & BW_band{3};
% % Create masked image.
% maskedImage = RGB;
% maskedImage(repmat(~BW,[1 1 3])) = 0;
% 
