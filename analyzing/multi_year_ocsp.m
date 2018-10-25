%% multi_year_ocsp

% Main program to analyze and compare output data from GOTM simulations for
% Ocean Climate Station Papa in multiple years

% Zhihua Zheng, UW-APL, Oct. 18 2018

%% read outputs
clear
main_dir = '~/Documents/GitLab/GOTM_dev/run/OCSPapa_year_repeat';
cd(main_dir)
dir_str = genpath(main_dir);

% regular expression for any substring doesn't contain path seperator
expression = ['[^',pathsep,']*'];
sep_idx = regexp(dir_str,pathsep); % index of path seperator

% truncate the string to ignore the main folder
sub_folders = regexp(dir_str(sep_idx(1):end),expression,'match');

% eliminate figs folder, delete the entry satisfying condition
sub_folders(endsWith(sub_folders,'/figs')) = [];

turb_method = cell(size(sub_folders));
start_date = cell(size(sub_folders));
out_all = cell(size(sub_folders));

% loop through subfolders
for i = 1:length(sub_folders)
    
    path = sub_folders{i};
    tmp = strsplit(path,'/');
    tmp = strsplit(tmp{end},'_');
    turb_method(i) = tmp(2); % get turbulence closure method name
    start_date(i) = tmp(3); % get start date
    
    cd(path)
    dinfo = dir(fullfile('./*.nc'));
    fname = fullfile('./',{dinfo.name});
    
    % read outputs
    out_all{i} = read_gotm_out(fname{:},2);
end

clear spe_inx expression fname dinfo
cd(main_dir)

%% read variables
[period,~,inx_p] = unique(start_date);
[closure,~,inx_c] = unique(turb_method);

all_sst = cell(size(out_all));
all_sst_obs = cell(size(out_all));
all_mld = cell(size(out_all));
all_date = cell(size(out_all));
for i = 1:length(out_all)
    
     all_sst{i} = out_all{i}.temp(128,:)';
     all_sst_obs{i} = out_all{i}.sst_obs; 
     all_mld{i} = out_all{i}.mld_surf;
     all_date{i} = datevec(char(out_all{i}.date));
end


%% SST statistics

% find bounding values in SST
sst_min = zeros(length(out_all),2); % matrix containning min vlaue
sst_max = zeros(length(out_all),2); % matrix containning max vlaue
num = 0; % number of points
sst_diff = cell(size(out_all)); % difference in SST
mld_diff = cell(size(out_all)); % difference mixed layer depth

for i = 1:length(out_all)
    
    sst_min(i,1) = min(all_sst_obs{i});
    sst_min(i,2) = min(all_sst{i});
    
    sst_max(i,1) = max(all_sst_obs{i});
    sst_max(i,2) = max(all_sst{i});
    
    num = num + length(all_sst{i});
    sst_diff{i} = all_sst{i} - all_sst_obs{i};
end

sq_sum = zeros(1,2); % summation of deviation square
for i = 1:length(sst_diff)
    if inx_c(i) == 1 % for closure{1}
        sq_sum(1) = sq_sum(1) + sum(sst_diff{i}.^2);
    else % for closure{2}
        sq_sum(2) = sq_sum(2) + sum(sst_diff{i}.^2);
    end
end
rmse = sqrt(2*sq_sum./(num)); % root mean square error

%% --------- overall scatter plot -----------------------------------------

figure('position', [0, 0, 690, 680])

for i = 1:length(out_all)
    if inx_c(i) == 2 % for closure{2}
        dummy = randn(size(all_sst{i})); % dummy variable for 3D plot
        s2 = scatter3(all_sst_obs{i},all_sst{i},dummy,9,rgb('coral'),'filled');
        s2.MarkerFaceAlpha = 0.9;
        hold on
    else % for closure{1}
        dummy = randn(size(all_sst{i})); % dummy variable for 3D plot
        s1 = scatter3(all_sst_obs{i},all_sst{i},dummy,9,rgb('carolina blue'),'filled');
        s1.MarkerFaceAlpha = 0.9;
        hold on
    end
end
% Change viewpoint 
view(2)

hold off 
axis square
box on
%grid on

xlim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
ylim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])

h_ref = refline(1,0);
h_ref.Color = [.5 .5 .5];
h_ref.LineWidth = 1.5;

lgd = legend([s1 s2],[closure{1},', RMSE $\sim$ ',num2str(round(rmse(1),3))],...
    [closure{2},', RMSE $\sim$ ',num2str(round(rmse(2),3))],'Location','best');
set(lgd,'Interpreter','latex','fontsize', 22)

xlabel('\textit{obs. SST} ($$^{\circ}C$$)', 'fontname',...
    'computer modern', 'fontsize', 28,'Interpreter', 'latex')
ylabel('\textit{model SST} ($$^{\circ}C$$)', 'fontname',...
    'computer modern', 'fontsize', 28,'Interpreter', 'latex')
setDateAxes(gca,'fontsize',20,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')

set(gca,'LooseInset', get(gca,'TightInset')); % no blank edge
saveas(gcf, './figs/all_sst_scatter', 'png');

%% --------- seasonal scatter plot ----------------------------------------

% TO-DO: 1.calculate rmse for each season
%        2.add linear regression lines to the scatter plot
%        3.look the time series of deviation
%        4.do a spectral analysis of deviation

season_list = [6  7  8;
               9  10 11;
               12 1  2;
               3  4  5];
season_str = {'J-J-A','S-O-N.','D-J-F','M-A-M'};

figure('position', [0, 0, 690, 680])
   
for j = 1:4
        
    subplot(2,2,j)

    for i = 1:length(out_all)

        month = all_date{i}(:,2);
        season_inx = ismember(month,season_list(j,:));

        if inx_c(i) == 2 % for closure{2}
            dummy = randn(size(all_sst{i}(season_inx)));
            s2 = scatter3(all_sst_obs{i}(season_inx),...
                all_sst{i}(season_inx),dummy,5,rgb('coral'),'filled');
            s2.MarkerFaceAlpha = 0.5;
            hold on
            
        else % for closure{1}
            dummy = randn(size(all_sst{i}(season_inx)));
            s1 = scatter3(all_sst_obs{i}(season_inx),...
                all_sst{i}(season_inx),dummy,5,rgb('carolina blue'),'filled');
            s1.MarkerFaceAlpha = 0.5;
            hold on
        end
    end
    % Change viewpoint 
    view(2)
    
    hold off
    axis square
    box on
    
    xlim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
    ylim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
    
    xticks([6 8 10 12 14 16 18])
    yticks([6 8 10 12 14 16 18])
    
    h_ref = refline(1,0);
    h_ref.Color = [.5 .5 .5];
    h_ref.LineWidth = 1.5;
    
    title(season_str{j},'FontSize',20,'FontName',...
        'computer modern','Interpreter','latex')
    setDateAxes(gca,'fontsize',15,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')
end


% lgd = legend([s1 s2],[closure{1},', RMSE $\sim$ ',num2str(round(rmse(1),3))],...
%     [closure{2},', RMSE $\sim$ ',num2str(round(rmse(2),3))]);
% newPosition = [0.38 0.49 0.3 0.05];
% newUnits = 'normalized';
% set(lgd,'Position',newPosition,'Units',newUnits,'Interpreter',...
%     'latex','fontsize',15,'orientation','horizontal');

[ax1, h1] = suplabel('\textit{model SST} ($$^{\circ}C$$)','y');
[ax2, h2] = suplabel('\textit{obs. SST} ($$^{\circ}C$$)','x');
set(h1,'FontSize',20,'FontName','computer modern','Interpreter','latex');
set(h2,'FontSize',20,'FontName','computer modern','Interpreter','latex');

set(gca,'LooseInset', get(gca,'TightInset')); % no blank edge
saveas(gcf,'./figs/season_sst_scatter', 'png');

%% vertical velocity

% TO-DO: 1.Unrealistic large value for ww at i=2,3 simulation, but TkE
%          value is normal. The bug is due to the computation of TKE
%          components.
%       

model_par.dtr0 = -0.2; % derivative of density w.r.t. temperature
model_par.dsr0 = 0.78; % derivative of density w.r.t. salinity
model_par.A1 = 0.92;
model_par.B1 = 16.6;
model_par.rho_0 = 1027; % reference density of seawater
model_par.rescale_r = 1;

figure('position', [0, 0, 500, 480])
all_w_rms = cell(size(out_all)); % cell to store mixed layer averaged w_rms
v_lim = 0; % velocity limit for plotting

for i = 1:length(out_all)
    
    u_star = out_all{i}.u_taus; % water side friction velocity
    tke_comps = get_tke_comp(model_par,out_all{i},0); % no rotation of coor.
    ww = tke_comps(:,:,3);
    zi = mean(out_all{i}.zi,2);
    
    % average the ww in the mixed layer
    all_w_rms{i} = average_ml(all_mld{i},ww,zi,0); % temporally as square
    all_w_rms{i}(all_w_rms{i}<0) = NaN;
    all_w_rms{i} = sqrt(all_w_rms{i});% to rms value
    
    v_lim = max(v_lim,max(all_w_rms{i}));
    v_lim = max(v_lim,max(u_star));
        
    if inx_c(i) == 2 % for closure{2}
        dummy = randn(size(u_star));        
        s2 = scatter3(u_star,all_w_rms{i},dummy,12,rgb('coral'),'filled');
        s2.MarkerFaceAlpha = 0.9;
        hold on
    else % for closure{1}
        dummy = randn(size(u_star));        
        s1 = scatter3(u_star,all_w_rms{i},dummy,12,rgb('aqua'),'filled');
        s1.MarkerFaceAlpha = 0.9;
        hold on
    end
end
% Change viewpoint 
view(2)

hold off 
axis square
box on
grid on

xlim([0 1.01*v_lim])
ylim([0 1.01*v_lim])

h_ref = refline(1.07,0);
h_ref.Color = [.5 .5 .5];
h_ref.LineWidth = 1.5;

lgd = legend([s1 s2],[closure{1}],...
    [closure{2}],'Location','best');
set(lgd,'Interpreter','latex','fontsize', 22)

xlabel('friction velocity $$u_*$$', 'fontname',...
    'computer modern', 'fontsize', 28,'Interpreter', 'latex')
ylabel('vertical velocity $$w_{rms}$', 'fontname',...
    'computer modern', 'fontsize', 28,'Interpreter', 'latex')
setDateAxes(gca,'fontsize',20,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')

%export_fig('./figs/w_ustar','-eps','-transparent','-painters')


