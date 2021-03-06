function [ ts, keep_idx ] = datenum_2_round30min(ts_in, tol, t0)
% DATENUM_2_ROUND30MINN - round a set of timestamps to the nearest half hour,
% with user-specified tolerance.
%
% round timestamps within tol minutes of a "round" half hour (i.e. 00 or 30
% minutes past the hour) to the nearest half hour. Rows with timestamps not
% within tol minutes of a "round" half hour are discarded.
%
% USAGE
%    [ ts, keep_idx ] = datenum_2_round30min( ts_in, tol, t0 )
%
% INPUTS
%    ts_in: vector of matlab datenums
%    tol: tolerance for rounding (minutes)
%    t0: arbitrary reference date -- must be earlier than min( ts_in )
%
% OUTPUTS
%    ts: vector of matlab datenums containing rounded timestamps
%    keep_idx: vector of indices of the input timestamps that were not discarded
%
% SEE ALSO
%    datenum
%
% author: Timothy W. Hilton, UNM, Jan 2012

%% convert matlab datenums to seconds since 00:00 of the day of the first
%% timestamp in the series 
secs_per_day = 24 * 60 * 60;
mins_per_day = 24 * 60;
ts = ( ts_in - t0 ) * secs_per_day;
ts = int32( ts );

%% express 30 minutes as seconds
secs_per_30min = int32( 30 * 60 );
%% convert tol to seconds
tol_secs = int32( tol * 60 );

%% figure out how far away is each timestamp from a "round" half hour
secs_from_prev_half_hour = mod( ts, secs_per_30min );

%% discard data more than tol minutes from a round half hour
keep_idx = ( secs_from_prev_half_hour <= tol_secs | ...
             secs_from_prev_half_hour >= ( secs_per_30min - tol_secs ) );
ts = ts( keep_idx );

%% convert timestamps from seconds past t0 to thirty-minute intervals past
%% t0; seconds now expressed as fractions 
ts = double( ts ) / double( secs_per_30min );

%% round timestamps to nearest round half hour
ts = int32( round( ts ) );

%% convert back to minutes past t0
ts = ts * 30;

%% convert ts from minutes past t0 back to matlab datenums
ts = ( double( ts ) / mins_per_day ) + t0;

