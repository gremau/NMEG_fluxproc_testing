function plot_monthly_aggregated_daily_cycle( mm, varargin )
% PLOT_MONTHLY_AGGREGATED_DAILY_CYCLE - plot monthly aggregated daily cycle
% data.

% Produces a 3-row, 4-column panel figure, each panel showing the daily cycle
% for a month.
%   
% INPUTS
%    mm: Nx4 dataset array with variables year, month, hour, and val, with val the
%        aggregated value to be plotted.  mm is usually the output of
%        monthly_aggregated_daily_cycle.
%
% PARAMETER-VALUE PAIRS
%    main_title: string, optional; title to appear above entire plot.  If not
%        specified the plot title is blank.
%    figure_file_name: string, optional; specifies full path for plot to be
%        saved to an encapsulated postscript (eps) file.  If not specified plot
%        is not saved.
%    ref_vals: N-element vector; optional reference values to plot alongside
%       the monthly cycle.  If specified, they are plotted as a black line.
%       Useful for plotting calculated solar angle or top-of-atmosphere
%       potential radiation alongside observed radiation.
%
% OUTPUTS
%    none
%
% SEE ALSO
%    dataset, monthly_aggregated_daily_cycle
%
% author: Timothy W. Hilton, UNM, May 2013

% define some constants
OBS_PER_DAY = 48;
HOURS_PER_DAY = 24;
MONTHS_PER_YEAR = 12;

args = inputParser;
args.addRequired( 'mm', @(x) isa( x, 'dataset' ) );
args.addParamValue( 'main_title', '', @ischar );
args.addParamValue( 'figure_file_name', '', @ischar );
args.addParamValue( 'ref_vals', [], @isnumeric );
args.parse( mm, varargin{ : } );
mm = args.Results.mm;

%need a year, day to feed datenum to convert numeric months (01-12) to strings
%("January" to "December")
dummy_year = 2010; 
dummy_day = 1; 

% user Color Brewer's Dark2 palette
pal = cbrewer( 'qual', 'Dark2', 8 );

h_fig = figure( 'NumberTitle', 'Off', ...
               'Units', 'Normalized', ...
               'Position', [ 0, 0.1, 0.8, 0.6 ], ...
                'DefaultAxesColorOrder', pal );

y_max = nanmax( mm.val );
vals = reshape( mm.val, OBS_PER_DAY, MONTHS_PER_YEAR, [] );

if not( isempty( args.Results.ref_vals ) )
    ref_vals = reshape( args.Results.ref_vals, ...
                        OBS_PER_DAY, ...
                        MONTHS_PER_YEAR, ...
                        [] );
end

for this_month = 1:12
    h_ax = subplot( 3, 4, this_month );
    this_data = squeeze( vals( :, this_month, : ) );
    h_lines = plot( this_data, '-o', 'MarkerSize', 8 );
    
   if not( isempty( args.Results.ref_vals ) )
       % if reference values were provided, add them to the plot as a black line
       hold on;
       this_ref_vals = squeeze( ref_vals( :, this_month, : ) );
       this_ref_vals( this_ref_vals < 0.0 ) = 0.0;
       maxval = nanmax( reshape( this_data, 1, [] ) );
       this_ref_vals = normalize_vector( this_ref_vals, 0, maxval);
       h_ref = plot( this_ref_vals, '*k' );
       hold off
   end 
    
    % set axis limits
    ylim( [ 0, y_max ] );
    xlim( [ 1, OBS_PER_DAY ] );
    % change horizontal axis tick labels from observations (1 to 48) to hours (1 to
    % 24)
    xlabs = get( gca, 'XTickLabel' );
    xlabs = num2str( str2num( xlabs ) / 2 );
    set( gca, 'XTickLabel', xlabs );
    % title, axis labels
    title( datestr( datenum( dummy_year, this_month, dummy_day ), 'mmmm' ) );
    if this_month > 8
        xlabel( 'hour of day' );
    end
    if ismember( this_month, [ 1, 5, 9 ] )
        ylabel( 'Rg, W m^{-2}' );
    end    
end

% legend and main title
leg_text = arrayfun( @num2str, ...
                     unique( mm.year ), ...
                     'UniformOutput', false );
if not( isempty( args.Results.ref_vals ) )
    leg_text = [ leg_text; 'reference' ];
    h_lines = [ h_lines; h_ref ];
end
h_leg = legend( h_lines, leg_text );
set( h_leg, 'Units', 'Normalized', 'Position', [ 0.9, 0.4, 0.1, 0.2 ] );

if not( isempty( args.Results.main_title ) )
    suptitle( args.Results.main_title );
end

if not( isempty( args.Results.figure_file_name ) )
    file_path = fullfile( getenv( 'PLOTS' ), ...
                          args.Results.figure_file_name );
    figure_2_eps( h_fig, file_path );
    fprintf( 'saved %s\n', file_path );
end