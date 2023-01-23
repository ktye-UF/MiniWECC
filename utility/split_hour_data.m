function [Xs, varargout] = split_hour_data(X, idx_actual, n_split)
% % Input:
% X: 720*dim, original dataset
% idx_actual: actual hour index, 24 hours, start from 15:00
% n_split: numberl of group
% % Output:
% Xs: 1*n_split cells: splited dataset
% varargout: {Xh, idx_split}, {1*24 cells: hourly data, actual hour index after grouping}

% % split into hourly-data group: 24 groups for 24 hour
intvl = 24/n_split; % hours in each group
idx_actual_split = buffer(idx_actual, intvl);    % column: splited actual hour (start from 15:00)
for i=1:24
    Xh{i} = X(i:24:end,:);  % hourly data
end
varargout{1} = Xh;
varargout{2} = idx_actual_split;

% % split a day (24 hours) into groups
idx_split = buffer(1:24,intvl);     % column: idx after split for Xh (start from 1)
for j=1:n_split
    Xs{j} = [];
    for k=1:intvl
        Xs{j} = [Xs{j}; Xh{idx_split(k,j)}];
    end
end