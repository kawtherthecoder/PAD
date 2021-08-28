function [minlat, minlon, min_tu, min_tss, mindist] = findNearestLocation(pointlat, pointlon, tssCoords)
% finds the nearest geolocation from a point (pointlat, pointlon) to a list
% of geolocations (tssCoords)

% returns the geolocation within the list closest to the given point

dist = [];
for i = 1:length(tssCoords)
    dist(i) = distance(pointlat,pointlon,tssCoords(i,1),tssCoords(i,2));
end

mindist = min(dist);
ind = find(dist == mindist,1);
mindist = deg2km(mindist);

minlat = tssCoords(ind,1);
minlon = tssCoords(ind,2);
min_tu = tssCoords(ind,3);
min_tss = tssCoords(ind,4);