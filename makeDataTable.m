% makeDataTable.m
% FIRST run plotTuNormRef to get all updated refRGNTu (reflectance values)
% Creates training and testing datasets (stratified random sampling, ratio of dates 8/12 and 8/13 are the same for train and test) from the RGN reflectances and turbidities that have been processed
% Inputs:
% refRGNTu -- structure containing each processed image's reflectance values and paired turbidity value
% Outputs:
% train -- table containing training data, including column of averaged reflectances
% test -- table containing testing data, including column of averaged reflectances
function [train,test] = makeDataTable(refRGNTu)
R = [];
G = [];
N = [];
AVG = [];
Tu = [];
Day = []; % August 12th (lake athabasca) or August 13th (richardson)
train_perc = 0.8;
for i = 1:length(refRGNTu)
    R(length(R)+1,1) = refRGNTu(i).refR; % columns of testing and training data
    G(length(G)+1,1) = refRGNTu(i).refG;
    N(length(N)+1,1) = refRGNTu(i).refN;
    AVG(length(AVG)+1,1) = mean([R(length(R),1),G(length(G),1),N(length(N),1)]);
    Tu(length(Tu)+1,1) = refRGNTu(i).tu;
    Day(length(Day)+1,1) = day(refRGNTu(i).photodate);
end

% test/train split -- stratified random sampling
ind = 1:length(R);
rng 'shuffle'
ind = ind(randperm(length(ind))); % create random indexing
testind = []; trainind = []; % indexes of refRGNTu that will be generated for training or testing data

aug12test = round(numel(find(Day == 12))/length(Day)*(1-train_perc)*length(Day)); % the number of samples in the testing data that should be 8/12 samples (the remaining number should be the number of 8/13 samples)
for i = ind
    if length(testind) < aug12test && Day(i) == 12 % add to training/testing data based on date
        testind(length(testind)+1,1) = i;
    elseif length(testind) < aug12test && Day(i) == 13
        trainind(length(trainind)+1) = i;
    elseif length(testind) < (1-train_perc)*length(Day) && Day(i) == 13
        testind(length(testind)+1,1) = i;
    else
        trainind(length(trainind)+1) = i;
    end
end

r = R(trainind); g = G(trainind); n = N(trainind); tu = Tu(trainind); % create columns of final tables
avg = AVG(trainind);
%train = table(r,g,n,tu);
train = table(r,g,n,avg,tu);
r = R(testind); g = G(testind); n = N(testind); tu = Tu(testind);
avg = AVG(testind);
%test = table(r,g,n,tu);
test = table(r,g,n,avg,tu);
