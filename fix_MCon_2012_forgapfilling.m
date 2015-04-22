function success = fix_MCon_2012_forgapfilling()
% FIX_MCon_2012_FORGAPFILLING - fix some problems in MCon NEE for 2012.
%
% The gapfiller/partitioner places two large spikes in NEE in late July/early
% August 2012.  This function scales the NEE spikes down to more reasonable
% peaks and writes a new for_gapfilling file.  Returns 0 on success.
%
% USAGE
%    success = fix_MCon_2012_forgapfilling()
%
% author: Timothy W. Hilton, UNM, Oct 2012

error('Should this script be running????');

fgf = parse_forgapfilling_file( UNM_sites.MCon, 2012, true );
aflx_gf = parse_ameriflux_file( fullfile( getenv( 'FLUXROOT' ), ...
                                          'FluxOut', ...
                                          'US-Vcm_2012_gapfilled.txt' ) );

spike_idx = find( aflx_gf.FC_flag & ...
                  ( aflx_gf.DTIME >= 200 ) & ...
                  ( aflx_gf.DTIME <= 225 ) &...
                  ( aflx_gf.FC > 0 ) );

figure();
plot( aflx_gf.DTIME, aflx_gf.FC, 'ok' );
hold on

x = aflx_gf.FC( spike_idx );
x_adj = x * ( 12 / max( x ) );
fgf.NEE( spike_idx ) = x_adj;

plot( aflx_gf.DTIME( 1:size( fgf, 1 ) ), fgf.NEE, '.' );

fgf.timestamp = [];

fname = fullfile( get_site_directory( UNM_sites.MCon ),...
                  'processed_flux', ...
                  'MCon_flux_all_2012_for_gap_filling_filled_despiked.txt' );
export_dataset_tim( fname, fgf, 'replace_nans', true); 
fprintf( 'wrote %s\n', fname );

success = 0;