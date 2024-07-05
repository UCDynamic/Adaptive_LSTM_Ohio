%Concatenate features (sus and inf) along second dimension
X = [S_loop_OH; I_loop_OH];

%Reshape the data
XTrain = reshape(X, [2,1,30]);

%Label data (inf rate)
YTrain = optimalParams(1:30,4);
% YTrain = reshape(YTrain, [1,1,30]);

% Xtrain= cell(1,2);
Ytrain = cell(1,20);
for i= 1:30
    Xtrain{i} = LSTM_input_labels(i:i, 1:2).';
%     Xtrain{i,2} = LSTM_input_labels(i, 2);
    Ytrain{i} = YTrain(i,1);
end

%network parameters
layers = [...
    sequenceInputLayer(3, 'Name', 'sequenceInput') %% time series feature
    lstmLayer(50, 'Name', 'lstm', 'OutputMode','last') %% OutputMode is to predict the outcome based on entire sequence of input feature
    fullyConnectedLayer(3, 'Name', 'fc', 'Bias',0.1) %%Final output layer with a positive bias, inf rate in the next time step
%     reluLayer('Name', 'relu_output')%%ReLU to produce a positive output
%     regressionLayer
    ]; %%ReLU to produce a positive output

options = trainingOptions('adam',...
    'MaxEpochs', 2500,...
    'InitialLearnRate', 0.01,...
    'GradientThreshold',1,...
    'Shuffle','never', ...
    'Plots','training-progress')
% hasNaN = any(cellfun(@(x) any(isnan(x(:))), Ytrain))
net = trainNetwork(Xtrain, YTrain, layers, options);
Xtest{1} = LSTM_input_labels(30, 1:2).';
YPred = predict(net, Xtest)