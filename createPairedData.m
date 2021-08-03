%% create paired data structure
new = 0;
if new == 1
    paired_data = struct([]);
else
    load('paired_data.mat');
end
load('photos_RAW.mat'); % make it not overwrite tu stuff when rerun

for i = 1:length(raw)
    paired_data(i).photoname = raw(i).k_name;
    paired_data(i).photodate = raw(i).date;
    if isfile(raw(i).k_name)
        info=imfinfo(raw(i).k_name);
        paired_data(i).photolat = info.GPSInfo.GPSLatitude;
        paired_data(i).photolat = paired_data(i).photolat(1)+paired_data(i).photolat(2)/60+paired_data(i).photolat(3)/3600;
        paired_data(i).photolon = info.GPSInfo.GPSLongitude;
        paired_data(i).photolon = paired_data(i).photolon(1)+paired_data(i).photolon(2)/60+paired_data(i).photolon(3)/3600;
    else
        paired_data(i).photolat = [];
        paired_data(i).photolon = [];
    end
    if new == 1
        paired_data(i).tudate = datetime([],'ConvertFrom','datenum');
        paired_data(i).tu = NaN;
        paired_data(i).tss = NaN;
        paired_data(i).panelsel_flag = 0;
    end
end
save('paired_data.mat','paired_data','-v7.3');