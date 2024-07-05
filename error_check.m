for i=1:45
    error_static(i) = rmse(I_loop_OH_True(i), I_loop_OH_static(i));
    error_LSTM(i) = rmse(I_loop_OH_True(i), I_loop_OH(i));
end

  figure(1)
  plot((1:30),error_static(1:30), 'LineWidth',3)
  hold on
  plot((1:30),error_LSTM(1:30), 'LineWidth',3, 'LineStyle','--')
  hold on
  plot((31:T),error_static(31:T), 'LineWidth',3)
  hold on
  plot((31:T),error_LSTM(31:T), 'LineWidth',3, 'LineStyle','--')

  title('Static parameters vs LSTM parameters error','FontSize',20)
  xlabel('Time/Days','fontweight','bold','FontSize',20)
  ylabel('error','fontweight','bold','FontSize',20)
  
  a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',18)
  grid on
ax = gca;
ax.GridColor = [0 .5 .5];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.5;

legend('Static params-Training','LSTM params-Training','Static params-Prediction','LSTM params-Prediction')
