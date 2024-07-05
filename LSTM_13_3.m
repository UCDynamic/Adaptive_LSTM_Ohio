 
numFeatures= 3;
numResponses = 3;
numHiddenUnits=128;

%network parameters
layers = [...
    sequenceInputLayer(numFeatures, 'Name', 'sequenceInput') %% time series feature
    lstmLayer(numHiddenUnits, 'Name', 'lstm', 'OutputMode','last') %% OutputMode is to predict the outcome based on entire sequence of input feature
    fullyConnectedLayer(numResponses, 'Name', 'fc') %%Final output layer with a positive bias, inf rate in the next time step
%     reluLayer('Name', 'relu_output')%%ReLU to produce a positive output
%     regressionLayer
    ]; %%ReLU to produce a positive output

numEpochs = 400;
learningRate = 0.01;
XTrain = dlarray(LSTM_input_params_cell{1}(:,1:length(LSTM_input_params_cell{1})-1), 'CT');
XTrain_cell = {extractdata(XTrain)};
% XTrain = optimalParams(:,4);
% YTrain = LSTM_input_params_cell{1}(4,11:15);
YTrain = dlarray(LSTM_input_params_cell{1}(:,2:length(LSTM_input_params_cell{1})), 'CB');
YTrain_cell = {extractdata(YTrain)};
% YTrain = I_loop_OH';
% dlX = dlarray(XTrain, 'CT');
% dlY = dlarray(YTrain, 'CB');
% LSTM_input_params = dlarray(LSTM_input_true(:,4:end), 'CB');
%% Initializing network- custom training
lgraph = layerGraph(layers);
net = dlnetwork(lgraph);

% Training loop
for epoch =1:numEpochs
    %Evaluating the gradients and loss using a custom loss function and dlfeval(custom training loops evaluation)
    [gradient, loss] = dlfeval(@modelGradients, net, XTrain, YTrain, LSTM_input_true);

    %update network parameters
    net = dlupdate(@(w, grad) w - learningRate*grad,net,gradient);

    %Display the epoch and loss
    disp(['Epoch: ' num2str(epoch) ', Loss:' num2str(extractdata(loss))]);
end
output = extractdata(forward(net, XTrain))
optimalParams(length(optimalParams)+1,:) = optimalParams(length(optimalParams),:);
optimalParams(length(optimalParams),2) = output(1);
optimalParams(length(optimalParams),4) = output(2);
optimalParams(length(optimalParams),5) = output(3);


%% Initializing network- open training
%Label data (inf rate)
% YTrain_list(:,1) = optimalParams(1:30,2);
% YTrain_list(:,2) = optimalParams(1:30,4);
% YTrain_list(:,3) = optimalParams(1:30,5);
% % YTrain = reshape(YTrain, [1,1,30]);
% 
% % Xtrain= cell(1,2);
% Ytrain = cell(1,20);
% for i= 1:30
%     Xtrain{i} =  
%     LSTM_input_labels(i:i, 1:2).';
% %     Xtrain{i,2} = LSTM_input_labels(i, 2);
%     Ytrain{i} = YTrain_list(i,1);
% end
% options = trainingOptions('adam',...
%     'MaxEpochs', 2500,...
%     'InitialLearnRate', 0.01,...
%     'GradientThreshold',1,...
%     'Shuffle','never', ...
%     'Plots','training-progress')
% % hasNaN = any(cellfun(@(x) any(isnan(x(:))), Ytrain))
% net = trainNetwork(XTrain_cell, YTrain_list, layers, options);
% Xtest{1} = LSTM_input_labels(30, 1:2).';
% YPred = predict(net, Xtest)