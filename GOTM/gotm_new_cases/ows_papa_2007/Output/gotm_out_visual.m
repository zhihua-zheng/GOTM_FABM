


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

taux_my = double(out_my.taux);  
tauy_my = double(out_my.tauy);

cnum = 15;
[T, Z] = meshgrid(out_my.time,(-250:1:0));
CL = [min(min(taux_my)) max(max(taux_my))];
conts = linspace(CL(1),CL(2),cnum);
cmocean('balance')

figure('position', [0, 0, 350, 500])
contourf(T,Z,taux_my.*10000,conts,'LineWidth',0.01,'LineStyle','none');
% contourf(tauy_my.*10000,
  caxis(CL);
  box on
  axis ij
  datetick('x','mmm')
  % lgd = legend('$\langle wu\rangle$', '$\langle wv\rangle$','Location','best');
  % set(lgd,'Interpreter','latex','fontsize', 14)
  
  ylabel('depth ($$m$$)', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  xlabel('time', 'fontname', 'computer modern', 'fontsize', 14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[datenum('June 15, 2009') datenum('April 16, 2018')],...
      'fontsize',11,'fontname','computer modern','TickLabelInterpreter', 'latex')
  
  h = colorbar('EastOutside');
  h.Label.String = 'x-momentum turbulent flux $\langle wu\rangle$ ($$m^2/s^2$$)';
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);
  
  export_fig ('./figs/tur_mom_flux_my','-pdf','-transparent','-painters')


