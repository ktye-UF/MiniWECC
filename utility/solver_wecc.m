function varargout = solver_wecc(X)
% % power flow solver for miniwecc
% % Input: 
% X: n_sample * dim_input, [load, gen]
% % Output:
% Y: n_sample * dim_output, [voltage magnitude, voltage angle]
% ctime_pf: CPU time
% is_converge: check if voltage between limits

%% prepare
% % information about basecase & data
load('save/data_all', 'data_gen', 'data_load', 'mpc', 'bus_output');   % data_gen, data_load, mpc
mpc_this = mpc;
mpopt = mpoption('verbose', 0, 'out.all', 0);   % no print
% runpf('WECC240_HS_2018_Basecase_modified', mpopt)

% % get dim
[n, dim_input] = size(X);
[~, dim_load] = size(data_load.value);
[~, dim_gen] = size(data_gen.value);
% if dim_input ~= dim_load+dim_gen
%     error('Input dimension error: not equal to load + gen')
% end

%% run simulation one by one
V = NaN(n, size(mpc.bus,1));
A = NaN(n, size(mpc.bus,1));
branch_p = NaN(n, size(mpc.branch,1));
branch_q = NaN(n, size(mpc.branch,1));
is_converge = ones(n, 1);
% [X(i, 1:dim_load)', X(i, 1:dim_load)' .* data_load.load_ratio.value, X(i, 1:dim_load)' .* data_load.load_ratio.value./X(i, 1:dim_load)']
% [X(i, 1:dim_load)', X(i, dim_load+1:dim_load*2)', X(i, dim_load+1:dim_load*2)'./X(i, 1:dim_load)']
tic
for i = 1:n     % iter through sample
    % % version 1: Q as latent
%     % change load
%     mpc_this.bus(data_load.idx, 3) = X(i, 1:dim_load)'; % 3rd col: P
%     mpc_this.bus(data_load.idx, 4) = X(i, 1:dim_load)' .* data_load.load_ratio.value; % 4th col: Q = P * ratio
%     % change gen
%     mpc_this.gen(data_gen.idx, 2) = X(i, dim_load+1:dim_load+dim_gen)'; % 2nd col: P
    % % version 2: Q as input
    % change load
    mpc_this.bus(data_load.idx, 3) = X(i, 1:dim_load)'; % 3rd col: P
    mpc_this.bus(data_load.idx, 4) = X(i, dim_load+1:dim_load*2)'; % 4th col: Q as input
    % change gen
    mpc_this.gen(data_gen.idx, 2) = X(i, dim_load*2+1:dim_load*2+dim_gen)'; % 2nd col: P
    
    % get result
    result = runpf(mpc_this, mpopt);
    % extract voltage, power flow
    V(i,:) = result.bus(:,8)';     % 8th column: magnitude
    A(i,:) = result.bus(:,9)';     % 9th column: angle (degree)
    branch_p(i,:) = result.branch(:,14);   % 14th col: P
    branch_q(i,:) = result.branch(:,15);   % 14th col: Q
    % check convergence
    if any(V(i,:)<0.9) || any(V(i,:)>1.1)
        is_converge(i) = 0;
    end
end
ctime_pf = toc;
%% determine output
% % volt magnitude
for i=1:length(bus_output)
    idx_volt(i,1) = find(mpc.bus(:,1)==bus_output(i));
end
% % volt angle
idx_output = [idx_volt, idx_volt+243];  % 
Y_all = [V A];     % n_sample * dim_output
Y = Y_all(:, idx_output);
varargout = {Y, ctime_pf, is_converge};








