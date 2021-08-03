function goodTu = extractGoodTuByDatetime(goodTu,smtu,dt,start,stop,ntuthres)
% adds "goodTu" data to goodTu struct based on verification from
% conductivity plot (see smoothTu.m)
% goodTu -- structure containing turbidity data when probe was in the
% water, returned with new data added between two (start and stop) datetimes
% smtu -- output from smoothTu.m, slightly smoothed tu data
% dt -- output from smoothTu.m, datetimes corresponding with smtu
% ntuthres -- getting rid of any tu values under this threshold (0 = none)

dates = dt(dt > start);
dates = dates(dates < stop);

tu = smtu(dt > start);
tu = tu(dates < stop);
x = length(goodTu);
for i = 1:numel(tu)
    if tu(i) > ntuthres
        goodTu(x+i).datetime = dates(i);
        goodTu(x+i).tu = tu(i);
    end
end