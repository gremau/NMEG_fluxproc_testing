function ds_out =  UNM_Ameriflux_prepare_soil_met( sitecode, year, ...
                                                  data, ds_qc )
% UNM_AMERIFLUX_PREPARE_SOIL_MET - 
%   
% contains the section of UNM_Ameriflux_file_maker.m as of 15 Aug 2011 that
% gathers/calculates all the soil met properties.  By modularizing it here it
% should make it easier to streamline this going into the future.  I have gone
% through and replaced QC columns with ds_qc -- the dataset created by
% fluxallqc_2_dataset.m
%   
%
t0 = now();
fprintf( 1, 'Begin soil met properties...' );

%% create a column of -9999s to place in the dataset where a site does not
%% record a particular variable
dummy = repmat( -9999, size( data, 1 ), 1 );

% find any soil heat flux columns within QC data
shf_vars = regexp_ds_vars( ds_qc, 'soil_heat_flux.*' );
n_shf_vars = size( shf_vars, 2 );  % how many SHF columns are there?    
%% data is now a dataset -- convert it to a matrix of doubles for
%% back-compatibilty
data_timestamp = data.timestamp;
data = double( data( :, 2:end ) );

% -----
% get soil water content and soil temperature data
% -----

switch sitecode
  case { 1, 2, 3, 6, 7, 8, 9, 11 } 
    % all sites except PJ and PJ_girdle store their soil data in the
    % FluxAll file

    % pull soil water content (SWC) and soil temperature (T) measurements out
    % of the FluxAll data.

    % get the soil water content and soil T columns and labels
    [ cs616_SWC_cols, ...
      echo_SWC_cols, ...           
      Tsoil_cols ] = UNM_assign_soil_data_labels( sitecode, year );

    Tsoil = soildata_2_dataset( data, ...
                                Tsoil_cols.columns, ...
                                Tsoil_cols.labels );

    cs616 = soildata_2_dataset( data, ...
                                cs616_SWC_cols.columns, ...
                                cs616_SWC_cols.labels );
    [ cs616, cs616_Tc ] = cs616_period2vwc( cs616, Tsoil );

    if ~isempty( echo_SWC_cols.columns )
        echo = soildata_2_dataset( data, echo_SWC_cols.columns, ...
                                   echo_SWC_cols.labels );
    end

  case { 4, 10 }
    % PJ and PJ_girdle store their soil data outside of FluxAll.
    % These data are already converted to VWC.

    [ Tsoil, cs616 ] = preprocess_PJ_soil_data( sitecode, year );
    %[ cs616, cs616_Tc ] = cs616_period2vwc( cs616,  Tsoil );
    cs616_Tc = cs616;
end

[ Tsoil_hilo_removed, ...
  Tsoil_hilo_replaced, ...
  Tsoil_runmean ] = UNM_soil_data_smoother( Tsoil );
[ cs616_hilo_removed, ...
  cs616_hilo_replaced, ...
  cs616_runmean ] = UNM_soil_data_smoother( cs616 );
[ cs616_Tc_hilo_removed, ...
  cs616_Tc_hilo_replaced, ...
  cs616_Tc_runmean ] = UNM_soil_data_smoother( cs616_Tc );
keyboard

switch sitecode
  case 1

    % parameter values for soil heat flux
    bulk = 1398; 
    scap = 837; 
    wcap = 4.19e6; 
    depth = 0.05;
    
    
    
    [ vwc, ...
      vwc_Tc, ...
      mean_vwc ...
      mean_vwc_Tc ] = process_site_year_SWC( swc_raw, ...
                                             T_soil, ...
                                             cover_indices )
end %switch sitecode
%%======================================================================
%% assign all the variables created above to a dataset to be returned to
%% the caller
%%======================================================================

var_names = { 'Tsoil_1', 'Tsoil_2', 'Tsoil_3', ...
              'SWC_1', 'SWC_2', 'SWC_3', ...
              'SWC_21', 'SWC_22', 'SWC_23', ...
              'par_down_Avg', ...
              'bulk', 'scap', 'wcap', 'depth' };

%% initialize the datset to NaNs
ds_vals = repmat( NaN, size( data, 1 ), numel( var_names ) );
ds_out = dataset( { ds_vals, var_names{:} } );

%% assign values to the dataset
%% soil temperature
ds_out.Tsoil_1 = Tsoil_1;
ds_out.Tsoil_2 = Tsoil_2;
ds_out.Tsoil_3 = Tsoil_3;

%% soil water content
ds_out.SWC_1 = SWC_1;
ds_out.SWC_2 = SWC_2;
ds_out.SWC_3 = SWC_3;

%% the following variables only exist at some sites, so check before
%% assigning them
vars = who();
if exist( 'SWC_21' ) == 1
    ds_out.SWC_21 = SWC_21;
end
if exist( 'SWC_22' ) == 1
    ds_out.out.SWC_22 = SWC_22;
end
if exist( 'SWC_23' ) == 1
    ds_outout.SWC_23 = SWC_23;
end

save hf_restart.mat

ds_out = [ ds_out, ds_shf ];

%% add timestamp

ds_out.timestamp = data_timestamp;

%% calculate execution time and write status message
t_tot = ( now() - t0 ) * 24 * 60 * 60;
fprintf( 1, ' Done (%.0f secs)\n', t_tot );

%----------------------------------------------------------------------    

function [ ds ] = soildata_2_dataset(fluxall, columns, labels)

% SOILDATA_2_DATASET - pulls soil data from parsed Fluxall data into matlab
% dataset.  Helper function for UNM_Ameriflux_prepare_soil_met.
%   

% '.' is not a legal character for matlab variable names -- replace '.' in depth
% labels (now in format e.g. 12.5) with p (e.g. 12p5)
varnames = regexprep( labels, '([0-9])\.([0-9])', '$1p$2' );

ds = dataset( { fluxall( : ,columns ), varnames{ : } } );

%----------------------------------------------------------------------    

function [ vwc, ...
           vwc_Tc, ...
           mean_vwc ...
           mean_vwc_Tc ] = process_site_year_SWC( swc_raw, ...
                                                  T_soil, ...
                                                  cover_indices )
% PROCESS_SITE_YEAR_SWC - process SWC from raw period measurements (in
% microseconds) reported by CS616 to smoothed volumetric water content.
% Returns both temperature-corrected and non-temperature-corrected values as
% well as mean values by cover type.  Helper function for
% UNM_Ameriflux_prepare_soil_met.

% convert cs616 period to volumetric water content
[ vwc, vwc_Tc ] = cs616_period2vwc( swc_raw, T_soil_all );
% smooth non-T-corrected vwc
[ vwc_bad_removed, ...
  vwc_bad_replaced, ...
  vwc_run_mean ] = UNM_soil_data_smoother( vwc );
% smooth T-corrected vwc
[ vwc_bad_removed_Tc, ...
  vwc_bad_replaced_Tc, ...
  vwc_run_mean_Tc ] = UNM_soil_data_smoother( vwc_Tc );

mean_vwc = cell( 1, numel( cover_indices ) );
mean_vwc_Tc = cell( 1, numel( cover_indices ) );

for i = 1:numel( cover_indices )
    % calculate the mean from each cover type along each row
    % ( each row is a timestamp )
    mean_vwc{ i } = nanmean( vwc( :, cover_indices{ i } ), 2 ); 
    mean_vwc_Tc{ i } = nanmean( vwc_Tc( :, cover_indices{ i } ), 2 );
end


