% smoothTu.m
% Removing outliers and smoothing turbidity measurements -- before matching to photos
% Inputs:
% rsk -- rsk1, rsk2, or rsk3 depending on the date (see pad_boatmountedctd_2019.mat description)
% Outputs:
% smoothedTu -- structure containing datetimes, turbidity values, and conductivity values after smoothing and removal of outliers
function smoothedTu = smoothTu(rsk)
tb = extractfield(rsk,'tb')';
cond = extractfield(rsk,'cond')';
time = datetime(extractfield(rsk,'td'),'ConvertFrom','datenum')';
window = 270;
smwindow = 200;
indices = 1:window:numel(tb);
newtu = []; %labels the outliers
tu = [];
selcond = [];
newtime = datetime([],'ConvertFrom','datenum');
for i = 1:numel(indices)-1
    chunk = tb(indices(i):indices(i+1),1);
    tuout = isoutlier(chunk, 'percentiles',[17 25]); % change percentile interval of non-outliers
    newtu = vertcat(newtu,tuout); % whether or not the point is an outlier
    newtime = vertcat(newtime,time(indices(i):indices(i+1),1));
    tu = vertcat(tu,tb(indices(i):indices(i+1),1));
    selcond = vertcat(selcond,cond(indices(i):indices(i+1),1));
end

% high-level conductivity filter -- take out values <0.05 mS/cm
ind = find(selcond < 0.05);
for i = ind
    tu(ind) = [];
    newtu(ind) = [];
    newtime(ind) = [];
    selcond(ind) = [];
end

figure; scatter(newtime,tu,[],newtu)
ylabel('Turbidity (NTU)');

tu1 = tu(newtu == 0);
nt1 = newtime(newtu == 0);
selcond1 = selcond(newtu == 0);
smtu1 = smoothdata(tu1,'gaussian',smwindow); % change smoothing window size
figure;
yyaxis left
plot(nt1,tu1)
hold on
plot(nt1,smtu1,'magenta');
ylabel('Turbidity (NTU)');
yyaxis right
plot(nt1,selcond1)
ylabel('Conductivity (mS/cm)');

% return smoothed tu data as structure
smoothedTu = struct([]);
for i = 1:length(selcond1)
    smoothedTu(i).datetime = nt1(i);
    smoothedTu(i).tu = smtu1(i);
    smoothedTu(i).cond = selcond1(i);
end
