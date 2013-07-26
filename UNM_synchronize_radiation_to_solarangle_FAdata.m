function [ data ] = ...
    UNM_synchronize_radiation_to_solarangle_FAdata( sitecode, ...
                                                  year, ...
                                                  data, ...
                                                  headertext, ...
                                                  timestamp )
% UNM_SYNCHRONIZE_RADIATION_TO_SOLARANGLE - adjust data so that observed sunrise
%   (as deterimined by Rg) corresponds to solar angle.

debug = true;
save_figs = false; 

% -----
% identify Rg and PAR columns from data
Rg_col = find( strcmp('Rad_short_Up_Avg', headertext) | ...
               strcmp('pyrr_incoming_Avg', headertext) ) - 1;

PAR_col = find( strcmp('par_correct_Avg', headertext )  | ...
                strcmp('par_Avg(1)', headertext ) | ...
                strcmp('par_Avg_1', headertext ) | ...
                strcmp('par_Avg', headertext ) | ...
                strcmp('par_up_Avg', headertext ) | ...        
                strcmp('par_face_up_Avg', headertext ) | ...
                strcmp('par_incoming_Avg', headertext ) | ...
                strcmp('par_lite_Avg', headertext ) ) - 1;

Rg = data( :, Rg_col );
PAR = data( :, PAR_col );
% -----

% calculate solar angle
sol_ang = get_solar_elevation( sitecode, timestamp );

% how many days are in this year?
n_days = 365 + isleapyear( year );

opt_off_Rg = repmat( NaN, 1, numel( 1:n_days ) );
opt_off_PAR = repmat( NaN, 1, numel( 1:n_days ) );
for doy = 1:n_days
    debug_flag = false;
    opt_off_Rg( doy ) = match_solarangle_radiation( Rg, ...
                                                    sol_ang, ...
                                                    timestamp, ...
                                                    doy, year, debug_flag );
    opt_off_PAR( doy ) = match_solarangle_radiation( PAR, ...
                                                     sol_ang, ...
                                                     timestamp, ...
                                                     doy, year, debug_flag );
end

if debug
    DTIME = timestamp - datenum( year, 1, 0 );
    [ hfig, ~ ] = plot_fingerprint( DTIME, ...
                                    data( :, Rg_col ), ...
                                    sprintf( '%s %d Rg before', ...
                                             char( sitecode ), year ), ...
                                    'clim', [ 0, 20 ], ...
                                    'fig_visible', true  );
    if save_figs
        figure_2_eps( hfig, ...
                      fullfile( getenv( 'PLOTS' ), 'Rad_Fingerprints', ...
                                sprintf( '%s_%d_Rg_before.eps', ...
                                         char( sitecode ), year ) ) );
    end
    hfig = figure( 'Visible', 'on' );
    plot( 1:n_days, opt_off_Rg, '.' );
    xlabel( 'DOY' );
    ylabel( 'Rg offset, hours' );
    if save_figs
        figure_2_eps( hfig, ...
                      fullfile( getenv( 'PLOTS' ), 'Rad_Fingerprints', ...
                                sprintf( '%s_%d_Rg_offset.eps', ...
                                         char( sitecode ), year ) ) );
    end
end

% use Rg-based offset where available, fill in with PAR
opt_off = opt_off_Rg;
idx = isnan( opt_off );
opt_off( idx ) = opt_off_PAR( idx );

% use run length encoding to gather consecutive days with the same radiation
% offset
idx_rle = rle( opt_off );
% the cumulative sums of the indices of the beginning of each change in
% radiation offset provides the DOY that each period of equal offset (i.e.,
% "chunk") begins
DOY_chunk_start = cumsum( idx_rle{ 2 } );
DOY_chunk_start = [ 1, DOY_chunk_start( 1:end-1 ) + 1 ];
chunk_ndays = idx_rle{ 2 };
chunk_offset = idx_rle{ 1 };
data_nrow = size( data, 1 );

%disp( [ DOY_chunk_start', chunk_ndays', chunk_offset' ] )

for i = 1:numel( chunk_offset )
    if not( isnan( chunk_offset( i ) ) )
        idx0 = DOYidx( DOY_chunk_start( i ) );
        idx1 = DOYidx( DOY_chunk_start( i ) + chunk_ndays( i ) );
        if ( ( idx0 > 0 ) & ( idx0 <= data_nrow ) & ...
             ( idx1 > 0 ) & ( idx1 <= data_nrow ) )
            data( idx0:idx1, : ) = shift_data( data( idx0:idx1, : ), ...
                                               chunk_offset( i ), ...
                                               'cols_to_shift', ...
                                               1:size( data, 2 ) );
        end
    end
end

if debug
    [ hfig, ~ ] = plot_fingerprint( DTIME, ...
                                    data( :, Rg_col ), ...
                                    sprintf( '%s %d Rg after', ...
                                             char( sitecode ), year ), ...
                                    'clim', [ 0, 20 ], ...
                                    'fig_visible', true );
    if save_figs
        figure_2_eps( hfig, ...
                      fullfile( getenv( 'PLOTS' ), 'Rad_Fingerprints', ...
                                sprintf( '%s_%d_Rg_after.eps', ...
                                         char( sitecode ), year ) ) );...
    end
end

