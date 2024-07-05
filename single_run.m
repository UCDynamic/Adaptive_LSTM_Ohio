%Load the environment and the model parameters
load('env')
load('param.mat')
% param= chromosome(param)
%Set the number of iterations
T=45;

%Solve for Case 0 - With no Control measures
[S_loop, I_loop, R_loop,L_loop]=solve_loop(env, param,T,1) ;
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
for t=1:60
S_loop_OH_static(t)=0;
L_loop_OH_static(t)=0;
I_loop_OH_static(t)=0;
R_loop_OH_static(t)=0;
Pop_loop_OH(t)=0;

S_loop_OH_True(t)=0;
I_loop_OH_True(t)=0;
R_loop_OH_True(t)=0;
end

for t=1:T
for index=1:88
S_loop_OH_static(t)=S_loop_OH_static(t)+S_loop_sum{index}(t);%+L_loop_sum{index}(T);
I_loop_OH_static(t)=I_loop_OH_static(t)+I_loop_sum{index}(t);
R_loop_OH_static(t)=R_loop_OH_static(t)+R_loop_sum{index}(t);
L_loop_OH_static(t)=L_loop_OH_static(t)+L_loop_sum{index}(t);
end
end

for t=1:45
for index=1:88
S_loop_OH_True(t)=S_loop_OH_True(t)+Cases_Table{index}(t+15,5);
I_loop_OH_True(t)=I_loop_OH_True(t)+Cases_Table{index}(t+15,1);
R_loop_OH_True(t)=R_loop_OH_True(t)+Cases_Table{index}(t+15,4);
end
end


% 
% %Solve for Case 1 - With Control measures
% [S_loop_1, I_loop_1, R_loop_1,L_loop_1]=solve_loop(env, param,T,2) ;
% for i=1:88
%     for j=1:T
% S_loop_sum{i}(j)=0;
% I_loop_sum{i}(j)=0; 
% R_loop_sum{i}(j)=0;
% L_loop_sum{i}(j)=0;
%     end
% end
% 
% cells=zeros(88,1);
% 
% for index=1:88
%     for i=1:50
%         for j=1:50
%             if env(j,i).index==index
%                 cells(index)=cells(index)+1;
%                 for t=1:T
%                 S_loop_sum{index}(t)=S_loop_sum{index}(t)+S_loop_1{j,i}(t);
%                 L_loop_sum{index}(t)=L_loop_sum{index}(t)+L_loop_1{j,i}(t);
%                 I_loop_sum{index}(t)=I_loop_sum{index}(t)+I_loop_1{j,i}(t);
%                 R_loop_sum{index}(t)=R_loop_sum{index}(t)+R_loop_1{j,i}(t);
%                 end
%             end
%         end
%     end
% end
% 
% %calculatig for Ohio
% for t=1:60
% S_loop_OH_1(t)=0;
% L_loop_OH_1(t)=0;
% I_loop_OH_1(t)=0;
% R_loop_OH_1(t)=0;
% end
% 
% for t=1:T
% for index=1:88
% S_loop_OH_1(t)=S_loop_OH_1(t)+S_loop_sum{index}(t);%+L_loop_sum{index}(T);
% I_loop_OH_1(t)=I_loop_OH_1(t)+I_loop_sum{index}(t);
% R_loop_OH_1(t)=R_loop_OH_1(t)+R_loop_sum{index}(t);
% L_loop_OH_1(t)=L_loop_OH_1(t)+L_loop_sum{index}(t);
% end
% end
% 
% 
% %Solve for Case 2 - With Control measures
% [S_loop_2, I_loop_2, R_loop_2,L_loop_2]=solve_loop(env, param,T,3) ;
% for i=1:88
%     for j=1:T
% S_loop_sum{i}(j)=0;
% I_loop_sum{i}(j)=0; 
% R_loop_sum{i}(j)=0;
% L_loop_sum{i}(j)=0;
%     end
% end
% 
% cells=zeros(88,1);
% 
% for index=1:88
%     for i=1:50
%         for j=1:50
%             if env(j,i).index==index
%                 cells(index)=cells(index)+1;
%                 for t=1:T
%                 S_loop_sum{index}(t)=S_loop_sum{index}(t)+S_loop_2{j,i}(t);
%                 L_loop_sum{index}(t)=L_loop_sum{index}(t)+L_loop_2{j,i}(t);
%                 I_loop_sum{index}(t)=I_loop_sum{index}(t)+I_loop_2{j,i}(t);
%                 R_loop_sum{index}(t)=R_loop_sum{index}(t)+R_loop_2{j,i}(t);
%                 end
%             end
%         end
%     end
% end
% 
% %calculatig for Ohio
% for t=1:60
% S_loop_OH_2(t)=0;
% L_loop_OH_2(t)=0;
% I_loop_OH_2(t)=0;
% R_loop_OH_2(t)=0;
% end
% 
% for t=1:T
% for index=1:88
% S_loop_OH_2(t)=S_loop_OH_2(t)+S_loop_sum{index}(t);%+L_loop_sum{index}(T);
% I_loop_OH_2(t)=I_loop_OH_2(t)+I_loop_sum{index}(t);
% R_loop_OH_2(t)=R_loop_OH_2(t)+R_loop_sum{index}(t);
% L_loop_OH_2(t)=L_loop_OH_2(t)+L_loop_sum{index}(t);
% end
% end
% 
% %% Time-Series Plots
% 
% 
%Ploting the trained model against real data
  figure(1)
  subplot(3,1,1)
  plot((1:30),S_loop_OH_static(1:30), 'LineWidth',3)
  hold on
  plot((30:T),S_loop_OH_static(30:T), 'LineWidth',3, 'LineStyle','--')
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
  plot((1:30),I_loop_OH_static(1:30), 'LineWidth',3)
  hold on
  plot((30:T),I_loop_OH_static(30:T), 'LineWidth',3, 'LineStyle','--')
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
  plot((30:T),R_loop_OH(30:T), 'LineWidth',3,'LineStyle','--')
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
legend('Model Results-TRAINING','Model Results-TESTING','True Data')

% %Figure for comparision of  with and without control parameters
%   figure(2)
%   grid on
%   subplot(3,1,1)
%   plot((1:60),S_loop_OH(1:60), 'LineWidth',3)
%   hold on
%   
%   plot((1:60),S_loop_OH_1(1:60), 'LineWidth',3)
%   hold on
%   
%   plot((1:60),S_loop_OH_2(1:60), 'LineWidth',3)
%   hold on
%   title('Susceptible Population (S) vs Time','FontSize',20)
%   xlabel('Time/Days','fontweight','bold','FontSize',20)
%   ylabel('Population','fontweight','bold','FontSize',20)
%   a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
% %    legend('No control measures','Case 1','Case 2')
%     grid on
% ax = gca;
% ax.GridColor = [0 .5 .5];
% ax.GridLineStyle = '--';
% ax.GridAlpha = 0.5;
%   subplot(3,1,2)             
%   plot((1:60),I_loop_OH(1:60), 'LineWidth',3)
%   hold on
%   plot((1:60),I_loop_OH_1(1:60), 'LineWidth',3)
%   hold on
%   plot((1:60),I_loop_OH_2(1:60), 'LineWidth',3)
%   hold on
%   title('Infectious Population (I) vs Time','FontSize',20)
%   xlabel('Time/Days','fontweight','bold','FontSize',20)
%   ylabel('Population','fontweight','bold','FontSize',20)
%   a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
% %    legend('No control measures','Case 1','Case 2')
%     grid on
% ax = gca;
% ax.GridColor = [0 .5 .5];
% ax.GridLineStyle = '--';
% ax.GridAlpha = 0.5;
%   subplot(3,1,3)
%   plot((1:60),R_loop_OH(1:60), 'LineWidth',3)
%   hold on
%   plot((1:60),R_loop_OH_1(1:60), 'LineWidth',3)
%   hold on
%   plot((1:60),R_loop_OH_2(1:60), 'LineWidth',3)
%   hold on
%   title('Recovered Population (R) vs Time','FontSize',20)
%   xlabel('Time/Days','fontweight','bold','FontSize',20)
%   ylabel('Population','fontweight','bold','FontSize',20)
%   a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
%     grid on
% ax = gca;
% ax.GridColor = [0 .5 .5];
% ax.GridLineStyle = '--';
% ax.GridAlpha = 0.5;
%   
% legend('No control measures','Case 1','Case 2')
% 
% %% HEAT MAPS
% for i =1:50
%     for j=1:50
%         Mat_idx(j,i)=env(j,i).index;
%     end
% end
% 
% %True Data
% env_I{1}=zeros(50,50);
% env_I{2}=zeros(50,50);  
% env_I{3}=zeros(50,50);
% env_I{4}=zeros(50,50);
% 
% for i=1:88
%         row=[]
%         col=[]
%         IDX=i; %county index of interest
%         
%          [row, col]=find(Mat_idx==IDX); %find row and column numbers of the environment with that county
%          t_cells=length(row); %total number of cells
%          
%          for j=1:3
%          initial_inf=Cases_Table{IDX}(1+(j)*15,1)/t_cells; %infections in a particular cell in the true data
%          for g=1:t_cells
%             
%              env_I{j}(row(g),col(g))=initial_inf;
%             
%          end
%          
%          
%          end
% end
% %Plotting real data
% for k=1:3
% figure(k+2)
% h= heatmap(env_I{k})
% YLabels = 1:50;
% XLabels = 1:50;
% CustomYLabels = string(XLabels);
% CustomYLabels(mod(XLabels,5) ~= 0) = " ";
% h.YDisplayLabels = CustomYLabels;
% 
% CustomXLabels = string(XLabels);
% 
% CustomXLabels(mod(XLabels,5) ~= 0) = " ";
% 
% h.XDisplayLabels = CustomXLabels;
% if k==1
%       caxis([0, 250]);
% else
%  caxis([0, 450]);
% end 
%  colormap(jet(256));
%      title(sprintf('Infectious Population @ Day  %d- Real Data', (k-1)*15+1))
% end
% 
% 
% %Plotting for Model Results
% for i=1:50
%     for j=1:50
% env_I{1}(j,i)=I_loop{j,i}(1);
% env_I{2}(j,i)=I_loop{j,i}(15);  
% env_I{3}(j,i)=I_loop{j,i}(45);
% env_I{4}(j,i)=I_loop{j,i}(60);
%     end
% end
% 
% 
% for k=1:4
% figure(k+6)
% h= heatmap(env_I{k})
% YLabels = 1:50;
% XLabels = 1:50;
% CustomYLabels = string(XLabels);
% CustomYLabels(mod(XLabels,5) ~= 0) = " ";
% h.YDisplayLabels = CustomYLabels;
% 
% CustomXLabels = string(XLabels);
% 
% CustomXLabels(mod(XLabels,5) ~= 0) = " ";
% 
% h.XDisplayLabels = CustomXLabels;
% if k==1
%       caxis([0, 250]);
% else
%  caxis([0, 450]);
% end 
%  colormap(jet(256));
%      title(sprintf('Infectious Population @ Day  %d- Model Results', (k-1)*15+1))
% end
% 
% %Plotting for Case 1
% for i=1:50
%     for j=1:50
% env_I{1}(j,i)=I_loop_1{j,i}(1);
% env_I{2}(j,i)=I_loop_1{j,i}(15);  
% env_I{3}(j,i)=I_loop_1{j,i}(45);
% env_I{4}(j,i)=I_loop_1{j,i}(60);
%     end
% end
% 
% 
% for k=1:4
% figure(k+10)
% h= heatmap(env_I{k})
% YLabels = 1:50;
% XLabels = 1:50;
% CustomYLabels = string(XLabels);
% CustomYLabels(mod(XLabels,5) ~= 0) = " ";
% h.YDisplayLabels = CustomYLabels;
% 
% CustomXLabels = string(XLabels);
% 
% CustomXLabels(mod(XLabels,5) ~= 0) = " ";
% 
% h.XDisplayLabels = CustomXLabels;
% if k==1
%       caxis([0, 250]);
% else
%  caxis([0, 450]);
% end 
%  colormap(jet(256));
%      title(sprintf('Infectious Population @ Day  %d- Case 1', (k-1)*15+1))
% end
% 
% %Plotting for Case 2
% for i=1:50
%     for j=1:50
% env_I{1}(j,i)=I_loop_2{j,i}(1);
% env_I{2}(j,i)=I_loop_2{j,i}(15);  
% env_I{3}(j,i)=I_loop_2{j,i}(45);
% env_I{4}(j,i)=I_loop_2{j,i}(60);
%     end
% end
% 
% 
% for k=1:4
% figure(k+14)
% h= heatmap(env_I{k})
% YLabels = 1:50;
% XLabels = 1:50;
% CustomYLabels = string(XLabels);
% CustomYLabels(mod(XLabels,5) ~= 0) = " ";
% h.YDisplayLabels = CustomYLabels;
% 
% CustomXLabels = string(XLabels);
% 
% CustomXLabels(mod(XLabels,5) ~= 0) = " ";
% 
% h.XDisplayLabels = CustomXLabels;
% if k==1
%       caxis([0, 250]);
% else
%  caxis([0, 45]);
% end 
%  colormap(jet(256));
%      title(sprintf('Infectious Population @ Day  %d- Case 2', (k-1)*15+1))
% end