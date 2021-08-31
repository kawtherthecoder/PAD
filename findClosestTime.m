% findClosestTime.m
% Matches the closest measurement from the turbidity probe to a given drone
% image.
% Inputs:
% phototime -- datetime photo was taken
% tu -- turbidity probe values (NTU)
% tutimes -- datetimes when turbidity measurements were taken
% Outputs:
% closest_tu -- closest turbdity value to when photo was taken (returns NAN
% if taken over 30 seconds apart)
% closest_time -- datetime of closest turbidty value 
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