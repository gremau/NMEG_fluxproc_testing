function pcp_fixed = fix_incorrect_precip_factors(site_code, year, doy, pcp_in)
% FIX_INCORRECT_PRECIP_FACTORS - fix preciptiation data collecting using
% incorrect calibration factors in datalogger code.
%
% several sites (currently thought to be GLand, JSav, and PJ) had incorrect rain
% gauge calibration factors in their datalogger programs at various times.  This
% code fixes those problems and returns the precipitation with the correct
% calibrations applied.
%  
% INPUTS
%    site_code: UNM_sites object; which site?
%    year: the year.  Either single value or N-element vector if data span
%        more than one year.
%    doy: day of year; N-element vector of DOY values (1 <= DOY <= 367)
%    pcp_in: N-element vector; precipitation observations from the datalogger
%
% OUTPUTS
%    pcp_fixed: N-element vector; corrected precipitation
%
% SEE ALSO
%    UNM_sites
%
% Timothy W. Hilton, UNM, Nov 2011

%initialize pcp_fixed to original values
pcp_fixed = pcp_in;  
% if year is one element, expand to size of pcp_in
if numel( year ) == 1
    year_in = year;
    year = repmat( year, size( pcp_in ) );
else
    year_in = unique(year);
end

%-------------------------
% fix GLand
% datalogger used multiplier of 0.254 from install to 17 Jan 2014.  Correct
% multiplier is 0.1.  Therefore apply a correction factor of 
% ( 0.1 / 0.254 ) = 0.394.
if site_code == 1     % Gland
    Jan17 = datenum( 2014, 1, 17 ) - datenum( 2014, 1, 1 ) + 1;
    idx = find( year < 2014 );
    if year_in == 2014;
        idx = find( ( year == 2014 ) & ( doy <= Jan17 ) );
    end
    if not( isempty( idx ) )
        pcp_fixed( idx ) = pcp_in( idx ) * 0.394;
    end

%-------------------------
% fix New_GLand
% On 17 Jan 2014 until April 2 2014 the precip gauge was miswired and
% logged all zeros. This period is changed to NaNs in RBD.m and should be
% filled with other site data. Between April 2 and Sept 24 2014 the precip
% multiplier was 0.1 when it should have been .254. Therefore apply a
% correction factor of ( 0.254 / 0.1 ) = 2.54.
elseif site_code == 11     % New_Gland
    Apr2 = datenum( 2014, 4, 2 ) - datenum( 2014, 1, 1 ) + 1;
    Sep24 = datenum( 2014, 9, 24 ) - datenum( 2014, 1, 1 ) + 1;
    idx = find( ( year == 2014 ) & ( doy >= Apr2 ) & ( doy <= Sep24 ) );
    if not( isempty( idx ) )
        pcp_fixed( idx ) = pcp_in( idx ) * 2.54;
    end

%-------------------------
% fix SLand
% elseif site_code == 2      %SLand
%     idx = ( year == 2011 );
%     if any( idx )
%         pcp_fixed( idx ) = -9999;
%         % now fill in precip record from Sevilleta meteo station 49 
%     end
    

%-------------------------
% fix JSav
% datalogger used multiplier of 0.254 from install to 10 Jan 2014.  Correct
% multiplier is 0.1.  Therefore apply a correction factor of 
% ( 0.1 / 0.254 ) = 0.394.
elseif site_code == 3   %JSav
    Jan10 = datenum( 2014, 1, 10 ) - datenum( 2014, 1, 1 ) + 1;
    idx = find( year < 2014 );
    if year_in == 2014;
        idx = find( ( year == 2014 ) & ( doy <= Jan10 ) );
    end
    if not( isempty( idx ) )
        pcp_fixed( idx ) = pcp_in( idx ) * 0.394;
    end

%-------------------------
% fix PJ
% datalogger used multiplier of 0.254 from install to 31 May 2010.  Correct
% multiplier is 0.1.  Therefore apply a correction factor of 
% ( 0.1 / 0.254 ) = 0.394.
elseif site_code == 4     % PJ
    May31 = datenum( 2010, 5, 31 ) - datenum( 2010, 1, 1 ) + 1;
    idx = find( year < 2010 );
    if year_in == 2010;
        idx = find( ( year == 2010 ) & ( doy <= May31 ) );
    end
    if not( isempty( idx ) )
        pcp_fixed( idx ) = pcp_in( idx ) * 0.394;
    end
end


