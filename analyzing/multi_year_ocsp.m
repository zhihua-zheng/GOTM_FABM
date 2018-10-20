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

% find extreme values in SST
sst_min = zeros(length(out_all),2); % matrix containning min vlaue
sst_max = zeros(length(out_all),2); % matrix containning max vlaue
num = 0; % number of points
sst_diff = cell(size(out_all)); % difference in SST
mld_diff = cell(size(out_all)); % difference mixed layer depth

for i = 1:length(out_all)
    
    sst_min(i,1) = min(all_sst_obs{i});
    sst_min(i,2) = min(all_sst{i});
    
    sst_min(i,1) = max(all_sst_obs{i});
    sst_max(i,2) = max(all_sst{i});
    
    num = num + length(all_sst{i});
    sst_diff{i} = all_sst{i}(2:end) - all_sst_obs{i}(2:end);
end

sq_sum = zeros(1,2); % summation of deviation square
for i = 1:length(sst_diff)
    if inx_c(i) == 1 % for closure{1}
        sq_sum(1) = sq_sum(1) + sum(sst_diff{i}.^2);
    else % for closure{2}
        sq_sum(2) = sq_sum(2) + sum(sst_diff{i}.^2);
    end
end
rmse = sqrt(2*sq_sum./(num-length(period))); % root mean square error

%% --------- overall scatter plot -----------------------------------------

figure('position', [0, 0, 460, 450])

for i = 1:length(out_all)
    if inx_c(i) == 2 % for closure{2}
        s2 = scatter(all_sst_obs{i},all_sst{i},9,rgb('light red'),'filled');
        s2.MarkerFaceAlpha = 0.5;
        hold on
    else % for closure{1}
        s1 = scatter(all_sst_obs{i},all_sst{i},9,rgb('light blue'),'filled');
        s1.MarkerFaceAlpha = 0.5;
        hold on
    end
end

hold off 
axis equal
box on
grid on

xlim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
ylim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])

h_ref = refline(1,0);
h_ref.Color = [.5 .5 .5];
h_ref.LineWidth = 1.5;

lgd = legend([s1 s2],[closure{1},', RMSE $\sim$ ',num2str(round(rmse(1),3))],...
    [closure{2},', RMSE $\sim$ ',num2str(round(rmse(2),3))],'Location','best');
set(lgd,'Interpreter','latex','fontsize', 14)

xlabel('obs. SST ($$^{\circ}C$$)', 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
ylabel('Model SST ($$^{\circ}C$$)', 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
setDateAxes(gca,'fontsize',11,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')

export_fig('./figs/all_sst_scatter','-eps','-transparent','-painters')

%% --------- seasonal scatter plot ----------------------------------------
season_list = [6  7  8;
               9  10 11;
               12 1  2;
               3  4  5];
season_str = {'J. J. A.','S. O. N.','D. J. F.','M. A. M.'};

figure('position', [0, 0, 580, 550])
   
for j = 1:4
        
    subplot(2,2,j)

    for i = 1:length(out_all)

        month = all_date{i}(:,2);
        season_inx = ismember(month,season_list(j,:));

        if inx_c(i) == 2 % for closure{2}
            s2 = scatter(all_sst_obs{i}(season_inx),...
                all_sst{i}(season_inx),2,rgb('tomato'),'filled');
            s2.MarkerFaceAlpha = 0.3;
            hold on
            
        else % for closure{1}
            s1 = scatter(all_sst_obs{i}(season_inx),...
                all_sst{i}(season_inx),2,rgb('sky blue'),'filled');
            s1.MarkerFaceAlpha = 0.3;
            hold on
        end
    end
    
    hold off
    axis equal
    box on
    
    xlim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
    ylim([0.9*min(min(sst_min)) 1.01*max(max(sst_max))])
    
    xticks([6 8 10 12 14 16 18])
    yticks([6 8 10 12 14 16 18])
    
    h_ref = refline(1,0);
    h_ref.Color = [.5 .5 .5];
    h_ref.LineWidth = 1.5;
    
    title(season_str{j},'FontSize',14,'FontName',...
        'computer modern','Interpreter','latex')
    setDateAxes(gca,'fontsize',11,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')
end


lgd = legend([s1 s2],[closure{1},', RMSE $\sim$ ',num2str(round(rmse(1),3))],...
    [closure{2},', RMSE $\sim$ ',num2str(round(rmse(2),3))]);
newPosition = [0.38 0.49 0.3 0.05];
newUnits = 'normalized';
set(lgd,'Position',newPosition,'Units',newUnits,'Interpreter',...
    'latex','fontsize',11,'orientation','horizontal');

[ax1, h1] = suplabel('Model SST ($$^{\circ}C$$)','y');
[ax2, h2] = suplabel('obs. SST ($$^{\circ}C$$)','x');
set(h1,'FontSize',14,'FontName','computer modern','Interpreter','latex');
set(h2,'FontSize',14,'FontName','computer modern','Interpreter','latex');

export_fig('./figs/season_sst_scatter','-eps','-transparent','-painters')

%% vertical velocity

figure('position', [0, 0, 460, 450])
tmp1 = 0;
for i = 1:length(out_all)
    
    tke_comps = get_tke_comp(model_par,out_all{i},1);
    h_new = diff(out_all{i}.z);
    w_rms2 = sum(tke_comps(:,:,3).*h_new)./(sum(h_new));
    w_rms2(w_rms2<0) = NaN;
    u_star2 = (out_all{i}.u_taus).^2;
    tmp1 = max(tmp1,max(w_rms2));
    tmp1 = max(tmp1,max(u_star2));
    
    if inx_c(i) == 2 % for closure{2}
        s2 = scatter(u_star2,w_rms2,9,rgb('light red'),'filled');
        s2.MarkerFaceAlpha = 0.5;
        hold on
    else % for closure{1}
        s1 = scatter(u_star2,w_rms2,9,rgb('light blue'),'filled');
        s1.MarkerFaceAlpha = 0.5;
        hold on
    end
end

hold off 
axis equal
box on
grid on

xlim([0 1.01*tmp1])
ylim([0 1.01*tmp1])

h_ref = refline(1.35,0);
h_ref.Color = [.5 .5 .5];
h_ref.LineWidth = 3;

lgd = legend([s1 s2],[closure{1},', RMSE $\sim$ ',num2str(round(rmse(1),3))],...
    [closure{2},', RMSE $\sim$ ',num2str(round(rmse(2),3))],'Location','best');
set(lgd,'Interpreter','latex','fontsize', 14)

xlabel('friction velocity ($$u_*$$)', 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
ylabel('vertical velocity ($$w_{rms}$)', 'fontname',...
    'computer modern', 'fontsize', 14,'Interpreter', 'latex')
setDateAxes(gca,'fontsize',11,'fontname','computer modern',...
    'XMinorTick','on','YMinorTick','on','TickLabelInterpreter','latex')

%export_fig('./figs/w_ustar','-eps','-transparent','-painters')

