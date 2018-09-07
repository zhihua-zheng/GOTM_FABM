function   line_annotate(x, spec_info)

% line_annotate
%==========================================================================
%
% USAGE:
%  line_annotate(x, spec_info)
%
% DESCRIPTION:
%  Function to annotate a line plot
%
% INPUT:
%
%  spec_info - struct containing additional annotating information
%
% OUTPUT:
%
%  figure with annotation
%
% AUTHOR:
%  September 4 2018. Zhihua Zheng                       [ zhihua@uw.edu ]


box on

if spec_info.grid_on
    
    grid on
end

if spec_info.x_time

    datetick('x',spec_info.timeformat)
    setDateAxes(gca,'XLim',[x(1) x(end)],'fontsize',11,...
      'fontname','computer modern','TickLabelInterpreter','latex')
else 
    xlabel(spec_info.xlabel, 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
end

if spec_info.lgd
    
    lgd = legend(spec_info.lgd_label,'Location','best');
    set(lgd,'Interpreter','latex','fontsize', 14)
end

ylabel(spec_info.ylabel, 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
setDateAxes(gca,'fontsize',11,...
  'fontname','computer modern','TickLabelInterpreter','latex')

% save figure or not
if spec_info.save
    
    export_fig(spec_info.save_path,'-eps','-transparent','-painters')
end

end