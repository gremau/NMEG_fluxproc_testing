function ds = parse_forgapfilling_file( site_code, year, varargin )
% PARSE_FORGAPFILLING_FILE - parse an ASCII for_gapfilling file to a matlab dataset
%   
% USAGE
%    ds = parse_forgapfilling_file( site_code, year, filled )
%
% INPUTS
%     site_code [ integer ]: code of site to be filled
%     year [ integer ]: year to be filled
%     filled [logical]: use T, RH, Rg filled forgapfilling file
%
% OUTPUTS
%     ds [ matlab dataset ]: the data contained in the file
%
% (c) Timothy W. Hilton, UNM, March 2012

% -----
% define optional inputs, with defaults and typechecking
% -----
args = inputParser;
args.addRequired( 'sitecode', @(x) ( isintval( x ) | isa( x, 'UNM_sites' ) ) );
args.addRequired( 'year', ...
               @(x) ( isintval( x ) & ( x >= 2006 ) & ( x <= this_year ) ) );
args.addParamValue( 'use_filled', true, @islogical );
args.addParamValue( 'fname', [], @ischar );

% parse optional inputs
args.parse( sitecode, year, varargin{ : } );

sitecode = args.Results.sitecode;
year = args.Results.year;
filled = args.Results.use_filled;
fname= args.Results.fname;

if filled
    fmt = '%s_flux_all_%d_for_gap_filling_filled.txt';
else
    fmt = '%s_flux_all_%d_for_gap_filling.txt';
end

if isempty( fname )
    fname = fullfile( get_site_directory( site_code ), ...
                      'processed_flux', ...
                      sprintf( fmt, get_site_name( site_code ), year ) );
    fprintf( 'parsing %s\n', fname );
end

infile = fopen( fname, 'r' );
headers = fgetl( infile );
col_headers = regexp( headers, '[ \t]+', 'split' );
n_cols = numel( col_headers );  %how many columns?
fclose( infile );

fmt = [ repmat( '%f ', 1, 14 ), '%f' ];
ds = dataset( 'File', fname, ...
              'format', fmt, ...
              'MultipleDelimsAsOne', true, ...
              'HeaderLines', 1 );

ds_names = ds.Properties.VarNames;
ds_dbl = double( ds );
ds_dbl = replace_badvals( ds_dbl, [ -9999.0 ], 1e-6 );
clear ds;

ds = dataset( { ds_dbl, col_headers{:} } );

% create a matlab datenum timestamp column
ts = datenum( ds.year, ds.month, ds.day, ds.hour, ds.minute, 0 );
ds.timestamp = ts;