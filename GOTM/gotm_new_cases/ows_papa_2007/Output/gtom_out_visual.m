


out_my = read_gotm_out('ows_papa_my.nc');
cur_u_my = mean(out_my.u,2); % time-averaged eastward current profile
cur_v_my = mean(out_my.v,2); % time-averaged northward current profile


figure('position', [0, 0, 350, 500])
plot(cur_u_my.*100,(-249.5:1:-.5))
hold on 
plot(cur_v_my.*100,(-249.5:1:-.5))
  lgd = legend('$\langle U\rangle$', '$\langle V\rangle$','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('mean flow ($$cm/s$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/cur_my','-pdf','-transparent','-painters')
  
%% winter (date 252-342)

taux_my_win = mean(out_my.taux(:,252:342),2);  
tauy_my_win = mean(out_my.tauy(:,252:342),2);

figure('position', [0, 0, 350, 500])
plot(taux_my_win.*10000,(-250:1:0))
hold on 
plot(tauy_my_win.*10000,(-250:1:0))
  lgd = legend('$\langle wu\rangle$', '$\langle wv\rangle$','Location','best');
  set(lgd,'Interpreter','latex','fontsize', 14)
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('vertical turbulent momentum flux ($$cm^2/s^2$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  export_fig ('./figs/tur_mom_flux_my','-pdf','-transparent','-painters')


