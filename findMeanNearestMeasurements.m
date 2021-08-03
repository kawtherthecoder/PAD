function [avgTu, avgCon, avgPres, avgDep] = findMeanNearestMeasurements(photoTime, filtered_rsk, thresSec)

upper_bound = photoTime + seconds(thresSec);
lower_bound = photoTime - seconds(thresSec);

avgTu = 0;
avgCon = 0;
avgPres = 0;
avgDep = 0;
len = 0;
for i = 1:length(filtered_rsk)
    if (filtered_rsk(i).time <= upper_bound && filtered_rsk(i).time >= lower_bound)
        avgTu = avgTu + filtered_rsk(i).tb;
        avgCon = avgCon + filtered_rsk(i).cond;
        avgPres = avgPres + filtered_rsk(i).pres;
        avgDep = avgDep + filtered_rsk(i).depth;
        len = len + 1;
    end
end

% take the average tu measurement of all valid times

if len > 0
    avgTu = avgTu / len;
    avgCon = avgCon / len;
    avgPres = avgPres / len;
    avgDep = avgDep / len;
else
    avgTu = NaN;
    avgCon = NaN;
    avgPres = NaN;
    avgDep = NaN;
end