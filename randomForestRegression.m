% random forest regression to predict turbidity
%% new train/test data
load('paired_data.mat');
[train,test] = makeDataTable(paired_data);
y_train = train.tu;
y_test = test.tu;
train = removevars(train,{'tu'});
test = removevars(test,{'tu'});

%% training and testing the RF model with average column
rng 'default';
rf_model = TreeBagger(25,train,y_train,'Method','regression');
tu_fit = predict(rf_model,test);
rf_err2 = y_test-tu_fit;
rf_rmse2 = sqrt(mean(rf_err2.^2))

%% training and testing the SVR model with average column
rng 'default'
svr_model = fitrsvm(train,y_train);
tu_fit = predict(svr_model,test);
svr_err2 = y_test-tu_fit;
svr_rmse2 = sqrt(mean(svr_err2.^2))

%% dropping the average column
train = removevars(train,{'avg'});
test = removevars(test,{'avg'});

%% training and testing the RF model -- three bands only
rng 'default';
rf_model = TreeBagger(25,train,y_train,'Method','regression');
tu_fit = predict(rf_model,test);
rf_err1 = y_test-tu_fit;
rf_rmse1 = sqrt(mean(rf_err1.^2))

%% training and testing the SVR model -- three bands only
rng 'default'
svr_model = fitrsvm(train,y_train);
tu_fit = predict(svr_model,test);
svr_err1 = y_test-tu_fit;
svr_rmse1 = sqrt(mean(svr_err1.^2))