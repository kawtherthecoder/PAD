day = datetime(2019,8,11); % CHANGE DATE HERE
dayinfo = struct([]);
load('pad_boatmountedctd_2019.mat')
load('allPADPhotoCoords.mat')

%% organize structure of photo info for the day, filter NaN and too low values
for i = 1:length(geo)
    if geo(i).datetime < day + days(1) && geo(i).datetime > day - days(1) && ~(contains(geo(i).filename,'DJI'))
        % save lat, long, filename, datetime
        x = length(dayinfo)+1;
        dayinfo(x).lat = geo(i).Y;
        dayinfo(x).lon = geo(i).X;
        dayinfo(x).filename = geo(i).filename;
        dayinfo(x).datetime = geo(i).datetime;
    end
end

%% organize the turbidity measurements for the day
rsk = rsk1; % CHANGE RSK HERE
td = extractfield(rsk,'td')';
time = datetime(td,'ConvertFrom','datenum');
tb = extractfield(rsk,'tb')';
for i = 1:length(time)
rsk_all(i).time = time(i);
rsk_all(i).tb = tb(i);
rsk_all(i).cond = rsk.cond(i);
rsk_all(i).pres = rsk.pres(i);
rsk_all(i).depth = rsk.z(i);
end

% collect all tb values that are not NAN and are over 50 and their
% corresponding date,depth,etc
filtered_rsk = struct('time',[],'tb',[],'cond',[],'pres',[],'depth',[]);
for i = 1:length(rsk_all)
    if  (rsk_all(i).tb > 50 && ~isnan(rsk_all(i).tb)) %CREATE NEW STRUCT WO NAN AND GREATER THAN 50
        filtered_rsk(length(filtered_rsk)+1) = rsk_all(i);
    end
end
filtered_rsk(1) = [];

%% for each photo, find the nearest tb measurements taken for the day
for i = 1:length(dayinfo)
    thresSec = 15; % averaging tu measurements plus/minus x seconds from the photo time
    [dayinfo(i).tu,dayinfo(i).cond, dayinfo(i).pres, dayinfo(i).depth]...
        = findMeanNearestMeasurements(dayinfo(i).datetime,filtered_rsk,thresSec);
end

%% plot turbidity on the map!
lat = [];
lon = [];
color = [];
cond = [];
pres = [];
depth = [];
photoTimes = datetime([], 'ConvertFrom', 'datenum');
for i = 1:length(dayinfo)
    if ~(isnan(dayinfo(i).tu))
        lat(length(lat)+1,1) = dayinfo(i).lat;
        lon(length(lon)+1,1) = dayinfo(i).lon;
        color(length(color)+1,1) = dayinfo(i).tu;
        photoTimes(length(photoTimes)+1,1) = dayinfo(i).datetime;
        cond(length(cond)+1,1) = dayinfo(i).cond;
        pres(length(pres)+1,1) = dayinfo(i).pres;
        depth(length(depth)+1,1) = dayinfo(i).depth;
    end
end
figure; geoscatter(lat,lon,[],color)
geobasemap satellite
c = colorbar; c.Label.String = "Mean Turbidity (NTU)";