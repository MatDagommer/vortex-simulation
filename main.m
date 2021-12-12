%% BORN-VON-KARMAN VORTEX SIMULATION 

% Matthieu Dagommer and Emilie Sotty
% 138th Promotion ESPCI Paris

%% RETRIEVING DATA

% Syntax: Data folders should be written as: Re_XX where XX is the Reynolds
% number. Example: 'Re_10' stands for Re = 10.

folders_info = dir('Re*');
nb_folders = length(folders_info);
folder_names = cell(1,nb_folders);
for ii=1:nb_folders
    folder_names{ii} = folders_info(ii).name;
end


Re = zeros(1, nb_folders);
data = struct;

for ii=1:nb_folders
    folder_name = folder_names{ii};
    re_number = str2double(folder_name(4:end));
    Re(ii) = re_number;
    file = [folder_name '\f_vs_t_b10_re' ...
        num2str(re_number) '.txt'];
    data.(folder_name) = importdata(file);
    
    % Dimensionless time step
    data.(folder_name)(:,1) = data.(folder_name)(:,1)*0.1;
end

sorting_array = [Re; 1:length(Re)]';
sorted_array = sortrows(sorting_array, 1);
order = sorted_array(:,2);
folder_names_sorted = cell(1,length(folder_names));
for ii=1:length(folder_names)
    folder_names_sorted{ii} = folder_names{order(ii)};
end
folder_names = folder_names_sorted;
Re = sorted_array(:,1);

%% DRAG COEFFICIENT VS TIME

figure
nb_exp = nb_folders; % exp for 'experiment'
exp_names = folder_names;
legend_names = [];

for ii=1:nb_exp
    exp_name = exp_names{ii};
    re_number = exp_name(4:end);
    
    nb_iter = length(data.(exp_name)(:,1)); 

    range = 1:length(data.(exp_name)(:,1));
    hold on
    plot(data.(exp_name)(range,1),data.(exp_name)(range,2),'LineWidth',1.5)
    
    legend_name = ['Re = ' re_number];
    legend_names = [legend_names convertCharsToStrings(legend_name)];
end

grid on
legend(legend_names,'Interpreter', 'Latex');
xlabel('time (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
ylabel('drag coefficient (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
title('$\textbf{Drag coefficient versus time at different Reynolds numbers}$',...
    'Interpreter', 'Latex', 'FontSize', 12)

%% AVERAGE DRAG COEFFICIENT

figure
drag_coef = zeros(1,nb_exp);

for ii = 1:nb_exp
    exp_name = exp_names{ii};
    
    window_max = length(data.(exp_name)(:,1)); % number of time steps
    window_min = floor(window_max/2);
    avg_window = window_min:window_max;
    % Range over which the average is performed
    
    avg_drag_coef = mean(data.(exp_name)(avg_window,2));
    drag_coef(ii) = avg_drag_coef;
end

% Use log-log scale for plotting

loglog(Re, drag_coef, 'b--o', 'MarkerSize', 10, 'LineWidth', 2)
hold on 
loglog(Re, drag_coef, 'rx', 'MarkerSize', 10, 'LineWidth', 2)
grid on
xlabel('Reynolds Number (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
ylabel('Drag coefficient (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
title('$\textbf{Average drag coefficient versus Reynolds Number}$',...
    'Interpreter', 'Latex', 'FontSize', 12)

%% LIFT COEFFICIENT VERSUS TIME

figure
nb_exp = nb_folders; % exp for 'experiment'
exp_names = folder_names;
legend_names = [];

for ii=1:nb_exp
    exp_name = exp_names{ii};
    re_number = exp_name(4:end);
    
    nb_iter = length(data.(exp_name)(:,1)); 

    range = 1:length(data.(exp_name)(:,1));
    hold on
    plot(data.(exp_name)(range,1),data.(exp_name)(range,3),'LineWidth',1.5)
    
    legend_name = ['Re = ' re_number];
    legend_names = [legend_names convertCharsToStrings(legend_name)];
end

grid on
legend(legend_names);
xlabel('time (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12')
ylabel('lift coefficient (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
title('$\textbf{Lift coefficient versus time at different Reynolds numbers}$',...
    'Interpreter', 'Latex', 'FontSize', 12)

%% AVERAGE LIFT COEFFICIENT

figure
lift_coef = zeros(1,nb_exp);

for ii = 1:nb_exp
    exp_name = exp_names{ii};
    re_number = exp_name(4:end);
    
    window_max = length(data.(exp_name)(:,1)); % number of time steps
    window_min = floor(window_max/2);
    avg_window = window_min:window_max;
    % Range over which the average is performed
    
    avg_lift_coef = mean(data.(exp_name)(avg_window,3));
    lift_coef(ii) = avg_lift_coef;
end

% Use log-log scale for plotting

loglog(Re, lift_coef, 'b--o', 'MarkerSize', 10, 'LineWidth', 2)
hold on 
loglog(Re, lift_coef, 'rx', 'MarkerSize', 10, 'LineWidth', 2)
grid on
xlabel('Reynolds Number (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
ylabel('Lift coefficient (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
title('$\textbf{Average lift coefficient versus Reynolds Number}$', 'Interpreter',...
    'Latex', 'FontSize', 12)

%% FFT OF LIFT COEFFICIENT

figure
freq = 10; % sampling frequency
T = 1/freq; % sampling period

vortex_freq = zeros(nb_exp,2);
legend_names = [];
for ii = 1:nb_exp
   exp_name = exp_names{ii};
   re_number = str2double(exp_name(4:end));
   
   lift_fft = fft(data.(exp_name)(:,3));
   nb_iter = length(data.(exp_name)(:,1));
   
   P2 = abs(lift_fft/nb_iter); 
   P1 = P2(1:nb_iter/2+1);
   P1(2:end-1) = 2*P1(2:end-1);  
   
   f = freq*(0:(nb_iter/2))/nb_iter; % frequency range (dimensionless)
   range = 1:length(f)/10; % window range
   
   hold on
   plot(f(range),P1(range), 'LineWidth', 1.5)
   legend_name = sprintf('Re = %d',re_number);
   legend_names = [legend_names convertCharsToStrings(legend_name)];
   xlabel('frequency (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
   ylabel('$\mathcal{F}$(lift) (dimensionless)',...
       'Interpreter','Latex', 'FontSize', 12)
   title('$\textbf{Fourier-Transform of the lift coefficient}$','Interpreter',...
       'Latex', 'FontSize', 12)
   
   [~,fe_idx] = max(P1);
   vortex_freq(ii,:) = [re_number f(fe_idx)];
   
end
grid on
legend(legend_names,'Interpreter', 'Latex')

%% MEASURING VORTEX EMISSION FREQUENCY

% Vortex emission frequency can be retrieved using the periodicity of the 
% lift coefficient. 

figure
plot(vortex_freq(:,1), vortex_freq(:,2),'b--o', 'MarkerSize', 10, 'LineWidth', 1.5)
hold on
plot(vortex_freq(:,1), vortex_freq(:,2),'rx', 'MarkerSize', 10, 'LineWidth', 2.5)
grid on
xlabel('Reynolds number (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
ylabel('vortex frequency (dimensionless)', 'Interpreter', 'Latex', 'FontSize', 12)
title('Vortex emission frequency vs Reynolds number', 'Interpreter'...
    , 'Latex', 'FontSize', 12)

axis([0 600 -0.05 0.3])



