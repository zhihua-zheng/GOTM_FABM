function   plot_time_depth(t, d, scalar, spec_info)

% plot_time_depth
%==========================================================================
%
% USAGE:
%  plot_time_depth(t, d, scalar, spec_info)
%
% DESCRIPTION:
%  Function to plot temporal evolution of scalar profile
%
% INPUT:
%
%  t - one dimensional array of date number
%  d - one dimensional array of depth (deep to shallow)
%  scalar - two dimensional array of scalar value
%  spec_info - struct containing additional annotating information
%
% OUTPUT:
%
%  figure
%
% AUTHOR:
%  September 2 2018. Zhihua Zheng                       [ zhihua@uw.edu ]
%

%% determine color value limits -------------------------------------------
if isempty(spec_info.clim)
    
    CL = [min(min(scalar)) max(max(scalar))];  % default option
elseif spec_info.clim == 'symmetric'
    
    tmp1 = min(min(scalar));
    tmp2 = max(max(scalar));
    tmp = max(abs(tmp1), abs(tmp2)); % the one with largest magnitude
    CL = [-tmp tmp];
else
    CL = spec_info.clim;
end
%% ------------------------------------------------------------------------

cnum = 15;
conts = linspace(CL(1),CL(2),cnum);
[T, Z] = meshgrid(t,d);

figure('position', [0, 0, 980, 250])
cmocean(spec_info.color)
contourf(T,Z,scalar,conts,'LineWidth',0.01,'LineStyle','none')

  caxis(CL);
  box on
  datetick('x',spec_info.timeformat)
%   title('COREII LAT-54 LON254 SMC 20080915-20090915 VR1m DT1800s',...
%     'fontname','computer modern', 'fontsize', 14,'Interpreter', 'latex')
  ylabel(spec_info.ylabel, 'fontname', 'computer modern', 'fontsize', ...
      14,'Interpreter', 'latex')
  setDateAxes(gca,'XLim',[t(1) t(end)],'YLim',spec_info.ylim,'fontsize',...
      11,'fontname','computer modern','TickLabelInterpreter','latex')
  
  h = colorbar('EastOutside');
  h.Label.String = spec_info.clabel;
  h.Label.Interpreter = 'latex';
  h.Label.FontName = 'computer modern';
  h.Label.FontSize = 14;
  set(h,'TickLabelInterpreter','latex','fontsize',9);

%% save or not ------------------------------------------------------------
if spec_info.save
    
  set(gca,'LooseInset', get(gca,'TightInset')); % no blank edge
  saveas(gcf, spec_info.save_path, 'epsc');
  
  % clean the white lines in the patch
  epsclean([spec_info.save_path,'.eps'],'closeGaps',true) 
end

end