numFeatures= size(LSTM_input_true, 2);
% numFeatures = 13;
numResponses= size(LSTM_input_labels,2);
% numResponses = 13;
numHiddenUnits=50;

%network parameters
layers = [...
    sequenceInputLayer(numFeatures)
    lstmLayer(numHiddenUnits, 'OutputMode','sequence')
    fullyConnectedLayer(numResponses)];

%parameters
options = trainingOptions('adam',...
    'MaxEpochs',100,...
    'MiniBatchSize',10,...
    'InitialLearnRate',0.01,...
    'GradientThreshold',1,...
    'Verbose',0,...
    'Plots','training-progress');
dummy= dlarray(rand(numFeatures,1,1), 'CBT');
try
    simpleNet= dlnetwork(layers);
    simpleNet= initialize(simpleNet, dummy);
catch e
    fprintf('error initializing network:', e.message);
end