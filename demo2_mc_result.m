%% introduction
% % This demo is to compare Monte-Carlo results based on 720 samples and 360 samples
clearvars
addpath(genpath(pwd))
uqlab    % check uqlab
seed = 1;
rng(seed)
%% prepare data
% load necessary data, including load & gen values
load('save/data_all');   % data_gen, data_load, mpc
% Input data: dim 720*(135+135+130), [load P, load Q, generator P]
X = [data_load.value, data_load.value.*data_load.load_ratio.value', data_gen.value];
%% solve power flow with different samples
% % X: dim 720*400, [load P, load Q, gen P]
% % Y: dim 720*2, [V mag]
% % using 720 samples
[Y, ctime_pf, ~] = solver_wecc(X);
% % using 360 samples
X_half = datasample(X, 360, 'Replace', false);
Y_half = solver_wecc(X_half);
%% compare result: voltage amgnitude/angle pdf
% % 
for i=1:size(Y,2)
    figure; hold on;
    histogram(Y(:,i), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    histogram(Y_half(:,i), 'Normalization', 'pdf', 'FaceAlpha', 0.8)
    legend('MC 720 samples', 'MC 360 samples')
    xlabel('Voltage magnitude/angle (pu/deg)'); ylabel('Probability density');
    title(['Histogram of voltage magnitude/angle at bus 2202'])
end



