function ds_filled = dataset_fill_timestamps( ds, t_var, varargin )    
% DATASET_FILL_TIMESTAMPS - fill in missing timestamps in a dataset containing a
% regularly-spaced time series and discard duplicate timestamps.
%
% FIXME - Deprecated. This function is being superseded by 
% 'table_fill_timestamps.m'
%
% t_var specifies the name of the dataset variable containing the (unfilled)
% timestamps for the data in ds.  The timestamps must be Matlab serial
% datenumbers.  That is, ds.( t_var ) must contain a vector of Matlab serial datenumbers.
%
% dataset_fill_timestamps identifies missing timestamps in ds.( t_var ),
% assuming a regular interval specified by the parameter-value pair delta_t.
% The default delta_t value is 30 minutes.  Where timestamps are added to ds.(
% t_var ) to complete the time series, all other variables are populated with
% NaN.
%
% If a timestamp occurs more than once, the first row is kept and subsequent
% rows discarded. 
%
% USAGE:
%   ds_filled = dataset_fill_timestamps( ds, t_var )
%   ds_filled = dataset_fill_timestamps( ds, t_var, t_min, t_max )
%   ds_filled = dataset_fill_timestamps( ds, ..., 'tstamps_as_strings', ...
%                                                  logical_value )
%
% INPUTS:
%   ds: dataset array; the data to be filled
%   t_var: string containing the name of the time variable in ds
%       (e.g. 'TIMESTAMP').  ds.( t_var ) must contain the timestamps for the
%       data as matlab serial datenumbers. 
%
% PARAMETER-VALUE PAIRS
%   delta_t: optional: interval of the time series, in days.  e.g., 30
%          mins should have delta_t value of 1/48.  Defaults to 1/48.
%   t_min: Matlab serial datenumber; timestamp at which to begin filling.
%          Defaults to the earliest timestamp in the dataset.
%   t_max: Matlab serial datenumber; timestamp at which to end filling.
%          Defaults to the latest timestamp in the dataset.
%   tstamps_as_strings: true|{false}: if true, return timestamps as strings.
%          If false (the default) return timestamps as Matlab serial
%          datenumbers. 
%
% SEE ALSO
%    dataset, datenum
%
% author: Timothy W. Hilton, UNM, Dec. 2011

% -----
% define optional inputs, with defaults
% -----

warning( 'This function ( dataset_fill_timestamps.m ) is deprecated' );

p = inputParser;
p.addRequired( 'ds' ); %, @( x ) isa( x, 'dataset' ) );
p.addRequired( 't_var', @ischar );
p.addOptional( 'delta_t', ( 1 / 48), @isnumeric );
p.addOptional( 'tstamps_as_strings', false, @islogical );
p.addParamValue( 't_min', ...
                 NaN, ...
                 @( x ) isnumeric( x ) );
p.addParamValue( 't_max', ...
                 NaN, ...
                 @( x ) isnumeric( x ) );
% parse optional inputs
p.parse( ds, t_var, varargin{ : } );

ds = p.Results.ds;
t_var = p.Results.t_var;
delta_t = p.Results.delta_t;
t_min = p.Results.t_min;
t_max = p.Results.t_max;
tstamps_as_strings = p.Results.tstamps_as_strings;

if isnan( t_min )
    t_min = min( ds.( t_var ) );
end
if isnan( t_max )
    t_max = max( ds.( t_var ) );
end

full_ts = ( t_min : delta_t : t_max )';
full_ts = cellstr( datestr( full_ts, 'mm/dd/yyyy HH:MM:SS' ) );

ds.( t_var ) = cellstr( datestr( ds.( t_var ), ...
                                 'mm/dd/yyyy HH:MM:SS' ) );

%% create a dataset containing the filled timestamps
ds_filled = dataset( { full_ts,  t_var } );

%% fill in the timestamps in ds, adding NaNs in all variables where
%% missing timestamps were added
[ ds_filled, Aidx, Bidx ] = join( ds_filled, ...
                                  ds, ...
                                  'Keys', t_var, ...
                                  'Type', 'LeftOuter', ...
                                  'MergeKeys', true );

% timestamps (they're strings now) got sorted lexigrapically -- sort
% them now by the actual date
dn = datenum(ds_filled.( t_var ), 'mm/dd/yyyy HH:MM:SS');
[ ~, idx ] = sort( dn );
ds_filled = ds_filled( idx, : );

if ~tstamps_as_strings
    ds_filled.( t_var ) = dn ( idx );
end

%remove duplicate timestamps
dup_tol = 0.00000001;  %floating point tolerance
dup_idx = find( diff( ds_filled.( t_var ) ) < dup_tol ) + 1;
ds_filled( dup_idx, : ) = [];

