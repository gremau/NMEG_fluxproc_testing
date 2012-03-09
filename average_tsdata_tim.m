t0 = now();

sitecode = 1;
rotation = 0;
lag = 1;
writefluxall = 1;
tstart = datenum( 2009, 1, 1 );
tend   = datenum( 2009, 12, 31 );

fnames = get_ts_file_names( get_site_name( sitecode ), tstart, tend );

ts = regexp( fnames, '(\d\d\d\d)_(\d\d)_(\d\d)_(\d\d)(\d\d)', ...
             'tokens', 'once' );
ts = cellfun( @str2num, vertcat( ts{ : } ) );
seconds = zeros( size( ts, 1 ), 1 );
ts = [ ts, seconds ];
dates = datenum( ts );
dates = arrayfun( @(x) {x}, dates )';

jun = cellfun( @( this_file, this_t ) UNM_data_processor( sitecode, ...
                                                  this_file, ...
                                                  this_t, ...
                                                  rotation, ...
                                                  lag, ...
                                                  writefluxall ), ...
               fnames, dates, ...
               'UniformOutput', false );

tstamps_30min = arrayfun( @(x) {x}, tstart : ( 1/48 ) : tend )';
ds_out = cellfun( @(this_data, this_t) ...
                  UNM_30min_TS_averager( sitecode, this_t, ...
                                         rotation, lag, ...
                                         double( this_data ) ), ...
                  jun, tstamps_30min, ...
                  'UniformOutput', false );

fprintf( 1, 'done (%d seconds)\n', int32( ( now() - t0 ) * 86400 ) );