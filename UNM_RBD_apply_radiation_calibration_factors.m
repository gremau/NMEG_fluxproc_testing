function [sw_incoming, sw_outgoing, ...
          lw_incoming, lw_outgoing, Par_Avg ] = ...
    UNM_RBD_apply_radiation_calibration_factors( sitecode, year_arg, ...
                                                 decimal_day, ...
                                                 sw_incoming, sw_outgoing, ...
                                                 lw_incoming, lw_outgoing, ...
                                                 Par_Avg, NR_tot, ...
                                                 wnd_spd, CNR1TK )
% UNM_RBD_APPLY_RADIATION_CALIBRATION_FACTORS - correct for radiation
% calibration factors that were incorrectly specified in datalogger code at
% various sites and time periods.
%
% Some site-years or portions thereof contain incorrect calibration factors in
% their datalogger code.  These corrections fix those problems.  
%
% This is a helper function for UNM_RemoveBadData.  It is not intended to be
% called on its own.  Input and output arguments are defined in
% UNM_RemoveBadData.
%   
% [sw_incoming, sw_outgoing, ...
%  lw_incoming, lw_outgoing, Par_Avg ] = ...
%     UNM_RBD_apply_radiation_calibration_factors( sitecode, year_arg, ...
%                                   decimal_day, ...
%                                   sw_incoming, sw_outgoing, ...
%                                   lw_incoming, lw_outgoing, Par_Avg, ...
%                                   NR_tot, wnd_spd, CNR1TK )
%
% INPUTS/OUTPUTS
%     see UNM_RemoveBadData and UNM_RemoveBadData_pre2012
% 
% SEE ALSO:
%     UNM_RemoveBadData, UNM_RemoveBadData_pre2012
%
% author: Timothy W. Hilton, UNM, 2013



%%%%%%%%%%%%%%%%% grassland
switch sitecode
  case UNM_sites.GLand
    if year_arg == 2007
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % >> for first couple of weeks the program had one incorrect
        % conversion factor (163.666)
        sw_incoming(find(decimal_day > 156.71 & decimal_day < 162.52)) = ...
         sw_incoming(find(decimal_day > 156.71 & decimal_day < 162.52)) ...
         ./163.666.*(1000./8.49);
        sw_outgoing(find(decimal_day > 156.71 & decimal_day < 162.52)) = ...
         sw_outgoing(find(decimal_day > 156.71 & decimal_day < 162.52)) ...
         ./163.666.*(1000./8.49);
        lw_incoming(find(decimal_day > 156.71 & decimal_day < 162.52)) = ...
         lw_incoming(find(decimal_day > 156.71 & decimal_day < 162.52)) ...
         ./163.666.*(1000./8.49);
        lw_outgoing(find(decimal_day > 156.71 & decimal_day < 162.52)) = ...
         lw_outgoing(find(decimal_day > 156.71 & decimal_day < 162.52)) ...
         ./163.666.*(1000./8.49);
        % then afterward it had a different one (136.99)
        sw_incoming(find(decimal_day >= 162.52)) = ...
         sw_incoming(find(decimal_day >= 162.52))...
         ./136.99.*(1000./8.49);
        sw_outgoing(find(decimal_day >= 162.52)) = ...
         sw_outgoing(find(decimal_day >= 162.52))...
         ./136.99.*(1000./8.49);
        lw_incoming(find(decimal_day >= 162.52)) = ...
         lw_incoming(find(decimal_day >= 162.52))...
         ./136.99.*(1000./8.49);
        lw_outgoing(find(decimal_day >= 162.52)) = ...
         lw_outgoing(find(decimal_day >= 162.52))...
         ./136.99.*(1000./8.49);
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;

        Par_Avg(find(decimal_day > 162.14)) = ...
            Par_Avg(find(decimal_day > 162.14)).*1000./(5.7*0.604);
        % estimate par from sw_incoming
        Par_Avg(find(decimal_day < 162.15)) = ...
            sw_incoming(find(decimal_day < 162.15)).*2.025 + 4.715;
        
    elseif year_arg >= 2008 & year_arg <= 2013
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % and adjust for program error
        sw_incoming = sw_incoming./136.99.*(1000./8.49);
        sw_outgoing = sw_outgoing./136.99.*(1000./8.49);
        lw_incoming = lw_incoming./136.99.*(1000./8.49);
        lw_outgoing = lw_outgoing./136.99.*(1000./8.49);
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration correction for the li190
        Par_Avg = Par_Avg.*1000./(5.7*0.604);
        
    elseif year_arg >= 2014
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % and adjust for program error
        % Fixed in dat logger programs on 01/17/2014
        sw_incoming(find(decimal_day < 17.5)) = ...
         sw_incoming(find(decimal_day < 17.5))./136.99.*(1000./8.49);
        sw_outgoing(find(decimal_day < 17.5)) = ...
         sw_outgoing(find(decimal_day < 17.5))./136.99.*(1000./8.49);
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5))./136.99.*(1000./8.49);
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5))./136.99.*(1000./8.49);
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        % calibration correction for the li190
        Par_Avg(find(decimal_day < 17.5)) = ...
            Par_Avg(find(decimal_day < 17.5)).*1000./(5.7*0.604);
    end
    
    %%%%%%%%%%%%%%%%% shrubland 
  case UNM_sites.SLand
    if year_arg == 2007
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % for first couple of weeks the program had one incorrect
        % conversion factor (163.666)
        sw_incoming(find(decimal_day >= 150.75 & decimal_day < 162.44)) = ...
         sw_incoming(find(decimal_day >= 150.75 & decimal_day < 162.44)) ...
         ./163.666.*(1000./12.34);
        sw_outgoing(find(decimal_day >= 150.75 & decimal_day < 162.44)) = ...
         sw_outgoing(find(decimal_day >= 150.75 & decimal_day < 162.44)) ...
         ./163.666.*(1000./12.34);
        lw_incoming(find(decimal_day >= 150.75 & decimal_day < 162.44)) = ...
         lw_incoming(find(decimal_day >= 150.75 & decimal_day < 162.44)) ...
         ./163.666.*(1000./12.34);
        lw_outgoing(find(decimal_day >= 150.75 & decimal_day < 162.44)) = ...
         lw_outgoing(find(decimal_day >= 150.75 & decimal_day < 162.44)) ...
         ./163.666.*(1000./12.34);
        % then afterward it had a different one (136.99)
        % adjust for program error and convert into W per m^2
        sw_incoming(find(decimal_day >= 162.44)) = ...
         sw_incoming(find(decimal_day >= 162.44))./136.99.*(1000./12.34);
        sw_outgoing(find(decimal_day >= 162.44)) = ...
         sw_outgoing(find(decimal_day >= 162.44))./136.99.*(1000./12.34);
        lw_incoming(find(decimal_day >= 162.44)) = ...
         lw_incoming(find(decimal_day >= 162.44))./136.99.*(1000./12.34);
        lw_outgoing(find(decimal_day >= 162.44)) = ...
         lw_outgoing(find(decimal_day >= 162.44))./136.99.*(1000./12.34);
        % temperature correction for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        
        % calibration correction for the li190
        % estimate par from sw_incoming
        Par_Avg(find(decimal_day <= 150.729)) = ...
         sw_incoming(find(decimal_day <= 150.729)).*2.0292 + 3.6744;
        Par_Avg(find(decimal_day > 150.729)) = ...
         Par_Avg(find(decimal_day > 150.729)).*1000./(6.94*0.604);
        
    elseif year_arg >= 2008 & year_arg <= 2013
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % adjust for program error and convert into W per m^2
        sw_incoming = sw_incoming./136.99.*(1000./12.34);
        sw_outgoing = sw_outgoing./136.99.*(1000./12.34);
        lw_incoming = lw_incoming./136.99.*(1000./12.34);
        lw_outgoing = lw_outgoing./136.99.*(1000./12.34);
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration correction for the li190
        Par_Avg = Par_Avg.*1000./(6.94*0.604);

    elseif year_arg >= 2014
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % adjust for program error and convert into W per m^2
        % Fixed in dat logger programs on 01/17/2014
        sw_incoming(find(decimal_day < 17.5)) = ...
         sw_incoming(find(decimal_day < 17.5))./136.99.*(1000./12.34);
        sw_outgoing(find(decimal_day < 17.5)) = ...
         sw_outgoing(find(decimal_day < 17.5))./136.99.*(1000./12.34);
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5))./136.99.*(1000./12.34);
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5))./136.99.*(1000./12.34);
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        % calibration correction for the li190
        Par_Avg(find(decimal_day < 17.5)) = ...
         Par_Avg(find(decimal_day < 17.5)).*1000./(6.94*0.604);
    end

    %%%%%%%%%%%%%%%%% juniper savanna
  case UNM_sites.JSav
    if year_arg == 2007
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % convert into W per m^2
        sw_incoming = sw_incoming./163.666.*(1000./6.9);
        sw_outgoing = sw_outgoing./163.666.*(1000./6.9);
        lw_incoming = lw_incoming./163.666.*(1000./6.9);
        lw_outgoing = lw_outgoing./163.666.*(1000./6.9);
        % temperature correction for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration for par-lite
        Par_Avg = Par_Avg.*1000./5.48;
    elseif year_arg >= 2008 & year_arg <= 2013
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % convert into W per m^2
        sw_incoming = sw_incoming./163.666.*(1000./6.9);
        sw_outgoing = sw_outgoing./163.666.*(1000./6.9);
        lw_incoming = lw_incoming./163.666.*(1000./6.9);
        lw_outgoing = lw_outgoing./163.666.*(1000./6.9); 
        % temperature correction for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration for par-lite
        Par_Avg = Par_Avg.*1000./5.48;

    elseif year_arg >= 2014
        % calibration and unit conversion into W per m^2 for CNR1 variables
        % convert into W per m^2
        % Fixed in dat logger programs on 01/17/2014
        sw_incoming(find(decimal_day < 17.5)) = ...
         sw_incoming(find(decimal_day < 17.5))./163.666.*(1000./6.9);
        sw_outgoing(find(decimal_day < 17.5)) = ...
         sw_outgoing(find(decimal_day < 17.5))./163.666.*(1000./6.9);
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5))./163.666.*(1000./6.9);
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5))./163.666.*(1000./6.9);
        % temperature correction for long-wave
        lw_incoming(find(decimal_day < 17.5)) = ...
         lw_incoming(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        lw_outgoing(find(decimal_day < 17.5)) = ...
         lw_outgoing(find(decimal_day < 17.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day < 17.5))).^4;
        % calibration for par-lite
        Par_Avg(find(decimal_day < 17.5)) = ...
         Par_Avg(find(decimal_day < 17.5)).*1000./5.48;
    end
    
    % all cnr1 variables for jsav need to be (value/163.666)*144.928???

    %%%%%%%%%%%%%%%%% pinon juniper
  case UNM_sites.PJ
    if year_arg == 2007
        % this is the wind correction factor for the Q*7
        NR_tot(find(NR_tot < 0)) = NR_tot(find(NR_tot < 0)) ...
         .*10.74.*((0.00174.*wnd_spd(find(NR_tot < 0))) + 0.99755);
        NR_tot(find(NR_tot > 0)) = NR_tot(find(NR_tot > 0)) ...
         .*8.65.*(1 + (0.066.*0.2.*wnd_spd(find(NR_tot > 0))) ...
         ./(0.066 + (0.2.*wnd_spd(find(NR_tot > 0)))));
        % now correct pars; see notes on PJ methodology for this relationship
        Par_Avg = NR_tot.*2.7828 + 170.93;
        sw_incoming = Par_Avg.*0.4577 - 1.8691;

    elseif year_arg == 2008
        % this is the wind correction factor for the Q*7
        NR_tot(find(decimal_day < 172 & NR_tot < 0)) = ...
         NR_tot(find(decimal_day < 172 & NR_tot < 0)).*10.74 ...
         .*((0.00174.*wnd_spd(find(decimal_day < 172 & NR_tot < 0))) + 0.99755);
        NR_tot(find(decimal_day < 172 & NR_tot > 0)) = ...
         NR_tot(find(decimal_day < 172 & NR_tot > 0)).*8.65 ...
         .*(1 + (0.066.*0.2.*wnd_spd(find(decimal_day < 172 & NR_tot > 0))) ...
         ./(0.066 + (0.2.*wnd_spd(find(decimal_day < 172 & NR_tot > 0)))));
        % now correct pars
        Par_Avg(find(decimal_day < 42.6)) = ...
         NR_tot(find(decimal_day < 42.6)).*2.7828 + 170.93;
        % calibration for par-lite installed on 2/11/08
        Par_Avg(find(decimal_day > 42.6)) = ...
         Par_Avg(find(decimal_day > 42.6)).*1000./5.51;
        sw_incoming(find(decimal_day < 172)) = ...
         Par_Avg(find(decimal_day < 172)).*0.4577 - 1.8691;
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day > 171.5)) = ...
         lw_incoming(find(decimal_day > 171.5)) + 0.0000000567 ...
         .*(CNR1TK(find(decimal_day > 171.5))).^4;
        lw_outgoing(find(decimal_day > 171.5)) = ...
         lw_outgoing(find(decimal_day > 171.5)) + 0.0000000567 ...
         .*(CNR1TK(find(decimal_day > 171.5))).^4;
        hour_0700 =  7.0 / 24.0;
        hour_1730 = 17.5 / 24.0;
        frac_day = decimal_day - floor( decimal_day );
        early_year_is_night = ( decimal_day < 42.6 ) & ...
            ( ( frac_day < hour_0700 ) | ( frac_day > hour_1730 ) );
        sw_incoming( early_year_is_night & ( abs( sw_incoming ) > 5 ) ) = NaN;
        sw_outgoing( early_year_is_night & ( abs( sw_incoming ) > 5 ) ) = NaN;
        Par_Avg( early_year_is_night & ( abs( sw_incoming ) > 5 ) ) = NaN;
        
    elseif year_arg >= 2009 & year_arg <= 2013
        % calibration for par-lite installed on 2/11/08
        Par_Avg = Par_Avg.*1000./5.51;
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + ( 0.0000000567 .* ( CNR1TK .^ 4 ) );
        lw_outgoing = lw_outgoing + ( 0.0000000567 .* ( CNR1TK .^ 4 ) );

    elseif year_arg >= 2014
        % calibration for par-lite installed on 2/11/08
        % fixed on 01/10/2014
        Par_Avg(find(decimal_day < 10.5)) = ...
         Par_Avg(find(decimal_day < 10.5)).*1000./5.51;
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day < 10.5)) = ...
         lw_incoming(find(decimal_day < 10.5)) + ...
         ( 0.0000000567 .* ( CNR1TK(find(decimal_day < 10.5)) .^ 4 ) );
        lw_outgoing(find(decimal_day < 10.5)) = ...
         lw_outgoing(find(decimal_day < 10.5)) + ...
         ( 0.0000000567 .* ( CNR1TK(find(decimal_day < 10.5)) .^ 4 ) );
    end

    %%%%%%%%%%%%%%%%% ponderosa pine
  case UNM_sites.PPine
    if year_arg == 2007
        % radiation values apparently already calibrated and unit-converted
        % in progarm for valles sites
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % Apply correct calibration value 7.37, SA190 manual section 3-1
        Par_Avg=Par_Avg.*225;
        % Apply correction to bring in line with Par-lite from mid 2008
        Par_Avg=Par_Avg+(0.2210.*sw_incoming);
        
    elseif year_arg == 2008
        % radiation values apparently already calibrated and unit-converted
        % in progarm for valles sites
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration for Licor sesor
        % Apply correct calibration value 7.37, SA190 manual section 3-1
        Par_Avg(1:10063)=Par_Avg(1:10063).*225;
        Par_Avg(1:10063)=Par_Avg(1:10063)+(0.2210.*sw_incoming(1:10063));
        % calibration for par-lite sensor
        Par_Avg(10064:end) = Par_Avg(10064:end).*1000./5.25;
        
    % Per Marcy, only correct until 11/13/2012, then do nothing
    % (RJL 01/15/2014)
    elseif year_arg >= 2009 & year_arg <= 2012
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day >= 0.0 & decimal_day <= 318.5)) = ...
         lw_incoming(find(decimal_day >= 0 & decimal_day <= 318.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day >= 0.0 & decimal_day <= 318.5))).^4;
        lw_outgoing(find(decimal_day >= 0.0 & decimal_day <= 318.5)) = ...
         lw_outgoing(find(decimal_day >= 0 & decimal_day <= 318.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day >= 0.0 & decimal_day <= 318.5))).^4;
        % calibration for par-lite sensor
        Par_Avg(find(decimal_day >= 0.0 & decimal_day <= 318.5)) = ...
         Par_Avg(find(decimal_day >= 0.0 & decimal_day <= 318.5)).*1000./5.25;

    elseif year_arg == 2013
    %RJL added on 01/15/2014 per Marcy because calibration factor was
    %incorrect from 05/02/2013 through 01/15/2014
        sw_incoming(find(decimal_day > 122.5 & decimal_day < 366.0)) = ...
         sw_incoming(find(decimal_day > 122.5 & decimal_day < 366.0)) ...
         .*(142.857/163.666);
        sw_outgoing(find(decimal_day > 122.5 & decimal_day < 366.0)) = ...
         sw_outgoing(find(decimal_day > 122.5 & decimal_day < 366.0)) ...
         .*(142.857/163.666);
        lw_incoming(find(decimal_day > 122.5 & decimal_day < 366.0)) = ...
         lw_incoming(find(decimal_day > 122.5 & decimal_day < 366.0)) ...
         .*(142.857/163.666);
        lw_outgoing(find(decimal_day > 122.5 & decimal_day < 366.0)) = ...
         lw_outgoing(find(decimal_day > 122.5 & decimal_day < 366.0)) ...
         .*(142.857/163.666);
        % calibration for par-lite sensor???????????????????????????
        % Par_Avg(find(decimal_day > 122.5 & decimal_day < 366.0)) = ...
        %  Par_Avg(find(decimal_day > 122.5 & decimal_day < 366.0)).*1000./5.25
        Par_Avg = Par_Avg;

    elseif year_arg == 2014
    %RJL added on 01/15/2014 per Marcy because calibration factor was
    %incorrect from 05/02/2013 through 01/15/2014
        sw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         sw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) ...
         .*(142.857/163.666);
        sw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         sw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) ...
         .*(142.857/163.666);
        lw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         lw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) ...
         .*(142.857/163.666);
        lw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         lw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) ...
         .*(142.857/163.666);
        % radiation values apparently already calibrated and unit-converted
        % in progarm for valles sites
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         lw_incoming(find(decimal_day > 0.0 & decimal_day < 15.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 15.5))).^4;
        lw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
         lw_outgoing(find(decimal_day > 0.0 & decimal_day < 15.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 15.5))).^4;
        % calibration for par-lite sensor
        % calibration for par-lite sensor???????????????????????????
        % Par_Avg(find(decimal_day > 0.0 & decimal_day < 15.5)) = ...
        %  Par_Avg(find(decimal_day > 0.0 & decimal_day < 15.5)).*1000./5.25
        Par_Avg = Par_Avg;
        
    end
    
    %%%%%%%%%%%%%%%%% mixed conifer
  case UNM_sites.MCon
    if year_arg == 2006 || year_arg == 2007
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        
    elseif year_arg >= 2008 & year_arg <= 2013
        % radiation values apparently already calibrated and unit-converted
        % in progarm for valles sites
        % temperature correction just for long-wave
        lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
        lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
        % calibration for par-lite sensor
        Par_Avg = Par_Avg.*1000./5.65;
        
    elseif year_arg == 2014
    % RJL added on 01/15/2014 per Marcy, stop all correction 01/14/2014
    % because added to new data logger programs
        % radiation values apparently already calibrated and unit-converted
        % in progarm for valles sites
        % temperature correction just for long-wave
        lw_incoming(find(decimal_day > 0.0 & decimal_day < 14.5)) = ...
         lw_incoming(find(decimal_day > 0.0 & decimal_day < 14.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 14.5))).^4;
        lw_outgoing(find(decimal_day > 0.0 & decimal_day < 14.5)) = ...
         lw_outgoing(find(decimal_day > 0.0 & decimal_day < 14.5)) + ...
         0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 14.5))).^4;
        % calibration for par-lite sensor
        Par_Avg(find(decimal_day > 0.0 & decimal_day < 14.5)) = ...
         Par_Avg(find(decimal_day > 0.0 & decimal_day < 14.5)).*1000./5.65;
    
    end
    
    %%%%%%%%%%%%%%%%% texas
  case UNM_sites.TX
    % calibration for the li-190 par sensor - sensor had many high
    % values, so delete all values above 6.5 first
    switch year_arg
      case 2007
        Par_Avg( Par_Avg > 6.5 ) = NaN;
      case { 2008, 2009 }
        Par_Avg( Par_Avg > 15.0 ) = NaN;
      case 2010
        Par_Avg( Par_Avg > 14.5 ) = NaN;
      case 2012
        Par_Avg( Par_Avg > 14.5 ) = NaN;
    end

    Par_Avg = Par_Avg.*1000./(6.16.*0.604);
    if year_arg == 2005 || year_arg == 2006 || year_arg == 2007
        % wind corrections for the Q*7
        NR_tot(find(NR_tot < 0)) = NR_tot(find(NR_tot < 0)).*10.91 ...
         .*((0.00174.*wnd_spd(find(NR_tot < 0))) + 0.99755);
        NR_tot(find(NR_tot > 0)) = NR_tot(find(NR_tot > 0)).*8.83 ...
         .*(1 + (0.066.*0.2.*wnd_spd(find(NR_tot > 0))) ...
         ./(0.066 + (0.2.*wnd_spd(find(NR_tot > 0)))));

        % pyrronometer corrections
        sw_incoming = sw_incoming.*1000./27.34;
        sw_outgoing = sw_outgoing.*1000./19.39;
        
    elseif year_arg == 2008 || year_arg == 2009
        % par switch to par-lite on ??

    end
    
    [ ~, ~, ~, hr, ~, ~ ] = datevec( datenum( year_arg, 1, 0 ) + decimal_day );
    isnight = ( Par_Avg < 20.0 ) | ( sw_incoming < 20 );
    isnight = isnight | ( hr >= 22 ) | ( hr <= 5 );
    % remove nighttime Rg and RgOut values outside of [ -5, 5 ]
    % added 15 Jun 2013 in response to problems noted by Sebastian Wolf
    sw_incoming( isnight & ( abs( sw_incoming ) > 10 ) ) = NaN;
    sw_outgoing( isnight & ( abs( sw_outgoing ) > 10 ) ) = NaN;
    Par_Avg( isnight & ( abs( Par_Avg ) > 10 ) ) = NaN;
    
  case UNM_sites.TX_forest
    % for TX forest 2009, there was no PAR observation in the fluxall file on
    % 15 Mat 2012.  We substituted in PAR from the TX savana site. --  TWH &
    % ML
    if year_arg == 2009
        Par_Avg(find(Par_Avg > 13.5)) = NaN;
        Par_Avg = Par_Avg.*1000./(6.16.*0.604);
    end
    
    % nothing for TX_grassland for now
    
  case UNM_sites.SevEco
    % temperature correction just for long-wave
    lw_incoming = lw_incoming + ( 0.0000000567 .* ( CNR1TK .^ 4 ) );
    lw_outgoing = lw_outgoing + ( 0.0000000567 .* ( CNR1TK .^ 4 ) );
    % recalculate net radiation with T-adjusted longwave?????????
    
    %%%%%%%%%%%%%%%%% New Grassland
  case UNM_sites.New_GLand
    if year_arg <= 2013
    % calibration correction for the li190
    Par_Avg = Par_Avg.*1000./(6.4*0.604);
    % calibration and unit conversion into W per m^2 for CNR1 variables
    % and adjust for program error
    sw_incoming = sw_incoming./136.99.*(1000./8.49);
    sw_outgoing = sw_outgoing./136.99.*(1000./8.49);
    lw_incoming = lw_incoming./136.99.*(1000./8.49);
    lw_outgoing = lw_outgoing./136.99.*(1000./8.49);
    % temperature correction just for long-wave
    lw_incoming = lw_incoming + 0.0000000567.*(CNR1TK).^4;
    lw_outgoing = lw_outgoing + 0.0000000567.*(CNR1TK).^4;
    
    elseif year_arg == 2014
    % RJL added on 01/20/2014 per Marcy, stop all correction 01/17/2014
    % because added to new data logger programs
    % calibration correction for the li190
    % Per Marcy, changed from (5.7*0.604) to (6.4*0.604)
    Par_Avg(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     Par_Avg(find(decimal_day > 0.0 & decimal_day < 17.5)).*1000./(6.4*0.604);
    % calibration and unit conversion into W per m^2 for CNR1 variables
    % and adjust for program error
    sw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     sw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) ...
     ./136.99.*(1000./8.49);
    sw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     sw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) ...
     ./136.99.*(1000./8.49);
    lw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     lw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) ...
     ./136.99.*(1000./8.49);
    lw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     lw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) ...
     ./136.99.*(1000./8.49);
    % temperature correction just for long-wave
    lw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     lw_incoming(find(decimal_day > 0.0 & decimal_day < 17.5)) + ...
     0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 17.5))).^4;
    lw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) = ...
     lw_outgoing(find(decimal_day > 0.0 & decimal_day < 17.5)) + ...
     0.0000000567.*(CNR1TK(find(decimal_day > 0.0 & decimal_day < 17.5))).^4;
    end
end

% Applies to all sites and all years
% remove negative Rg_out values
sw_outgoing( sw_outgoing < -50 ) = NaN;

isnight = ( Par_Avg < 20.0 ) | ( sw_incoming < 20 );
%remove nighttime Rg and RgOut values outside of [ -5, 5 ]
% added 13 May 2013 in response to problems noted by Bai Yang
sw_incoming( isnight & ( abs( sw_incoming ) > 5 ) ) = NaN;
sw_outgoing( isnight & ( abs( sw_outgoing ) > 5 ) ) = NaN;