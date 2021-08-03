function [train,test] = makeDataTable(refRGNTu)
% FIRST run plotTuNormRef to get all updated refRGNTu (reflectance values)
R = [];
G = [];
N = [];
AVG = [];
Tu = [];
Day = [];
train_perc = 0.8;
for i = 1:length(refRGNTu)
    R(length(R)+1,1) = refRGNTu(i).refR;
    G(length(G)+1,1) = refRGNTu(i).refG;
    N(length(N)+1,1) = refRGNTu(i).refN;
    AVG(length(AVG)+1,1) = mean([R(length(R),1),G(length(G),1),N(length(N),1)]);
    Tu(length(Tu)+1,1) = refRGNTu(i).tu;
    Day(length(Day)+1,1) = day(refRGNTu(i).photodate);
end

% test/train split -- stratified random sampling
ind = 1:length(R);
rng 'shuffle'
ind = ind(randperm(length(ind)));
testind = []; trainind = [];

aug12test = round(numel(find(Day == 12))/length(Day)*(1-train_perc)*length(Day));
for i = ind
    if length(testind) < aug12test && Day(i) == 12
        testind(length(testind)+1,1) = i;
    elseif length(testind) < aug12test && Day(i) == 13
        trainind(length(trainind)+1) = i;
    elseif length(testind) < (1-train_perc)*length(Day) && Day(i) == 13
        testind(length(testind)+1,1) = i;
    else
        trainind(length(trainind)+1) = i;
    end
end

r = R(trainind); g = G(trainind); n = N(trainind); tu = Tu(trainind);
avg = AVG(trainind);
%train = table(r,g,n,tu);
train = table(r,g,n,avg,tu);
r = R(testind); g = G(testind); n = N(testind); tu = Tu(testind);
avg = AVG(testind);
%test = table(r,g,n,tu);
test = table(r,g,n,avg,tu);