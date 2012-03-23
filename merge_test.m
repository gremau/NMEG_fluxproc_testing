% create A and B -- B has a complete set of timestamps (Var1) and dummy
% observations (Var2).  A has an incomplete set of timestamps and
% observations.

B = dataset((1:5)', repmat(NaN, 5, 1))
A = dataset([1,2,3,5]', [1,2,3,5]')

% Where a timestamp is present in A, merge its obs into B
[C, Aidx, Bidx] = join(A, B, ...
                       'Keys', 'Var1',...
                       'Type', 'RightOuter', ...
                       'MergeKeys', true, ...
                       'RightVars', [false])

D = dataset((1:5)')
E = dataset([1,2,3,5]', [1,2,3,5]')

% Where a timestamp is present in A, merge its obs into B
[F, Didx, Eidx] = join(D, E, ...
                       'Keys', 'Var1',...
                       'Type', 'LeftOuter', ...
                       'MergeKeys', true)


