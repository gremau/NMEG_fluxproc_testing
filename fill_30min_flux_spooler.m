function output = fill_30min_flux_spooler( data_in, sitecode, year )

%This is a little spooling program to run all the 30-min processing chunks
%for a given site and year at the same time.  
%
% All it does is call UNM_30min_flux_processor over and over.  You can add more
% sets of rows to run if you need to.  It runs as a function, just call it with
% the sitecode and the year.

%the sitecodes are
% 1 = grassland
% 2 = shrubland
% 3 = juniper savanna
% 4 = pinyon juniper (original site)
% 5 = ponderosa pine
% 6 = mixed conifer
% 7 = TX freeman
% 8 = TX forest
% 9 = TX grassland
% 10 = PJ_girdle, PJG_test
% 11 = new grassland

plot_diagnostic = true;

output = data_in;

if sitecode == 1 % GLand
    if year == 2006
    elseif year == 2007
        UNM_30min_flux_processor(1,2007,8213,8260);
        UNM_30min_flux_processor(1,2007,8549,8596);
        UNM_30min_flux_processor(1,2007,8885,8932);
        UNM_30min_flux_processor(1,2007,9892,9940);
        UNM_30min_flux_processor(1,2007,11135,11154);
        UNM_30min_flux_processor(1,2007,11157,11188);
        UNM_30min_flux_processor(1,2007,11237,11284);
    elseif year == 2008
        UNM_30min_flux_processor(1,2008,330,357);
        UNM_30min_flux_processor(1,2008,624,628);
        UNM_30min_flux_processor(1,2008,1673,1686);
        UNM_30min_flux_processor(1,2008,3536,4428);
        UNM_30min_flux_processor(1,2008,8428,9148);
        UNM_30min_flux_processor(1,2008,13345,13358);
    elseif year == 2009
%         output = fill_30min_flux_processor( output, 1,2009,1221,2282);
%         output = fill_30min_flux_processor( output, 1,2009,2443,2439);
%         output = fill_30min_flux_processor( output, 1,2009,4297,4321);
%         output = fill_30min_flux_processor( output, 1,2009,6002,6079);
%         output = fill_30min_flux_processor( output, 1,2009,9627,9779);
%         output = fill_30min_flux_processor( output, 1,2009,10601,10780);
%         output = fill_30min_flux_processor( output, 1,2009,14478,15929);
        %output = fill_30min_flux_processor( output, 1, 2009, 1218, 1467 );
        % IRGA clearly down in second part of this period
        output = fill_30min_flux_processor( output, 1, 2009, 1218, 2282 );
        %output = fill_30min_flux_processor( output, 1,2009,2443,2439);
        % output = fill_30min_flux_processor( output, 1,2009,4297,4321 );
        % output = fill_30min_flux_processor( output, 1,2009,6002,6079 );
        output = fill_30min_flux_processor( output, 1,2009,9645,9779 );
        output = fill_30min_flux_processor( output, 1,2009,10601,10780 );    
        output = fill_30min_flux_processor( output, 1,2009,14478,15929, ...
            'write_file', true);  
    elseif year == 2010
        output = fill_30min_flux_processor( output, 1,2010,4740,4837);
        output = fill_30min_flux_processor( output, 1,2010,5081,5694);
        output = fill_30min_flux_processor( output, 1,2010,10673,10904);
        output = fill_30min_flux_processor( output, 1,2010,12990,13271);
        output = fill_30min_flux_processor( output, 1,2010,14089,15671);
    elseif year == 2011
        % output = fill_30min_flux_processor( output, 1,2011,1899,1999);
        output = fill_30min_flux_processor( output, 1,2011,9055,9957);
        % output = fill_30min_flux_processor( output, 1,2011,10587,10588);
    elseif year == 2012
        %output = fill_30min_flux_processor( output, 1,2012, DOYidx( 196 ), DOYidx( 216 ) );
        %output = fill_30min_flux_processor( output, 1,2012, DOYidx( 226 ), DOYidx( 241 ) );
    elseif year == 2013
        %output = fill_30min_flux_processor( output, 1,2013, DOYidx( 148.9 ), DOYidx( 149.6 ) );
    end
    
elseif sitecode == 2 % SLand
    if year == 2006
    elseif year == 2007
        UNM_30min_flux_processor(2,2007,5,6820);
        UNM_30min_flux_processor(2,2007,7181,7228);
        UNM_30min_flux_processor(2,2007,7517,7564);
        UNM_30min_flux_processor(2,2007, 7853,7900);
        UNM_30min_flux_processor(2,2007,8189,8236);
        UNM_30min_flux_processor(2,2007,8525,8572);
        UNM_30min_flux_processor(2,2007,10903,10924);
        UNM_30min_flux_processor(2,2007,11785,11803);
        UNM_30min_flux_processor(2,2007,16157,16163);

    elseif year == 2008
        UNM_30min_flux_processor(2,2008,3537,5433);
        UNM_30min_flux_processor(2,2008,8444,8473);
        UNM_30min_flux_processor(2,2008,8486,8616);
        UNM_30min_flux_processor(2,2008,8624,8780);
        UNM_30min_flux_processor(2,2008,8783,9153);
   
    elseif year == 2009
        %output = fill_30min_flux_processor( output, 2,2009,4386,4420);
        output = fill_30min_flux_processor( output, 2,2009,7006,7317);
        %output = fill_30min_flux_processor( output, 2,2009,6076,7758);
        
    elseif year == 2010
        output = fill_30min_flux_processor( output, 2,2010,16805,16814);     
        
    elseif year == 2011
        %output = fill_30min_flux_processor( output, 2,2011,1901,2002);    
        %output = fill_30min_flux_processor( output, 2,2011,8669,8759); 
    
    elseif year == 2012 % Leap year
        output = fill_30min_flux_processor( output, 2,2012,16680,16766);
        output = fill_30min_flux_processor( output, 2,2012,16832,16862);
        output = fill_30min_flux_processor( output, 2,2012,17238,17249);
        output = fill_30min_flux_processor( output, 2,2012,17324,17344);
    elseif year == 2013
        % For some reason 1 day/month of 10hz data is missing at this site
        output = fill_30min_flux_processor( output, 2, 2013, DOYidx(1), DOYidx(2.36));
        output = fill_30min_flux_processor( output, 2, 2013, DOYidx(10.68), DOYidx(11.07));
        output = fill_30min_flux_processor( output, 2, 2013, DOYidx(14.81), DOYidx(15.28));
        output = fill_30min_flux_processor( output, 2, 2013, DOYidx(240.48), DOYidx(241.46));
    end

elseif sitecode == 3 % JSav
    if year == 2007
        UNM_30min_flux_processor(3,2007,963,988);
        UNM_30min_flux_processor(3,2007,7244,7261);
        UNM_30min_flux_processor(3,2007,7582,7615);
        UNM_30min_flux_processor(3,2007,11099,11114);
    elseif year == 2008    
        UNM_30min_flux_processor(3,2008,9176,9182);
        UNM_30min_flux_processor(3,2008,9863,9892);
        UNM_30min_flux_processor(3,2008,10207,10228);
        UNM_30min_flux_processor(3,2008,10923,10948);
    elseif year == 2009
        % Irga data is garbage during this time
        output = fill_30min_flux_processor( output, 3,2009,987,3106);
        % IRGA ok
        output = fill_30min_flux_processor( output, 3,2009,6742,7958);
        %output = fill_30min_flux_processor( output, 3,2009,14716,16737);
    elseif year == 2010
%         output = fill_30min_flux_processor( output, 3,2010,10581,10586);
%         output = fill_30min_flux_processor( output, 3,2010,10629,10637);
%         output = fill_30min_flux_processor( output, 3,2010,10640,10642);
%         output = fill_30min_flux_processor( output, 3,2010,10644,10646);
%         output = fill_30min_flux_processor( output, 3,2010,10648,10674);
%         output = fill_30min_flux_processor( output, 3,2010,10676,10689);
%         output = fill_30min_flux_processor( output, 3,2010,10695,10702);
%         output = fill_30min_flux_processor( output, 3,2010,10723,10746);
%         output = fill_30min_flux_processor( output, 3,2010,10819,10825);
%         output = fill_30min_flux_processor( output, 3,2010,10868,10877);
        output = fill_30min_flux_processor( output, 3,2010,10064,10258);
    elseif year == 2011 % added by MF
        output = fill_30min_flux_processor( output, 3,2011,1541,1613);

    elseif year == 2012 % added by TWH
        output = fill_30min_flux_processor( output, 3,2012,5090,5120);
        output = fill_30min_flux_processor( output, 3,2012,11570,11602);
        % No data at end of year...
        output = fill_30min_flux_processor( output, 3,2012,16503,16527);
    elseif year == 2013
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(80), DOYidx(80.292));
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(80.042), DOYidx(95.458));
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(96.028), DOYidx(107.375));
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(111.313), DOYidx(111.979));
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(201.688), DOYidx(205.688));
        output = fill_30min_flux_processor( output, 3, 2013, DOYidx(326.104), DOYidx(329.354));
    end    
elseif sitecode == 4 % PJ_control
    if year == 2009
        %output = fill_30min_flux_processor( output, 4,2009,10354,10372);
    elseif year == 2010
        % Many of these small filled periods seem fairly noisy. Could be
        % good to just let a gapfiller do it.
        output = fill_30min_flux_processor( output, 4,2010,1022,1032);
        output = fill_30min_flux_processor( output, 4,2010,1073,1079);
        output = fill_30min_flux_processor( output, 4,2010,1310,1320);
        output = fill_30min_flux_processor( output, 4,2010,1341,1355);
        output = fill_30min_flux_processor( output, 4,2010,1624,1633);
        output = fill_30min_flux_processor( output, 4,2010,1883,1894);
        output = fill_30min_flux_processor( output, 4,2010,1936,1942);
        output = fill_30min_flux_processor( output, 4,2010,1959,1985);
        output = fill_30min_flux_processor( output, 4,2010,2167,2181);
        output = fill_30min_flux_processor( output, 4,2010,2551,2564);
        output = fill_30min_flux_processor( output, 4,2010,2825,2854);
        output = fill_30min_flux_processor( output, 4,2010,3493,3507);
        output = fill_30min_flux_processor( output, 4,2010,3751,3763);
        output = fill_30min_flux_processor( output, 4,2010,3915,3924);
        output = fill_30min_flux_processor( output, 4,2010,5091,5109);
        output = fill_30min_flux_processor( output, 4,2010,5142,5152);
        output = fill_30min_flux_processor( output, 4,2010,6426,6439);
        output = fill_30min_flux_processor( output, 4,2010,9129,9136);
    elseif year == 2011
        output = fill_30min_flux_processor( output, 4,2011,13301,13316);
        output = fill_30min_flux_processor( output, 4,2011,13426,13447);
        output = fill_30min_flux_processor( output, 4,2011,14347,14362);
        output = fill_30min_flux_processor( output, 4,2011,16076,16084);
        output = fill_30min_flux_processor( output, 4,2011,16230,16238);
        output = fill_30min_flux_processor( output, 4,2011,16762,16778);
        output = fill_30min_flux_processor( output, 4,2011,16836,16869);
        output = fill_30min_flux_processor( output, 4,2011,16884,17063);
        output = fill_30min_flux_processor( output, 4,2011,17078,17156);
        output = fill_30min_flux_processor( output, 4,2011,17449,17521);
    elseif year == 2012
        output = fill_30min_flux_processor( output, 4,2012,1,27);
        output = fill_30min_flux_processor( output, 4,2012,313,336);
        output = fill_30min_flux_processor( output, 4,2012,12289,12357);
        output = fill_30min_flux_processor( output, 4,2012,16176,16296);
        output = fill_30min_flux_processor( output, 4,2012,16516,16546);  
    elseif year == 2013
        output = fill_30min_flux_processor( output, 4,2012,16600,16630);
    end
        
elseif sitecode == 5 % PPine
    if year == 2007
        UNM_30min_flux_processor(5,2007,1491,1527);
        UNM_30min_flux_processor(5,2007,3941,3946);
        UNM_30min_flux_processor(5,2007,4000,4011);
        UNM_30min_flux_processor(5,2007,15669,15692);
        UNM_30min_flux_processor(5,2007,16422,16435);
    elseif year == 2008
        UNM_30min_flux_processor(5,2008,774,792);
        UNM_30min_flux_processor(5,2008,1739,1748);
        UNM_30min_flux_processor(5,2008,10992,10999);
        UNM_30min_flux_processor(5,2008,11713,11723);
        UNM_30min_flux_processor(5,2008,13251,13258);
    elseif year == 2009
        output = fill_30min_flux_processor( output, 5,2009,7218,7287);
        output = fill_30min_flux_processor( output, 5,2009,7314,7336);
        output = fill_30min_flux_processor( output, 5,2009,7412,7449);
        output = fill_30min_flux_processor( output, 5,2009,7453,7598);
        output = fill_30min_flux_processor( output, 5,2009,7621,7637);
        output = fill_30min_flux_processor( output, 5,2009,7951,8059);
        output = fill_30min_flux_processor( output, 5,2009,8082,8157);
        output = fill_30min_flux_processor( output, 5,2009,14048,14065);
    elseif year == 2010
        % Commenting because data found
%         output = fill_30min_flux_processor( output, 5,2010,12437,12471);
%         output = fill_30min_flux_processor( output, 5,2010,12476,13420);
%         output = fill_30min_flux_processor( output, 5,2010,13433,14147);
%         output = fill_30min_flux_processor( output, 5,2010,14148,14331);
%         output = fill_30min_flux_processor( output, 5,2010,14427,15277);
%         output = fill_30min_flux_processor( output, 5,2010,15688,16758);
        output = fill_30min_flux_processor( output, 5,2010,16779,16790);
        output = fill_30min_flux_processor( output, 5,2010,16871,16901);
        output = fill_30min_flux_processor( output, 5,2010,16904,16928);
        output = fill_30min_flux_processor( output, 5,2010,17031,17064);
        output = fill_30min_flux_processor( output, 5,2010,17401,17467);
    elseif year == 2011
        output = fill_30min_flux_processor( output, 5,2011,1233,2243);
    elseif year == 2012
        output = fill_30min_flux_processor( output, 5,2012,9724,11164);
    elseif year == 2013
        output = fill_30min_flux_processor( output, 5,2013,1,24);
        output = fill_30min_flux_processor( output, 5,2013,1332,1376);
        output = fill_30min_flux_processor( output, 5,2013,1962,1993);
        output = fill_30min_flux_processor( output, 5,2013,12234,12266);
        output = fill_30min_flux_processor( output, 5,2013,15287, 15477);
        output = fill_30min_flux_processor( output, 5,2013,15553, 15558);
        output = fill_30min_flux_processor( output, 5,2013,15598, 15611);
        output = fill_30min_flux_processor( output, 5,2013,15823, 15861);
    end

elseif sitecode == 6 % MCon
    if year == 2007
        UNM_30min_flux_processor(6,2007,1233,1240);
        UNM_30min_flux_processor(6,2007,2102,2110);
        UNM_30min_flux_processor(6,2007,2126,2145);
        UNM_30min_flux_processor(6,2007,11981,12004);
        UNM_30min_flux_processor(6,2007,13137,14135);
        UNM_30min_flux_processor(6,2007,15747,15752);
        UNM_30min_flux_processor(6,2007,16451,16476);
        UNM_30min_flux_processor(6,2007,16543,16553);
        UNM_30min_flux_processor(6,2007,16597,16614);
        UNM_30min_flux_processor(6,2007,16824,16852);
        UNM_30min_flux_processor(6,2007,17041,17062);
        UNM_30min_flux_processor(6,2007, 17523, 17524);
    elseif year == 2008
        UNM_30min_flux_processor(6,2008,431,455);
        UNM_30min_flux_processor(6,2008,768,774);
        UNM_30min_flux_processor(6,2008,1195,1211);
        UNM_30min_flux_processor(6,2008,1805,1828);
    elseif year == 2009
        output = fill_30min_flux_processor( output, 6,2009,3420,3489);
        output = fill_30min_flux_processor( output, 6,2009,15963,15984);
        output = fill_30min_flux_processor( output, 6,2009,17133,17162);
        output = fill_30min_flux_processor( output, 6,2009,17422,17450);
    elseif year == 2010 % added by Mike Fuller, Feb 23, 2011
        output = fill_30min_flux_processor( output, 6,2010,1087,1184);
        output = fill_30min_flux_processor( output, 6,2010,14154,14175);
        output = fill_30min_flux_processor( output, 6,2010,16748,16776);
        output = fill_30min_flux_processor( output, 6,2010,16880,16917);
        output = fill_30min_flux_processor( output, 6,2010,17473,17499);
        output = fill_30min_flux_processor( output, 6,2010,17509,17521);
    elseif year == 2011 % added by Mike Fuller
        output = fill_30min_flux_processor( output, 6, 2011, 1,25);
        output = fill_30min_flux_processor( output, 6, 2011, 1527,1606);
        % Filled data look pretty bad here
        output = fill_30min_flux_processor( output, 6, 2011, 10775, 11366);
    elseif year == 2012
        output = fill_30min_flux_processor( output, 6, 2012,769,791);
        output = fill_30min_flux_processor( output, 6, 2012,1675,1721);
        output = fill_30min_flux_processor( output, 6, 2012,3309,3380);
        output = fill_30min_flux_processor( output, 6, 2012, 5037,5064);
        output = fill_30min_flux_processor( output, 6, 2012, 16631,16657);
        output = fill_30min_flux_processor( output, 6, 2012, 16748,16773);
        output = fill_30min_flux_processor( output, 6, 2012, 17230,17260);
        output = fill_30min_flux_processor( output, 6, 2012, 17558,17569);
    elseif year == 2013 % added by Mike Fuller
        output = fill_30min_flux_processor( output, 6, 2013, DOYidx(1),DOYidx(1.52));
        output = fill_30min_flux_processor( output, 6, 2013, DOYidx(29.75),DOYidx(30.33));
        output = fill_30min_flux_processor( output, 6, 2013, DOYidx(52.917),DOYidx(53.458));
        output = fill_30min_flux_processor( output, 6, 2013, DOYidx(324.9),DOYidx(325.375));
      elseif year == 2014 % added by Mike Fuller
        output = fill_30min_flux_processor( output, 6, 2013, 1832,2341);
    end

elseif sitecode == 7 % TX_savanna
    if year == 2005
        UNM_30min_flux_processor_071610(7,2005,338,346);
        UNM_30min_flux_processor_071610(7,2005,4919,5028);
        UNM_30min_flux_processor_071610(7,2005,12533,12580);
        UNM_30min_flux_processor_071610(7,2005,16361,16364);
    elseif year == 2006
        UNM_30min_flux_processor_071610(7,2006,2355,2362);
        UNM_30min_flux_processor_071610(7,2006,2379,2383);
        UNM_30min_flux_processor_071610(7,2006,12965,13033);
        UNM_30min_flux_processor_071610(7,2006,14584,14841);
        UNM_30min_flux_processor_071610(7,2006,15529,15577);
    elseif year == 2007
        UNM_30min_flux_processor_071610(7,2007,4740,4756);
        UNM_30min_flux_processor_071610(7,2007,9220,9268);
        UNM_30min_flux_processor_071610(7,2007,10272,10287);
        UNM_30min_flux_processor_071610(7,2007,10492,10616);
        UNM_30min_flux_processor_071610(7,2007,10825,10852);
        UNM_30min_flux_processor_071610(7,2007,13252,13300);
        UNM_30min_flux_processor_071610(7,2007,16828,16852);
        UNM_30min_flux_processor_071610(7,2007,16870,16996);
    elseif year == 2008
        UNM_30min_flux_processor_071610(7,2008,506,580);
%         UNM_30min_flux_processor_071610(7,2008,2152,2187);
%         UNM_30min_flux_processor_071610(7,2008,4021,6426);
%         UNM_30min_flux_processor_071610(7,2008,7364,8538);
%         UNM_30min_flux_processor_071610(7,2008,9212,9882);
%         UNM_30min_flux_processor_071610(7,2008,10106,10132);
%         UNM_30min_flux_processor_071610(7,2008, 12801, 14572);
    elseif year == 2009
      %  UNM_30min_flux_processor_071610(7,2009,5,6704);
        UNM_30min_flux_processor_071610(7,2009,6705,17282);
    elseif year == 2011
        UNM_30min_flux_processor_071610(7,2011,6131,6148);
    end 
    
elseif sitecode == 8 % TX_forest    
    if year == 2008
        UNM_30min_flux_processor_071610(8,2008,5,17571);
    elseif year == 2009        
        UNM_30min_flux_processor_071610(8,2009,5,17523);
    end
    
elseif sitecode == 9 % TX_grassland
    if year == 2005
        UNM_30min_flux_processor(9,2005,506,532);
        UNM_30min_flux_processor(9,2005,976,1204);
        UNM_30min_flux_processor(9,2005,1553,1953);
        UNM_30min_flux_processor(9,2005,2021,2596);
        UNM_30min_flux_processor(9,2005,2837,2850);
        UNM_30min_flux_processor(9,2005,2858,3245);
        UNM_30min_flux_processor(9,2005,5449,5600);
        UNM_30min_flux_processor(9,2005,6794,6938);
        UNM_30min_flux_processor(9,2005,16363,16398);
    elseif year == 2006
    elseif year == 2007
    elseif year == 2008
        UNM_30min_flux_processor_071610(9,2008,5,17571);
    elseif year == 2009    
        %UNM_30min_flux_processor_071610(9,2009,5,13033);
        UNM_30min_flux_processor_071610(9,2009,13033,16894);
    end
    
elseif sitecode == 10 % PJ_girdle
    if year==2009
        output = fill_30min_flux_processor( output, 10,2009,7593,7663);
        % These don't look good
        output = fill_30min_flux_processor( output, 10,2009,10780,10825);
        output = fill_30min_flux_processor( output, 10,2009,10831,10961);
        output = fill_30min_flux_processor( output, 10,2009,10983,11112);
    elseif year == 2010
        output = fill_30min_flux_processor( output, 10,2010,1307,1318);
        output = fill_30min_flux_processor( output, 10,2010,1338,1349);
        output = fill_30min_flux_processor( output, 10,2010,1618,1631);
        output = fill_30min_flux_processor( output, 10,2010,1956,1979);
        output = fill_30min_flux_processor( output, 10,2010,2542,2561);
    elseif year == 2011
      output = fill_30min_flux_processor( output, 10,2011,1533,1604);
      output = fill_30min_flux_processor( output, 10,2011,14346,14373);
      output = fill_30min_flux_processor( output, 10,2011,16759,16776);
      output = fill_30min_flux_processor( output, 10,2011,17089,17114);
    elseif year == 2012
        output = fill_30min_flux_processor( output, 10,2012,DOYidx(220.4), DOYidx( 221));
        output = fill_30min_flux_processor( output, 10,2012,11640,11714);
        output = fill_30min_flux_processor( output, 10,2012,11914,11947);
        %output = fill_30min_flux_processor( output, 10,2012,12286,12322);
        output = fill_30min_flux_processor( output, 10,2012,12454,12519);
        output = fill_30min_flux_processor( output, 10,2012,12599,12762);
        output = fill_30min_flux_processor( output, 10,2012,12787,12853);
        output = fill_30min_flux_processor( output, 10,2012,13262,13303);
        output = fill_30min_flux_processor( output, 10,2012,13717,13769);
        output = fill_30min_flux_processor( output, 10,2012,13796,14123);
        output = fill_30min_flux_processor( output, 10,2012,14178,14485);
        output = fill_30min_flux_processor( output, 10,2012,16274,16306);
    elseif year == 2013
        output = fill_30min_flux_processor( output, 10,2013,5459,5686);
        output = fill_30min_flux_processor( output, 10,2013,10829,10841);
    end   
    
elseif sitecode == 11 % New GLand
    if year == 2010
        % enter values here
    elseif year == 2011
        %             UNM_30min_flux_processor_MFedit(11,2011,1898,2043);
        %             UNM_30min_flux_processor_MFedit(11,2011,3125,3220);
        %             UNM_30min_flux_processor_MFedit(11,2011,8148,8294);
        %             UNM_30min_flux_processor_MFedit(11,2011,8339,8356);
        %output = fill_30min_flux_processor( output, 11,2011,6303,8330);
    elseif year == 2012
        fill_30min_flux_processor( output, 11,2012,10482,10538);
    end 
    
end

if plot_diagnostic
    
    figure( 'Name', 'Fill 30min flux output', ...
        'Position', [100, 100, 1200, 800] );
    
    ch_idx = data_in.Fc_raw_massman_ourwpl ~= output.Fc_raw_massman_ourwpl;
    
    ax( 1 ) = subplot( 4, 1, 1 );
    plot( data_in.timestamp, data_in.CO2_mean, 'ok' );
    hold on;
    plot( output.timestamp, output.CO2_mean, '.b' );
    plot( output.timestamp( ch_idx ), output.CO2_mean( ch_idx ), '.r' );
    datetick( 'x', 'mmm-yy', 'keeplimits', 'keepticks' );
    ylabel( 'CO2\_mean' );
    ylim( [-60000, 50000]);
    
    ax( 2 ) = subplot( 4, 1, 2 );
    plot( data_in.timestamp, data_in.Fc_raw_massman_ourwpl, 'ok' );
    hold on;
    plot( output.timestamp, output.Fc_raw_massman_ourwpl, '.b' );
    plot( output.timestamp( ch_idx ), output.Fc_raw_massman_ourwpl( ch_idx ), '.r' );
    datetick( 'x', 'mmm-yy', 'keeplimits', 'keepticks' );
    ylabel( 'Fc\_raw\_massman\_ourwpl' );
    ylim( [-100, 100]);
    
    ax( 3 ) = subplot( 4, 1, 3 );
    plot( data_in.timestamp, data_in.LatentHeat_wpl_massman, 'ok' );
    hold on;
    plot( output.timestamp, output.LatentHeat_wpl_massman, '.b' );
    plot( output.timestamp( ch_idx ), output.LatentHeat_wpl_massman( ch_idx ), '.r' );
    datetick( 'x', 'mmm-yy', 'keeplimits', 'keepticks' );
    ylabel( 'LatentHeat\_wpl\_massman' );
    
    ax( 4 ) = subplot( 4, 1, 4 );
    plot( data_in.timestamp, data_in.HSdry_massman, 'ok' );
    hold on;
    plot( output.timestamp, output.HSdry_massman, '.b' );
    plot( output.timestamp( ch_idx ), output.HSdry_massman( ch_idx ), '.r' );
    linkaxes( ax, 'x' );
    datetick( 'x', 'mmm-yy', 'keeplimits', 'keepticks' );
    ylabel( 'HSdry\_massman' );
    
end

disp('All done')
