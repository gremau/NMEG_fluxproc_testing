function [ soilT, SWC ] = preprocess_PJ_soil_data( sitecode, year )
% PREPROCESS_PJ_SOIL_DATA - 
%   
    
% determine file path
    sitename = get_site_name( sitecode );
    fname = fullfile( getenv( 'FLUXROOT' ), ...
                      'Flux_Tower_Data_by_Site', ...
                      sitename, ...
                      'PJC-23x-Compiled-04-24-12.csv' );

    % parse data file to matlab dataset
    fmt = [ repmat( '%d', 1, 4 ), repmat( '%f', 1, 100 ) ];
    fmt = repmat( '%f', 1, 104 );
    soil_data = dataset( 'File', fname, 'Delimiter', ',', 'Format', fmt );
    
    % not sure what this column is, and its name is not a legal Matlab variable
    soil_data( :, 1 ) = [];
    
    % remove leading "x#_" and trailing __* from variable names
    disp( 'formatting variable names' );
    soil_data.Properties.VarNames = regexprep( soil_data.Properties.VarNames, ...
                                               '^x[0-9]*_', '' );
    soil_data.Properties.VarNames = regexprep( soil_data.Properties.VarNames, ...
                                               '__[A-Z]$', '' );    
    
    % build matlab datenums from year, day, hour, minute columns
    HH = floor( soil_data.Hour_Minute_RTM / 100 );
    MM = mod( soil_data.Hour_Minute_RTM, 100 );
    tstamps = datenum( double(soil_data.Year_RTM), 1, 0, HH, MM, 0 ) + ...
              ( soil_data.Day_RTM );
    soil_data.tstamps = tstamps;
    
    % pull out data for requested year
    soil_data = soil_data( soil_data.Year_RTM == year, : );

    % fill missing 30-minute timestamps with NaN
    disp( 'filling missing 30-minute timestamps with NaN' );
    thirty_minutes = 1 / 48;  % 30 mins expressed in units of days
    soil_data = dataset_fill_timestamps( soil_data, ...
                                         'tstamps', ...
                                         thirty_minutes, ...
                                         datenum( year, 1, 1 ), ...
                                         datenum( year, 12, 31, 23, 30, 0 ) );
    soil_data.tstamps = datenum( soil_data.tstamps );

    % replace -9999 and -99999 with NaN
    soil_data = replacedata( soil_data, ...
                             @(x) replace_badvals( x, [ -9999, -99999 ], 1e-6 ) );
    
    % pull out soil water content and soil temperature
    T_vars = cellfun( @(x) ~isempty( x ), ...
                      regexp( soil_data.Properties.VarNames, '^T_.*', 'once' ) );
    SWC_vars = cellfun( @(x) ~isempty( x ), ...
                        regexp( soil_data.Properties.VarNames, '^WC_.*', 'once' ) );
    
    soilT = soil_data( :, T_vars );
    SWC = soil_data(  :, SWC_vars );

    % separate cover type from index in variable names -- e.g. O1 becomes O_1
    soilT.Properties.VarNames = regexprep( soilT.Properties.VarNames, ...
                                           '([OJP])([123])', '$1_$2' );
    SWC.Properties.VarNames = regexprep( SWC.Properties.VarNames, ...
                                         '([OJP])([123])', '$1_$2' );
    
    % add timestamps to output datasets
    soilT.tstamps = soil_data.tstamps;
    SWC.tstamps = soil_data.tstamps;
    
    
