%Load the environment and the model parameters
load('env')
load('10_day_LSTM_training.mat')
% for i= 1:30
%     optimalParams(i,2) = optimalParamsHistory(i,1);
%     optimalParams(i,4) = optimalParamsHistory(i,2);
%     optimalParams(i,5) = optimalParamsHistory(i,3);
% end
% param= chromosome(param)
%Set the number of iterations
T=length(optimalParams);

%Solve for Case 0 - With no Control measures
[S_loop, I_loop, R_loop,L_loop]=solve_loop_opt(env, optimalParams,T,1) ;
for i=1:88
    for j=1:T
S_loop_sum{i}(j)=0;
I_loop_sum{i}(j)=0; 
R_loop_sum{i}(j)=0;
L_loop_sum{i}(j)=0;
    end
end

cells=zeros(88,1);

for index=1:88
    for i=1:50
        for j=1:50
            if env(j,i).index==index
                cells(index)=cells(index)+1;
                for t=1:T
                S_loop_sum{index}(t)=S_loop_sum{index}(t)+S_loop{j,i}(t);
                L_loop_sum{index}(t)=L_loop_sum{index}(t)+L_loop{j,i}(t);
                I_loop_sum{index}(t)=I_loop_sum{index}(t)+I_loop{j,i}(t);
                R_loop_sum{index}(t)=R_loop_sum{index}(t)+R_loop{j,i}(t);
                end
            end
        end
    end
end

%calculatig for Ohio
for t=1:T
S_loop_OH(t)=0;
L_loop_OH(t)=0;
I_loop_OH(t)=0;
R_loop_OH(t)=0;
Pop_loop_OH(t)=0;

S_loop_OH_True(t)=0;
I_loop_OH_True(t)=0;
R_loop_OH_True(t)=0;
end

for t=1:T
for index=1:88
S_loop_OH(t)=S_loop_OH(t)+S_loop_sum{index}(t);%+L_loop_sum{index}(T);
I_loop_OH(t)=I_loop_OH(t)+I_loop_sum{index}(t);
R_loop_OH(t)=R_loop_OH(t)+R_loop_sum{index}(t);
L_loop_OH(t)=L_loop_OH(t)+L_loop_sum{index}(t);

S_loop_OH_True(t)=S_loop_OH_True(t)+Cases_Table{index}(t+15,5);
I_loop_OH_True(t)=I_loop_OH_True(t)+Cases_Table{index}(t+15,1);
R_loop_OH_True(t)=R_loop_OH_True(t)+Cases_Table{index}(t+15,4);

end
end

% for t=1:45
% for index=1:88
% S_loop_OH_True(t)=S_loop_OH_True(t)+Cases_Table{index}(t+15,5);
% I_loop_OH_True(t)=I_loop_OH_True(t)+Cases_Table{index}(t+15,1);
% R_loop_OH_True(t)=R_loop_OH_True(t)+Cases_Table{index}(t+15,4);
% end
% end


%Ploting the trained model against real data
  figure(1)
  subplot(3,1,1)
  plot((1:30),S_loop_OH(1:30), 'LineWidth',3)
  hold on
  plot((31:T),S_loop_OH(31:T), 'LineWidth',3, 'LineStyle','--')
  hold on
  plot((1:T),S_loop_OH_True(1:T),'LineWidth',3)

  title('Susceptible Population (S) vs Time','FontSize',20)
  xlabel('Time/Days','fontweight','bold','FontSize',20)
  ylabel('Population','fontweight','bold','FontSize',20)
  
  a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
  grid on
ax = gca;
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
  subplot(3,1,2)             
  plot((1:30),I_loop_OH(1:30), 'LineWidth',3)
  hold on
  plot((31:T),I_loop_OH(31:T), 'LineWidth',3, 'LineStyle','--')
  hold on
  plot((1:T),I_loop_OH_True(1:T),'LineWidth',3)
  
  title('Infectious Population (I) vs Time','FontSize',20)
  xlabel('Time/Days','fontweight','bold','FontSize',20)
  ylabel('Population','fontweight','bold','FontSize',20)
 
  a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
  grid on
ax = gca;
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
  subplot(3,1,3)
 plot((1:30),R_loop_OH(1:30), 'LineWidth',3)
  hold on
  plot((31:T),R_loop_OH(31:T), 'LineWidth',3,'LineStyle','--')
  hold on
  plot((1:T),R_loop_OH_True(1:T),'LineWidth',3 )
  title('Recovered Population (R) vs Time','FontSize',20)
  xlabel('Time/Days','fontweight','bold','FontSize',20)
  ylabel('Population','fontweight','bold','FontSize',20)
 
  a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
  grid on
ax = gca;
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;
legend('Model Results-TRAINING', 'LSTM prediction of the Infection rate (\phi)','True Data')
for i= 1:30
    LSTM_input_true(i,:) = [S_loop_OH(1,i), I_loop_OH(1,i), R_loop_OH(1,i), optimalParams(i,:)];
    LSTM_input_labels(i,:) = [S_loop_OH_True(1,i), I_loop_OH_True(1,i), R_loop_OH_True(1,i)];
    LSTM_input_params_cell{1,1}(1,i) = optimalParams(i,2);
    LSTM_input_params_cell{1,1}(2,i) = optimalParams(i,4);
    LSTM_input_params_cell{1,1}(3,i) = optimalParams(i,5);
    LSTM_input_true_labels_cell{1,1}(:,i) = LSTM_input_labels(i,:)';
end

%% plotly plots
% fig= gcf;
% plotly_fig = fig2plotly(fig, 'LSTM Prediction', 'Plotly Graph')