% regressionModels.m
% Using random forest and SVM regression models to predict turbidity. See
% GitHub README Machine Learning Models section for running procedure.
load('refRGNTu.mat');
rf_rmse1 = 0; % random forest rmse 1 -- only three-band reflectance values as features
rf_rmse2 = 0; % random forest rmse 2 -- three-band reflectance values as features plus additional averaged feature
svr_rmse1 = 0; % SVM rmse 1 -- only three-band reflectance values as features
svr_rmse2 = 0; % SVM rmse 2 -- three-band reflectance values as features plus additional averaged feature
rf_rsq1 = 0;
rf_rsq2 = 0;
svr_rsq1 = 0;
svr_rsq2 = 0;
ntrials = 40; % runs process this many times, each with new testing/training data -- averaged values over all trials are outputted
for i = 1:ntrials
    [train,test] = makeDataTable(refRGNTu); % create stratified random sample training/testing data
    y_train = train.tu;
    y_test = test.tu;
    train = removevars(train,{'tu'});
    test = removevars(test,{'tu'});

    % training and testing the RF model with average column
    rng 'shuffle';
    rf_model = TreeBagger(25,train,y_train,'Method','regression');
    tu_fit = predict(rf_model,test);
    rf_err2 = y_test-tu_fit;
    rf_rmse2 = rf_rmse2 + sqrt(mean(rf_err2.^2));
    rf_rsq2 = rf_rsq2 + corrcoef(test.n./test.r,log(tu_fit));

    % training and testing the SVR model with average column
    rng 'shuffle'
    svr_model = fitrsvm(train,y_train);
    tu_fit = predict(svr_model,test);
    svr_err2 = y_test-tu_fit;
    svr_rmse2 = svr_rmse2 + sqrt(mean(svr_err2.^2));
    svr_rsq2 = svr_rsq2 + corrcoef(test.n./test.r,log(tu_fit));

    % dropping the average column
    train = removevars(train,{'avg'});
    test = removevars(test,{'avg'});

    % training and testing the RF model -- three bands only
    rng 'shuffle';
    rf_model = TreeBagger(25,train,y_train,'Method','regression');
    tu_fit = predict(rf_model,test);
    rf_err1 = y_test-tu_fit;
    rf_rmse1 = rf_rmse1 + sqrt(mean(rf_err1.^2));
    rf_rsq1 = rf_rsq1 + corrcoef(test.n./test.r,log(tu_fit));

    % training and testing the SVR model -- three bands only
    rng 'shuffle'
    svr_model = fitrsvm(train,y_train);
    tu_fit = predict(svr_model,test);
    svr_err1 = y_test-tu_fit;
    svr_rmse1 = svr_rmse1 + sqrt(mean(svr_err1.^2));
    svr_rsq1 = svr_rsq1 + corrcoef(test.n./test.r,log(tu_fit));
end
% average RMSEs from all trials
rf_rmse1 = rf_rmse1 / ntrials
rf_rmse2 = rf_rmse2 / ntrials
svr_rmse1 = svr_rmse1 / ntrials
svr_rmse2 = svr_rmse2 / ntrials

% average R-squared values from all trials
rf_rsq1 = rf_rsq1 ./ ntrials
rf_rsq2 = rf_rsq2 ./ ntrials
svr_rsq1 = svr_rsq1 ./ ntrials
svr_rsq2 = svr_rsq2 ./ ntrials