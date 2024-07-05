%load params_45_17_4.mat - good params
load params_45_17_4.mat
train_data={};
test_time = 45;
for i = 6:36
    train_data{i-5,1} = optimalParams(i-5:i-1,[2 4 5])';
    train_label(i-5,1) = optimalParams(i,2);
    train_label(i-5,2) = optimalParams(i,4);
    train_label(i-5,3) = optimalParams(i,5);
end
numObservations = numel(train_data);
numChannels= size(train_data{1},1);
idxTrain = 1:floor(30);
idxtest = floor(30)+1:numObservations;
dataTrain = train_data(idxTrain);
dataTest = train_data(idxtest);

for n=1:numel(dataTrain)
    X=dataTrain{n};
    XTrain{n} = X(:,:);
    TTrain(n,:) = train_label(n,:)';
end

layers = [
    sequenceInputLayer(3)
    lstmLayer(128, 'OutputMode','last')
    fullyConnectedLayer(3)
    regressionLayer
    ];

options = trainingOptions("adam", ...
    MaxEpochs=500, ...
    SequencePaddingDirection="left", ...
    Shuffle="every-epoch", ...
    Plots="training-progress", ...
    Verbose=0);

net = trainNetwork(XTrain,TTrain,layers,options);

for n = 1:size(dataTest,1)
    X = dataTest{n};
    XTest{n} = X(:,:);
    TTest{n} = X(:,2)';
end

YTest = predict(net,XTest,SequencePaddingDirection="left");
count=5;
count1=5;
for day = 31:test_time-1
    optimalParams(day, :) = optimalParams(day-1, :);
    optimalParams(day, 2) = YTest(1);
    optimalParams(day, 4) = YTest(2);
    optimalParams(day, 5) = YTest(3);

    clear train_data
    inner_loop = false;
    if day> 36
        inner_loop = true
        clear train_data
        for i = day-31:day
            train_data{i-count,1} = optimalParams(i-count:i-1,[2 4 5])';
            train_label(i-count,1) = optimalParams(i,2);
            train_label(i-count,2) = optimalParams(i,4);
            train_label(i-count,3) = optimalParams(i,5);
        end
        numObservations = numel(train_data);
        numChannels= size(train_data{1},1);
        idxTrain = 1:floor(30);
        idxtest = numObservations;
        dataTrain = train_data(idxTrain);
        dataTest = train_data(idxtest);
    else
        clear train_data
        clear train_label
        clear XTrain
        clear TTrain
        for i = day-25:day
            train_data{i-count1,1} = optimalParams(i-count1:i-1,[2 4 5])';
            train_label(i-count1,1) = optimalParams(i,2);
            train_label(i-count1,2) = optimalParams(i,4);
            train_label(i-count1,3) = optimalParams(i,5);
        end
        numObservations = numel(train_data);
        numChannels= size(train_data{1},1);
        idxTrain = 1:numObservations-1;
        idxtest = numObservations;
        dataTrain = train_data(idxTrain);
        dataTest = train_data(idxtest);
    end
    
    for n=1:numel(dataTrain)
        X=dataTrain{n};
        XTrain{n} = X(:,:);
        TTrain(n,:) = train_label(n,:)';
    end
    
    layers = [
        sequenceInputLayer(3)
        lstmLayer(128, 'OutputMode','last')
        fullyConnectedLayer(3)
        regressionLayer
        ];
    
    options = trainingOptions("adam", ...
        MaxEpochs=200, ...
        SequencePaddingDirection="left", ...
        Shuffle="every-epoch", ...
        Verbose=0);
    
    net = trainNetwork(XTrain,TTrain,layers,options);
    
    for n = 1:size(dataTest,1)
        X = dataTest{n};
        XTest{n} = X(:,:);
        TTest{n} = X(:,2)';
    end
    
    YTest = predict(net,XTest,SequencePaddingDirection="left");
    count
    day
count1=count1+1;
if inner_loop == true
    count=count+1;
end
end
optimalParams(day+1, 2) = YTest(1);
optimalParams(day+1, 4) = YTest(2);
optimalParams(day+1, 5) = YTest(3);