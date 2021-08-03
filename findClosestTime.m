function [closest_tu,closest_time] = findClosestTime(phototime,tu,tutimes)
% finding the closest time within a list to a given time (phototime)
phototime.TimeZone = char.empty;
diff = abs(tutimes - phototime);
closest_time = tutimes(find(diff == min(diff)));
closest_time = closest_time(1);
closest_tu = tu(find(diff == min(diff)));
closest_tu = closest_tu(1);

% return NAN if closest tu measurement taken with over 30 second difference
if abs(closest_time - phototime) > seconds(30)
    closest_time = datetime([],'ConvertFrom','datenum');
    closest_tu = NaN;
end