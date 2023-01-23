%% introduction
% % This demo is for comparing voltage results between different hour in a day
% % For example, 24 hours are splited into 6 groups and voltage results are compared
clearvars
addpath(genpath(pwd))
uqlab % check uqlab
seed = 1;
rng(seed)
%% prepare data
% % load necessary data, including load & gen values
load('save/data_all');   % data_gen, data_load, mpc
% Input data: dim 720*(135+135+130), [load P, load Q, generator P], uncertain variables
X = [data_load.value, data_load.value.*data_load.load_ratio.value', data_gen.value];
% % run power flow using matpower
% Output: dim 720*(1+1), [voltage magnitude, voltage angle], voltage mag and angle at bus pre-selected by NREL
% Note: output can be other desired variables, such as line power flow
% Y = solver_wecc(X);

%% split data into groups
% % Take 6 groups as an example: 24-hour split into hour[15:18], [19:22], [23:02], [3:6], [7:10], [11:14]
% % Xs: 1*n_split cells, each refers to a group
% % split idx
idx_origin = 1:24;
idx_actual = circshift(idx_origin, 10);
% % split dataset
n_split = 6;
[Xs, Xh, idx_actual_split] = split_hour_data(X, idx_actual, n_split);

%% solve power flow with different groups
for i=1:n_split
    Y{i} = solver_wecc(Xs{i});
end

%% compare different group voltage pdf
for i=1:n_split
    figure; hold on;
    histogram(Y{i}(:,1), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    xlabel('Voltage magnitude/angle (pu/deg)'); ylabel('Probability density');
    title(['Histogram of voltage magnitude/angle for hour ', num2str(idx_actual_split(:,i)')])
%     saveas(gcf, ['./plot/demo3/group_data_', num2str(i), '.jpg'])
end

