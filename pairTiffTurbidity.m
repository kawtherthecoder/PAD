% pairTiffTurbidity
% (Used to create/update paired_data when new RAW photos are saved to directory)
% Pairing RAW images to turbidty measurements with the closest time (if closest time is within 30 seconds)

%% load list of raw photos
load('photos_RAW.mat');
load('paired_data.mat');
% load smoothedTu
% extract times of tu as datetime array
tutimes = datetime([],'ConvertFrom','datenum');
for i = 1:length(smoothedTu)
    tutimes(i,1) = smoothedTu(i).datetime;
end
tu = extractfield(smoothedTu,'tu');

%% iterate through list of photos, compare time to list of tu times, finding 
% and saving the closest tu measure if within 30 seconds
for i = 1:length(paired_data)
    % find closest tu measurement and check if within 30 seconds
    if isnan(paired_data(i).tu) && ~isempty(paired_data(i).photolat) % if photo hasn't been matched to tu
        [paired_data(i).tu,paired_data(i).tudate] = findClosestTime(paired_data(i).photodate,tu,tutimes);
    end
end

%% save all info in struct paired_data
save('paired_data.mat','paired_data','-v7.3');
