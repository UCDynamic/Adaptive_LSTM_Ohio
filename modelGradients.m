% function[gradients, loss] = modelGradients(net, loss)
% %     [dlYPred, state] = forward(net, dlX);
% 
% %     %Extract Predicted parameters
% %     param_pred= dlYPred(4:end);
% % 
% %     for i=1:10
% %         normalized_value= (param_pred(i) - min(x1(i))) / (max(param_pred) - min(param_pred));
% %         scaled_value(i)= x1(i) + (x2(i) - x1(i)) * normalized_value;
% %     end
% % 
% %     %extract parameters for this batch
% %     param= abs(scaled_value);
% %     fitness= simulation_opt(param, epoch);
% % 
% % %         %calculate loss
% %     loss= dlarray(1/(1+fitness));
% %         
%     %Calculate gradients
%     gradients = dlgradient(loss, net.Learnables);
% end

function[gradients, loss] = modelGradients(net, XTrain, YTrain, LSTM_input_params)
%feedforward
dlYPred = forward(net, XTrain)
    
%custom loss
% dlYPred_normal = extractdata(dlYPred);
% params_test = dlarray(LSTM_input_true(:,4:end), 'CB');
% params_test(end+1,:) = params_test(end,:);
% Time=length(params_test);
% iter=length(params_test);
% params_test(end,4) = extractdata(dlYPred);
% LSTM_input_params(15,4) = dlYPred;
% loss = simulation_LSTM_13_3(LSTM_input_params, 15, 15);
% loss= 0;
% for i=5:length(XTrain)
%     dlYPred = forward(net, XTrain(1:i))
%     loss= loss + mse(dlYPred , YTrain(i));
% end

loss = mse(dlYPred , YTrain(:,29));
loss

% end
%gradients by toolbox
gradients = dlgradient(loss, net.Learnables);
end