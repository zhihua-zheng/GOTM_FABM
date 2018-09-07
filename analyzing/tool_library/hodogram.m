function hodogram(t, cur)

% hodogram
%==========================================================================
%
% USAGE:
%  hodogram(t, cur)
%
% DESCRIPTION:
%  Function to generate a hodogram for input velocity data
%
% INPUT:
%
%  t - one dimensional array of date number
%  cur - one dimensional array of velocity in complex form
%
% OUTPUT:
%
%  hodogram of velocity data with detailed annotation
%
% AUTHOR:
%  September 6 2018. Zhihua Zheng                       [ zhihua@uw.edu ]


t_int = t(t==floor(t)); % label only integer dyas

color_mat = distinguishable_colors(length(t_int)-1); 
% define discrete colormap

figure('position', [0, 0, 400, 400])

colormap(color_mat);
scatter(real(cur),imag(cur),30,t,'filled')
colorbar('Northoutside')
h = cbdate(t_int,'mmm-dd','horiz'); 
hold on
plot(cur,'Color',[.5 .6 .7],'LineStyle',':','LineWidth',.1)
  
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);

    
spec_info.grid_on = 0;
spec_info.x_time = 0;
spec_info.xlabel = 'u (m/s)';
spec_info.ylabel = 'v (m/s)';
spec_info.lgd = 0;
spec_info.save = 1;
spec_info.save_path = './figs/hodo';

line_annotate([],spec_info)

end

