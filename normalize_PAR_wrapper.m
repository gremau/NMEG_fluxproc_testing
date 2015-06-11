function [ Par_Avg ] = normalize_PAR_wrapper( sitecode, year_arg, ...
                                              decimal_day, Par_Avg, ...
                                              draw_plots )
% NORMALIZE_PAR_WRAPPER - normalize PAR to correct known calibration problems at
% some sites.
%
% This is a helper function for UNM_RemoveBadData.  It is not really intended to
% be called on its own.  Input and output arguments are defined in
% UNM_RemoveBadData.
%
% USAGE:
%       [ Par_Avg ] = normalize_PAR_wrapper( sitecode, year_arg, ...
%                                            decimal_day, Par_Avg, ...
%                                            draw_plots );
%
% author: Timothy W. Hilton, UNM, 2013

if ( sitecode == UNM_sites.SLand ) & ( year_arg == 2013 )
    % something caused the PAR observation on this card to be really low.
    idx = DOYidx( 46 ) : DOYidx( 75 );
    Par_Avg( idx ) = normalize_vector( Par_Avg( idx ), 0, 2050 );
end

if ismember( sitecode, [ UNM_sites.GLand, UNM_sites.SLand, ...
                        UNM_sites.JSav, UNM_sites.PJ, ...
                        UNM_sites.TX, UNM_sites.New_GLand, ...
                        UNM_sites.PJ_girdle, UNM_sites.PPine, ...
                        UNM_sites.MCon] ) & ...
                    year_arg < 2014
    par_max = 2350;
    if ( sitecode == UNM_sites.JSav ) & ( year_arg == 2008 )
        % there is a small but suspicious-looking step change at DOY164 -
        % normalize the first half of the year separately from the second
        doy164 = DOYidx( 164 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:doy164 ), ...
                                  decimal_day( 1:doy164 ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg2 = normalize_PAR( sitecode, ...
                                  Par_Avg( (doy164 + 1):end ), ...
                                  decimal_day( (doy164 + 1):end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg2 ];
        

    elseif ( sitecode == UNM_sites.PJ_girdle ) & ( year_arg == 2010 )
        % two step changes in this one
        doy138 = DOYidx( 138 );
        doy341 = DOYidx( 341 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:doy138 ), ...
                                  decimal_day( 1:doy138 ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg2 = normalize_PAR( sitecode, ...
                                  Par_Avg( doy138+1:doy341 ), ...
                                  decimal_day( doy138+1:doy341 ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg2; Par_Avg( doy341+1:end ) ];
    else
        Par_Avg = normalize_PAR( sitecode, ...
                                 Par_Avg, ...
                                 decimal_day, ...
                                 draw_plots, ...
                                 par_max );
    end
% Unfortunately we are no longer normalizing sensors once new ones are
% installed in 2014. Have to figure out the date of the change and
% normalize only to that point.
elseif year_arg==2014
    
    if sitecode == UNM_sites.GLand
        par_max = 2250;
        norm_end = DOYidx( 167.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
%     elseif sitecode == UNM_sites.NewGLand
%         par_max = 2250;
%         norm_end = DOYidx( 167.5 );
%         Par_Avg1 = normalize_PAR( sitecode, ...
%                                   Par_Avg( 1:norm_end ), ...
%                                   decimal_day( 1:norm_end ), ...
%                                   draw_plots, ...
%                                   par_max );
%         Par_Avg = [ Par_Avg1, Par_Avg( norm_end+1:end ) ]
    elseif sitecode == UNM_sites.SLand
        par_max = 2250;
        norm_end = DOYidx( 167.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
    elseif sitecode == UNM_sites.JSav
        par_max = 2270;
        norm_end = DOYidx( 132.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
%     elseif sitecode == UNM_sites.PJ_girdle
%         par_max = 2500;
%         norm_end = DOYidx( 365 );
%         Par_Avg1 = normalize_PAR( sitecode, ...
%                                   Par_Avg( 1:norm_end ), ...
%                                   decimal_day( 1:norm_end ), ...
%                                   draw_plots, ...
%                                   par_max );
%         Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
    elseif sitecode == UNM_sites.PJ
        par_max = 2300;
        norm_end = DOYidx( 168.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
    elseif sitecode == UNM_sites.PPine
        par_max = 2250;
        norm_end = DOYidx( 130.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
    elseif sitecode == UNM_sites.MCon
        par_max = 2370;
        norm_end = DOYidx( 162.5 );
        Par_Avg1 = normalize_PAR( sitecode, ...
                                  Par_Avg( 1:norm_end ), ...
                                  decimal_day( 1:norm_end ), ...
                                  draw_plots, ...
                                  par_max );
        Par_Avg = [ Par_Avg1; Par_Avg( norm_end+1:end ) ]
    end
    
else
            Par_Avg = Par_Avg;
end

% fix calibration problem at JSav 2009
% Moved this to UNM_RBD_apply_radiation_calibration_factors.m
% if ( sitecode == 3 ) & ( year_arg == 2009 )
%     Par_Avg( 1:1554 ) = Par_Avg( 1:1554 ) + 133;
% end
Par_Avg( Par_Avg < -50 ) = NaN;

% ------------------------------------------------------------

