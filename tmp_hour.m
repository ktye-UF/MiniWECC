function Xs = group_data(Xh, n_split)
intvl = 24/n_split;
idx_split = buffer(1:24,intvl);     % column: idx after split
for j=1:n_split
    Xs{j} = [];
    for k=1:intvl
        Xs{j} = [Xs{j}; Xh{idx_split(k,j)}];
    end
end

