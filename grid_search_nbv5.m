%% Load data and cleaning
crdata = readtable('train.csv');
crdata = cleandata(crdata);

column_headings = crdata.Properties.VariableNames;
attribute_types = varfun(@class,crdata,'OutputFormat','cell'); 

%% Normalise the continuous variables
% Normalise for all columns that contain a 'double'
for j=1:137
    if string(attribute_types(j)) == "double"
        crdata(:,(j))  = normalize(crdata(:, (j)));
    end
end

%% Split the data into training and test
c = cvpartition(crdata.Target, 'HoldOut', 0.2);
idxTrain = training(c);
idxTest = test(c);

% training and testing data
trainingData = crdata(idxTrain, :);
testingData = crdata(idxTest,:);

%% Using auto tune to determine some reasonable weights for kernels for the grid search
 
%nbmdl = fitcnb(trainingData, trainingData.Target,'ClassNames',{'1','2','3','4'},'OptimizeHyperparameters','auto', 'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName', 'expected-improvement-plus'));

%Best observed feasible point:
%    DistributionNames    Width 
%    _________________    ______
%
%         kernel          10.843
%Best estimated feasible point (according to models):
%
%    DistributionNames    Width 
%    _________________    ______
%
%         kernel          11.528

% Try grid search with the following kernel widths

kernel_widths = {NaN 10.1 10.8 11.5 12.7};

%%  create partitioning for K fold validation
ckfold = cvpartition(trainingData.Target,'KFold',5);
macro_f1_kfold = zeros(1,5);

%% Naive Bayes with default variables

for i=1:ckfold.NumTestSets
        nbmdl = fitcnb(trainingData(ckfold.training(i),:), trainingData(ckfold.training(i),:).Target,'ClassNames',{'1','2','3','4'});
        label = categorical(predict(nbmdl,trainingData(ckfold.test(i),:)));
        actual = trainingData(ckfold.test(i),:).Target;
        cm = confusionmat(actual, label);
        f1 = macrof1(cm);
        macro_f1_kfold(i) = f1;
end

nb_default_kfold_F1 = (mean(macro_f1_kfold))

%% Create the grid search matrix
% GRID COLUMNS: Distributions: Normal distribution then the kernal smoother types; 'box',
% 'epanechnikov', 'normal', 'triangle'

% GRID ROWS: '', then kernal grid widths

gridF1_matrix = (zeros(4,5));

dist_types = {};

%Populate the distribution names variable
for j=1:137
    if string(attribute_types(j)) == "double"
        dist_types = [dist_types, 'kernel'];
    else
        dist_types = [dist_types, 'mvmn'];
    end
end


kernal_smoother_types = {'box','epanechnikov', 'triangle', 'normal'}; % iteration 'a'
% iteration 'b' = kernal widths

% cycle through the distribution types for the next four rows
for a=1:4
    for b=1:5
        for i=1:ckfold.NumTestSets
                nbmdl = fitcnb(trainingData(ckfold.training(i),:), trainingData(ckfold.training(i),:).Target,'ClassNames',{'1','2','3','4'}, 'DistributionNames', dist_types, 'Kernel', kernal_smoother_types{a}, 'Width', kernel_widths{b});
                label = categorical(predict(nbmdl,trainingData(ckfold.test(i),:)));
                actual = trainingData(ckfold.test(i),:).Target;
                cm = confusionmat(actual, label);
                f1 = macrof1(cm);
                macro_f1_kfold(i) = f1;
        end
        %averaging the result from the kfold
        nb_grid_kfold_F1 = (mean(macro_f1_kfold));
        % Putting the results in the grid
        gridF1_matrix(a,b) = nb_grid_kfold_F1
    end
end

%% Best model
[MV, IC] = max(gridF1_matrix) %returns largest values for each column
[M, IR] = max(MV) %returns largest value from grid
best_kernel_smoother = [kernal_smoother_types{IC(1)}]
best_kernel_width = [kernel_widths{IR}]
best_marco_f1 = M

%% Applying the best model to the test data set
% rebuild that model
%run the test data through it
%determine the macro f1 test data score

best_nbmdl = fitcnb(trainingData, trainingData.Target,'ClassNames',{'1','2','3','4'}, 'DistributionNames', dist_types, 'Kernel', best_kernel_smoother, 'Width', best_kernel_width)
label = categorical(predict(best_nbmdl,testingData));
actual = testingData.Target;
cm = confusionmat(actual, label)
best_f1 = macrof1(cm)


%% Apply PCA to the Data.
% Run PCA on numeric predictors only. Categorical predictors are passed through PCA untouched.
numericPredictors = [];
categoricalPredictors = [];

crDataTarget = crdata.Target; %pulling this out of the table for this section
removevars(crdata, 'Target');

for j=1:136
    if string(attribute_types(j)) == "double"
        numericPredictors = [numericPredictors, crdata(:, j)];
    else
        categoricalPredictors = [categoricalPredictors, crdata(:, j)];
    end
end

numericPredictors = table2array(numericPredictors);
categoricalPredictors = table2array(categoricalPredictors);
% 'inf' values have to be treated as missing data for PCA.
numericPredictors(isinf(numericPredictors)) = NaN;

%% Running the PCA
[pcaCoefficients, pcaScores, ~, ~, explained, pcaCenters] = pca(numericPredictors);
% Keep enough components to explain the desired amount of variance.
explainedVarianceToKeepAsFraction = 95/100;
numComponentsToKeep = find(cumsum(explained)/sum(explained) >= explainedVarianceToKeepAsFraction, 1);
pcaCoefficients = pcaCoefficients(:,1:numComponentsToKeep);
crData_PCA = [array2table(pcaScores(:,1:numComponentsToKeep)), array2table(categoricalPredictors)];

%% Populate the distribution names variable
pca_attribute_types  = varfun(@class,crData_PCA,'OutputFormat','cell'); 
pca_dist_types = {};

for j=1:116
    if string(pca_attribute_types(j)) == "double"
        pca_dist_types = [pca_dist_types, 'kernel'];
    else
        pca_dist_types = [pca_dist_types, 'mvmn'];
    end
end

%% Reapply the training and testing partitions
trainingData_PCA = crData_PCA(idxTrain, :);
testingData_PCA = crData_PCA(idxTest,:);
traindatalabels_pca = crDataTarget(idxTrain, :);
testdatalabels_pca = crDataTarget(idxTest,:);

%% Applying the best model to the training and test data set following PCA
% rebuild that model
%run the test data through it
%determine the macro f1 test data score

best_nbmdl = fitcnb(trainingData_PCA, traindatalabels_pca,'ClassNames',{'1','2','3','4'}, 'DistributionNames', pca_dist_types, 'Kernel', best_kernel_smoother, 'Width', best_kernel_width)
label = categorical(predict(best_nbmdl,testingData_PCA));
actual = testdatalabels_pca;
cm = confusionmat(actual, label)
pca_f1 = macrof1(cm)

%% How does the model perform when only the best 50 predictors are used?
%% Figuring out the best predictors
mdl = fitctree(trainingData, 'Target');
p = predictorImportance(mdl);
%bar(p);
top_p = maxk(p, 50);
toKeep = p >= top_p(end);

%% Populate the distribution names variable
top50_attribute_types  = varfun(@class,trainingData(:, toKeep),'OutputFormat','cell'); 
top50_dist_types = {};

for j=1:50
    if string(top50_attribute_types(j)) == "double"
        top50_dist_types = [top50_dist_types, 'kernel'];
    else
        top50_dist_types = [top50_dist_types, 'mvmn'];
    end
end


%% Run the model again with 50 predictors
best_nbmdl = fitcnb(trainingData(:, toKeep), trainingData.Target,'ClassNames',{'1','2','3','4'}, 'DistributionNames', top50_dist_types, 'Kernel', best_kernel_smoother, 'Width', best_kernel_width)
label = categorical(predict(best_nbmdl,testingData(:, toKeep)));
actual = testingData.Target;
cm = confusionmat(actual, label)
best_f1_top50 = macrof1(cm)

%% How does the model perform when only the best 80 predictors are used?
%% Figuring out the best predictors
mdl = fitctree(trainingData, 'Target');
p = predictorImportance(mdl);
%bar(p);
top_p = maxk(p, 80);
toKeep = p >= top_p(end);

%% Populate the distribution names variable
top80_attribute_types  = varfun(@class,trainingData(:, toKeep),'OutputFormat','cell'); 
top80_dist_types = {};

for j=1:80
    if string(top100_attribute_types(j)) == "double"
        top80_dist_types = [top80_dist_types, 'kernel'];
    else
        top80_dist_types = [top80_dist_types, 'mvmn'];
    end
end

%% Run the model again with 80 predictors
best_nbmdl = fitcnb(trainingData(:, toKeep), trainingData.Target,'ClassNames',{'1','2','3','4'}, 'DistributionNames', top80_dist_types, 'Kernel', best_kernel_smoother, 'Width', best_kernel_width)
label = categorical(predict(best_nbmdl,testingData(:, toKeep)));
actual = testingData.Target;
cm = confusionmat(actual, label)
best_f1_top80 = macrof1(cm)

