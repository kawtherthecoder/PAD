% function to plot lat/long/z from EXIF metadata of jpgs.
% updated for PAD data, and to include IR camera field
% NOTE: need to manually create .proj file
% has try catch statement bc some UAV photos don't have GPS stamp (before I
% connect Mavic Mapir GPS antenna)

% version 2 includes fields for date and time
% dir_in='F:\Box Sync\Gleason 2\UAV Data\';
% dir_in='F:\Sask2018\MavicPro1\';
% files=[dir('F:\PAD2019\UAV\*\*\*\*\*.jpg');...
%     dir('F:\PAD2019\UAV\*\*\*\*.jpg');...
%     dir('F:\PAD2019\UAV\*\*\*.jpg');...
%     dir('F:\PAD2019\UAV\*\*.jpg');...
%     dir('F:\PAD2019\UAV\*.jpg')];
function coords = extractPhotoLocations(files)

i=1;
for n= 1:length(files)
    path=[files(n).folder, '/', files(n).name];
    if files(n).bytes > 3000000
        info=imfinfo(path);
        if numel(fieldnames(info)) >= 27
            coords(i).lat=info.GPSInfo.GPSLatitude;
            coords(i).lat=coords(i).lat(1)+coords(i).lat(2)/60+coords(i).lat(3)/3600;
            coords(i).lon=info.GPSInfo.GPSLongitude;
            coords(i).lon=-(coords(i).lon(1)+coords(i).lon(2)/60+coords(i).lon(3)/3600);
            coords(i).z=info.GPSInfo.GPSAltitude;
            coords(i).filename=info.Filename;
            coords(i).datetime=info.DateTime;
            if ~isempty(strfind(coords(i).filename,'Mavic')) & ~isempty(strfind(coords(i).filename,'MAPIR'))
                coords(i).cam='MI'; %mavic ir
            elseif ~isempty(strfind(coords(i).filename,'Phantom')) & ~isempty(strfind(coords(i).filename,'MAPIR'))
                coords(i).cam='PI'; %phantom ir
            elseif ~isempty(strfind(coords(i).filename,'Mavic'))
                coords(i).cam='M'; %mavic
            elseif ~isempty(strfind(coords(i).filename,'Phantom'))
                coords(i).cam='P'; %phantom
            else
                coords(i).cam='NA'; %phantom ir
            end
            if mod(i, 100)==0
                disp(i)
            end
            if isempty(coords(i).filename)
                pause
            end
            i =i+1; % if loop was successful.
        else fprintf('%d: No GPS info\n', n)
        end
    else
        fprintf('%d: File error\n', n)
    end
end
% disp('Finished loop.')
% ctable=struct2table(coords);
% tablePath='F:\PAD2019\UAV\out\csv\PadUAV.csv';
% writetable(ctable, tablePath);
% 
% % write shp
% filesStruct=rmfield(coords, {'lat','long'});
% p= mappoint([coords.long], [coords.lat], filesStruct);
% shapePath='F:\PAD2019\UAV\out\shp\PadUAV.shp';
% shapewrite(p, shapePath);

%% view
% geoshow(shapePath)