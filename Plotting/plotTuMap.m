%% plotting turbidity onto geo basemap of PAD
load('paired_data.mat');

lat = [];
lon = [];
tu = [];
count = 0;
for i = 1:length(paired_data)
    if paired_data(i).panelsel_flag == 1
        lat(length(lat)+1,1) = paired_data(i).photolat;
        lon(length(lon)+1,1) = -1*paired_data(i).photolon;
        tu(length(tu)+1,1) = paired_data(i).tu;
        count = count +1;
    end
end

figure;
geoscatter(lat,lon,[],tu,'filled');
geobasemap satellite;
colormap hot;
c = colorbar; c.Label.String = "Turbidity (NTU)";

data = table(lat,lon,tu);
writetable(data,'tuMapping.csv');
