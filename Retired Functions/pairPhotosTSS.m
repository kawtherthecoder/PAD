% pairPhotosTSS.m
% Pairing the point measurements from the ctd probe with the geolocations of nearest drone photo.
function paired_data = pairPhotosTSS(ctd)

%% extacting geolocation of photos
files = dir('/Users/kawtherrouabhi/Documents/Peace-Athabasca Research/Sample Images/*.jpg');
photoCoords = extractPhotoLocations(files);

%% extracting geolocation of TSS and turbidity measurements
tssCoords = [];
for l = 1:length(ctd)
    tssCoords = vertcat(tssCoords,[ctd(l).lat', ctd(l).lon', ctd(l).tusurf', ctd(l).tss_surf_mean']);
end
for l = 1:length(tssCoords)
    if l <= length(tssCoords) && (sum(isnan(tssCoords(l,:)) > 0))
        tssCoords(l,:) = NaN; % get rid of nan locations and/or measurements
    end
end
tssCoords(isnan(tssCoords)) = [];
tssCoords = reshape(tssCoords,[],4);
assignin('base','tssCoords',tssCoords);

%% pairing photos with nearest TSS/turbidity measurement
for i = 1:length(photoCoords)
    plat = photoCoords(i).lat;
    plon = photoCoords(i).lon;
    % find nearest tss measurement using distance function
    [tlat, tlon, min_tu, min_tss] = findNearestLocation(plat, plon, tssCoords);
    
    % save the photo location, timestamp, filename and tss location,
    % measurements into a struct
    paired_data(i).ptime = photoCoords(i).datetime;
    paired_data(i).pfile = photoCoords(i).filename;
    paired_data(i).plat = plat;
    paired_data(i).plon = plon;
    
    paired_data(i).tlat = tlat;
    paired_data(i).tlon = tlon;
    paired_data(i).tss = min_tss;
    paired_data(i).tu = min_tu;
end
