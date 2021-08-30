% createPairedData.m
% Generates and saves the paired_data structure, which stores water and
% panel selection information and all images that may or may not be
% processed.
% When Kawther ran this code, she only had some of these RAW photos saved
% at the directory (photoname in paired_data) because of downloading issues
% with MCC. If the remaining photos were added, paired data would need to
% be updated. See Preparing image data for analysis (Creating and updating paired_data.mat)
% section on GitHub.
new = 0; % should always be false since data exists in paired_data.mat
if new == 1
    paired_data = struct([]);
else
    load('paired_data.mat');
end
load('photos_RAW.mat'); % raw photos taken in PAD 2019

for i = 1:length(raw)
    paired_data(i).photoname = raw(i).k_name; % file path on Kawther's computer (future users can change this path or update photos_RAW.mat to have their directory)
    paired_data(i).photodate = raw(i).date;
    if isfile(raw(i).k_name) % photo is saved in directory on Kawther's computer
        info=imfinfo(raw(i).k_name);
        paired_data(i).photolat = info.GPSInfo.GPSLatitude;
        paired_data(i).photolat = paired_data(i).photolat(1)+paired_data(i).photolat(2)/60+paired_data(i).photolat(3)/3600;
        paired_data(i).photolon = info.GPSInfo.GPSLongitude;
        paired_data(i).photolon = paired_data(i).photolon(1)+paired_data(i).photolon(2)/60+paired_data(i).photolon(3)/3600;
    else
        paired_data(i).photolat = []; % photo not saved in directory, geolocation not found
        paired_data(i).photolon = [];
    end
    if new == 1
        paired_data(i).tudate = datetime([],'ConvertFrom','datenum');
        paired_data(i).tu = NaN;
        paired_data(i).tss = NaN;
        paired_data(i).panelsel_flag = 0;
    end
end
save('paired_data.mat','paired_data','-v7.3'); % save in current directory