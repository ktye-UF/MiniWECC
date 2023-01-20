%% introduction
% % This demo is to show the pipeline of Gaussian process surrogate modeling
% % GP as a surrogate model aims to speed up power flow calculation
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
Y = solver_wecc(X);
%% prepare training and testing dataset
% % training dataset
n_train = round(size(X,1)*0.25);     % 25% training
[data_train.X, idx_train] = datasample(X, n_train, 'Replace', false);
data_train.Y = Y(idx_train, :);
% % test dataset
idx_test = setdiff(1:size(X,1), idx_train);
data_test.X = X(idx_test, :);
data_test.Y = Y(idx_test, :);
%% model training (gaussian process)
% % Note: it may take a few minutes to train, you may load pre-trained model from './save/demo_v2'
flag_train = 0;     % 1 -> perform training process; 0 -> load pre-trained model
flag_fast_eval = 1; % 1 -> fast training; 0 -> using optimization when training
% % parameter
trend_type = 'linear';	% simple, ordinary, linear, quadratic, polynomial
corr_fam = 'matern-3_2';  % linear, exponential, gaussian, matern-3_2, matern-5_2
estimate = 'CV';  % ML, CV
opt = 'none';    % none, LBFGS, GA, HGA, CMAES, HCMAES
if strcmpi(opt, 'none')
    noise_infer = [];   % 'auto', []
else
    noise_infer = 'auto';
end
% % construct GP model
if flag_train
    if ~flag_fast_eval
        opt = 'HCMAES';
    end
    param = v2struct(trend_type, corr_fam, estimate, opt, noise_infer);
    disp('Constructing model...')
    [myGP, ctime_gp] = construct_krig(data_train, param);
    disp(['CPU time for GP training: ', num2str(ctime_gp), ' s'])
else
    disp('Loading model...')
    load('save/demo_v2')
    disp('Loading model...done!')
end
%% run test samples
disp('Evaluating test samples...')
tic
y_pred = uq_evalModel(myGP, data_test.X);
ctime_test = toc;
disp(['CPU time for GP test: ', num2str(ctime_test), ' s'])
%% error
mae = abs(data_test.Y - y_pred);
mape = abs((data_test.Y - y_pred)./data_test.Y)*100;
mae_mean = mean(mae);
mape_mean = mean(mape);
%% compare result: voltage amgnitude/angle pdf
close all
% % 
for i=1:size(Y,2)
    figure; hold on;
    histogram(data_test.Y(:,i), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    histogram(y_pred(:,i), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    legend('MC', 'GP')
    xlabel('Voltage magnitude/angle (pu/deg)'); ylabel('Probability density');
    title(['Histgram of voltage magnitude/angle at bus 2202'])
end
% % PDF by kernel density estimation
for i=1:size(Y,2)
    figure; hold on;
    [f(1,:), xi(1,:)] = ksdensity(data_test.Y(:,i));
    plot(xi(1,:), f(1,:));
    [f(2,:), xi(2,:)] = ksdensity(y_pred(:,i));
    plot(xi(2,:), f(2,:));
    legend('MC', 'GP')
    xlabel('Voltage magnitude/angle (pu/deg)'); ylabel('Probability density');
    title(['PDF of voltage magnitude/angle at bus 2202'])
end

%% save
% save('save/demo_paper', 'myGP', 'param', 'data_train', 'data_test', 'y_pred')







