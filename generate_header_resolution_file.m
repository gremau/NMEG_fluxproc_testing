function ds = generate_header_resolution_file( varargin )
% generate_header_resolution_file() -- takes a list of TOA5 files and
% generates a header resolution file for the site
% ({sitecode}_Header_Resolutions.csv)
%
% FIXME - documentation needs fixing, doesn't really need to be a function
%
% This script is called from card_data_processor after asking for user
% input. Following the creation of a 30 minute TOA5 dataset (by
% combine_and_fill_TOA5_files.m), the combined and filled dataset is
% passed to this script. A header change log is read, and changed header
% columns are merged into one. Prior to merging, the script verifies that
% no data from either column will be overwritten.
%
% USAGE
%    ds = combine_and_fill_TOA5_files();
%    ds = combine_and_fill_TOA5_files( 'path\to\first\TOA5\file', ...
%                                      'path\to\second\TOA5\file', ... );
%
% INPUTS
%    either a series of strings containing full paths to the TOA5
%    files to be combined.  If called with no inputs the user is presented a
%    graphical file selection dialog (via uigetfile) which allows for multiple
%    files to be selected interactively.
%
% OUTPUTS
%    ds: Matlab dataset array; the combined and filled data
% 
% SEE ALSO
%    dataset, uigetfile, UNM_assign_soil_data_labels,
%    dataset_fill_timestamps, toa5_2_dataset
%
% Timothy W. Hilton, UNM, Dec 2011
% Modified by Gregory E. Maurer and Dan Krofcheck, UNM, Sept 2014

if nargin == 0
    % no files specified; prompt user to select files
    [filename, pathname, filterindex] = uigetfile( ...
        { 'TOA5*.dat','TOA5 files (TOA5*.dat)' }, ...
        'select files to merge', ...
        fullfile( getenv('FLUXROOT'), 'Flux_Tower_Data_by_Site') , ...
        'MultiSelect', 'on' );
    
    if ischar( filename )
        filename = { filename };
    end
else
    % the arguments are file names (with full paths)
    args = [ varargin{ : } ];
    [ pathname, filename, ext ] = cellfun( @fileparts, ...
                                           args, ...
                                           'UniformOutput', false );
    filename = strcat( filename, ext );
end

% Make sure files are sorted in chronological order and get dates
filename = sort(filename);
toa5_date_array = tstamps_from_TOB1_filenames(filename);

% Count number of files and initialize some arrays
nfiles = length( filename );
ds_array = cell( nfiles, 1 );

% Read each TOA5 file, convert to dataset, load datasets into an array
for i = 1:nfiles
    fprintf( 1, 'reading %s\n', filename{ i } );
    % Input checks
    if  iscell( pathname ) &&  ( numel( pathname ) == 1 )
            this_path = pathname{ 1 };
    elseif iscell( pathname )
        this_path = pathname{ i };
    else
        this_path = pathname;
    end
    
    ds_array{ i } = toa5_2_dataset( fullfile( this_path, filename{ i } ) );
    toks = regexp( filename{ i }, '_', 'split' );
    % deal with the two sites that have an '_' in the sitename
    if any( strcmp( toks{ 3 }, { 'girdle', 'GLand' }  ) )
        sitecode = UNM_sites.( [ toks{ 2 }, '_', toks{ 3 } ] );
        year = str2num( toks{ 4 } );
    else
        sitecode = UNM_sites.( toks{ 2 } );
        year = str2num( toks{ 3 } );
    end
    
    % JSav has different soil data labels
    if ( sitecode == UNM_sites.JSav ) && ( year == 2009 )
        ds_array{ i } = UNM_assign_soil_data_labels_JSav09( ds_array{ i } );
    else
        ds_array{ i } = UNM_assign_soil_data_labels( sitecode, ...
                                                     year, ...
                                                     ds_array{ i } );
    end
        
end

% TOA5 Header resolution config file path
res_path = fullfile(pwd, 'TOA5_Header_Resolutions');

% Using the sitecode object, open the apropriate header resolution
% and sensor swap files stored in \TOA5_Header_Resolutions\
change_fname = strcat(char(sitecode), '_Header_Changes.csv');
headerChangeFile = fullfile(res_path, change_fname);
swap_fname = strcat(char(sitecode), '_Sensor_Swaps.csv');
sensorSwapsFile = fullfile(res_path, swap_fname);

fopenmessage = strcat('---------- Opening ', change_fname,' ---------- \n');
fprintf(1, fopenmessage );
fopenmessage = strcat('---------- Opening ', swap_fname,' ---------- \n');
fprintf(1, fopenmessage );

% Read in the header changes file
changes = readtable(headerChangeFile);
[numHeaders, numPrev] = size(changes);
% Assign current and previous header columns
current = changes{:, 1};
previous = changes{:, 2:end};
% Read in the sensor swaps file
swaps = readtable(sensorSwapsFile);

% Initialize new resolution file
T = table(current);

for i = 1:numel( ds_array )
    % get the current TOA5 file header
    unresolved_TOA5_header = ds_array{i}.Properties.VarNames;
    % Get date, name, and header of toa5 file
    TOA5_date = toa5_date_array(i);
    filename_toks = regexp( filename{ i }, '\.', 'split' );
    TOA5_name = filename_toks{1};
    % Store header resolution in a new table
    new = repmat({''}, length(current), 1);
    toa5_changes = table(new, 'VariableNames', {TOA5_name});
    
    % for each line in the header change file, parse out the current
    % header name, then look for earlier header names in the TOA5
    % header and make them current
    fprintf(1, 'Resolving header changes for %s \n', filename{i});
    for j = 1:length(current)
        curr = current(j); % current header name
        % previous names for this header, removing blanks
        prev = previous(j, ~strcmp(previous(j, :), ''));
        prevloc = ismember(unresolved_TOA5_header, prev);
        currloc = ismember(unresolved_TOA5_header, curr);
        % Previous header found, current header absent
        if sum(prevloc) == 1 && sum(currloc) == 0
            %resolved_TOA5_header(prevloc) = curr;
            toa5_changes.(TOA5_name)(j) = unresolved_TOA5_header(prevloc);
        % Previous header absent, current header found
        elseif sum(prevloc) == 0 && sum(currloc) == 1
            toa5_changes.(TOA5_name)(j) = curr;
        % Neither header found
        elseif sum(prevloc) == 0 && sum(currloc) == 0
            toa5_changes.(TOA5_name)(j) = {'dne'};
        % Both headers found - mark as current, neither column removed
        elseif sum(prevloc) == 1 && sum(currloc) == 1
            toa5_changes.(TOA5_name)(j) = curr;
            fprintf(1, 'Both %s and %s exist in this file!\n',...
                char(curr), char(unresolved_TOA5_header(prevloc)));
        else
            disp('Invalid!!!!');
        end
    end
    
    % Incorporate sensor swaps
    for k = 1:height(swaps)
        first_toa5_date = datenum(swaps.first(k), 'YYYY_mm_DD');
        last_toa5_date = datenum(swaps.last(k), 'YYYY_mm_DD');
        swap1 = swaps.sensor1(k);
        swap2 = swaps.sensor2(k);
        % Swap values in new table if TOA5 date is in range found
        % in the sensor swap file
        if (floor(TOA5_date) >= first_toa5_date &&...
                floor(TOA5_date) <= last_toa5_date)
            loc1 = find(strcmp(toa5_changes.(TOA5_name), swap1));
            loc2 = find(strcmp(toa5_changes.(TOA5_name), swap2));
            toa5_changes.(TOA5_name)(loc1) = swap2;
            toa5_changes.(TOA5_name)(loc2) = swap1;
        end
    end
    
    % Change current headers in resolution table to "current"
    test = cellfun(@strcmp, toa5_changes.(TOA5_name), current);
    toa5_changes.(TOA5_name)(test) = {'current'};
    
    % Compare elements of most recent table column and new table for
    % changes. If they are NOT identical, append the new table.
    [T_rows, T_cols] = size(T);
    test = cellfun(@strcmp, T.(T_cols), toa5_changes.(1));
    if sum(test) < T_rows
        T = [T, toa5_changes];
    end
    clear toa5_changes
end

res_fname = strcat('TOA5_Header_Resolutions\', ...
    char(sitecode), '_Header_Resolutions.csv');
    
prompt = 'Overwrite the current header resolution file? Y/N [Y]: ';

str = input(prompt, 's');

if isempty(str)
    str = 'Y';
end
aff = {'Y','y','YES','yes','Yes'};
if  any(strcmp(str, aff))
    writetable(T, res_fname);
end

