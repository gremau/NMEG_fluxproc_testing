% This program was created by Krista Anderson Teixeira in July 2007
% Modified by John DeLong 2008 through 2009

% The program reads site_fluxall_year excel files and pulls in a
% combination of matlab processed ts data and data logged average 30-min
% flux data.  It then flags values based on a variety of criteria and
% writes out new files that do not have the identified bad values.  It
% writes out a site_flux_all_qc file and a site_flux_all_for_gap_filling
% file to send to the Reichstein online gap-filling program.  It can be
% adjusted to make other subsetted files too.

% This program is set up to run as a function where you enter the command
% along with the sitecode (1-7 see below) and the year.  This means that it
% only runs on files that are broken out by year.

%function [] = UNM_RemoveBadData(sitecode,year,iteration)

clear all
close all
sitecode = 6;
year = 2007;

% sitecode key
% 1-GLand
% 2-SLand
% 3-JSav
% 4-PJ
% 5-PPine
% 6-MCon
% 7-TX_savanna
% 8-TX_forest
% 9-TX_grassland

write_complete_out_file = 1; %1 to write "[sitename].._qc", -- file with all variables & bad data removed
data_for_analyses = 0; %1 to output file with data sorted for specific analyses
ET_gap_filler = 0; %run ET gap-filler program
write_gap_filling_out_file = 1; %1 to write file for Reichstein's online gap-filling. SET U* LIM (including site- specific ones--comment out) TO 0!!!!!!!!!!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Specify some details about sites and years
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if sitecode==1; % grassland
    site='GLand';
    if year == 2006
        filelength_n = 11594;
    elseif year == 2007
        filelength_n = 17523;
        lastcolumn='HG';
        ustar_lim = 0.06;
        co2_min = -7; co2_max = 6;
    elseif year == 2008;
        filelength_n = 17572;
        lastcolumn='HJ';
        ustar_lim = 0.06;
        co2_min = -10; co2_max = 6;
    elseif year == 2009;
        filelength_n = 13371;
        lastcolumn='HO';
        ustar_lim = 0.06;
        co2_min = -10; co2_max = 6;
    end
    wind_min = 330; wind_max = 30; % these are given a sonic_orient = 180;
    Tdry_min = 240; Tdry_max = 320;
    HS_min = -100; HS_max = 450;
    HSmass_min = -100; HSmass_max = 450;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;

elseif sitecode==2; % shrubland
    site='SLand'    
    if year == 2006
    elseif year == 2007
        filelength_n = 17523;
        lastcolumn='GX';
        ustar_lim = 0.08;
        co2_min = -10; co2_max = 6;        
    elseif year == 2008
        filelength_n = 17572;
        lastcolumn='GZ';
        ustar_lim = 0.08;
        co2_min = -10; co2_max = 6;
    elseif year == 2009
        filelength_n = 13376;
        lastcolumn='IL';
        ustar_lim = 0.08;
        co2_min = -10; co2_max = 6;
    end
    wind_min = 330; wind_max = 30; % these are given a sonic_orient = 180;
    Tdry_min = 240; Tdry_max = 320;
    HS_min = -100; HS_max = 450;
    HSmass_min = -100; HSmass_max = 450;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
     
elseif sitecode==3; % Juniper savanna
    site = 'JSav'   
    if year == 2007
        filelength_n = 11595;
        lastcolumn='HR';
        ustar_lim = 0.09;
        co2_min = -11; co2_max = 7;        
    elseif year == 2008
        filelength_n = 17571;
        lastcolumn='HJ';
        ustar_lim = 0.08;
        co2_min = -10; co2_max = 10;
    elseif year == 2009
        filelength_n = 4639;
        lastcolumn='HN';
        ustar_lim = 0.08;
        co2_min = -10; co2_max = 10;
    end
    wind_min = 15; wind_max = 75; % these are given a sonic_orient = 225;
    Tdry_min = 240; Tdry_max = 320;
    HS_min = -100; HS_max = 450;
    HSmass_min = -100; HSmass_max = 450;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;
    
elseif sitecode == 4; % Pinyon Juniper
    site = 'PJ'
    if year == 2007
        lastcolumn = 'HO';
        filelength_n = 2514;
        ustar_lim = 0.16;
    elseif year == 2008
        lastcolumn = 'HO'; 
        filelength_n = 17572;
        ustar_lim = 0.16;
    elseif year == 2009
        lastcolumn = 'HJ';
        filelength_n = 17524;
        ustar_lim = 0.16;
    elseif year == 2010
        lastcolumn = 'HJ';
        filelength_n = 4025;
        ustar_lim = 0.16; 
    end    
    wind_min = 15; wind_max = 75; % these are given a sonic_orient = 225;
    co2_min = -10; co2_max = 6;
    Tdry_min = 240; Tdry_max = 310;
    HS_min = -100; HS_max = 640;
    HSmass_min = -100; HSmass_max = 640;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;
    
elseif sitecode==5; % Ponderosa Pine
    site = 'PPine'
    if year == 2006
        filelength_n = 11594;
    elseif year == 2007
        filelength_n = 17524;
        lastcolumn='FV';
        ustar_lim = 0.08;
        co2_min = -15; co2_max = 15;
%        co2_min = -30; co2_max = 30;
    elseif year == 2008;
        filelength_n = 17572;
        lastcolumn='FU';
        ustar_lim = 0.08;
        co2_min = -15; co2_max = 15;
%        co2_min = -30; co2_max = 30;
    elseif year == 2009;
        filelength_n = 12029;
        lastcolumn='FX';
        ustar_lim = 0.08;
        co2_min = -15; co2_max = 15;
%        co2_min = -30; co2_max = 30;
    end
%    co2_max_by_month = [4 4 4 4 5 12 12 12 12 12 4 4];
    co2_max_by_month = [4 4 4 5 8 12 12 12 12 10 5 4];    
    wind_min = 119; wind_max = 179; % these are given a sonic_orient = 329;
    Tdry_min = 240; Tdry_max = 300;
    HS_min = -200; HS_max = 800;
    HSmass_min = -200; HSmass_max = 800;
    LH_min = -150; LH_max = 550;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    
elseif sitecode==6; % Mixed conifer
    site = 'MCon'
    if year == 2006
        filelength_n = 4420; 
        lastcolumn='GA';
        ustar_lim = 0.12;
        co2_min = -12; co2_max = 6;
    elseif year == 2007
        filelength_n = 17524;
        lastcolumn='GB';
        ustar_lim = 0.12;
        co2_min = -12; co2_max = 6;
    elseif year == 2008;
        filelength_n = 17420;
        lastcolumn='GB';
        ustar_lim = 0.11;
        co2_min = -12; co2_max = 6;
    elseif year == 2009;
        filelength_n = 16780;
        lastcolumn='GF';
        ustar_lim = 0.11;
        co2_min = -12; co2_max = 6;
    end
    
    wind_min = 153; wind_max = 213; % these are given a sonic_orient = 333;
    Tdry_min = 250; Tdry_max = 300;
    HS_min = -200; HS_max = 800;
    HSmass_min = -200; HSmass_max = 800;
    LH_min = -150; LH_max = 550;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    
elseif sitecode == 7;
    site = 'TX'
    if year == 2005
        filelength_n = 17524;  
        lastcolumn='GF';
        ustar_lim = 0.11;
        co2_min = -26; co2_max = 12;
    elseif year == 2006
        filelength_n = 17524;  
        lastcolumn='GF';
        ustar_lim = 0.11;
        co2_min = -26; co2_max = 12;
    elseif year == 2007
        filelength_n = 17524;
        lastcolumn='FZ';
        ustar_lim = 0.11;
        co2_min = -26; co2_max = 12;
    elseif year == 2008;
        filelength_n = 17452;
        lastcolumn='GP';
        ustar_lim = 0.11;
        co2_min = -11; co2_max = 6;
    end
    wind_min = 296; wind_max = 356; % these are given a sonic_orient = 146;
    Tdry_min = 265; Tdry_max = 315;
    HS_min = -200; HS_max = 800;
    HSmass_min = -200; HSmass_max = 800;
    LH_min = -150; LH_max = 550;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;

elseif sitecode == 8;
    site = 'TX_forest'
    if year == 2005
        filelength_n = 17524;  
        lastcolumn='DO';
        ustar_lim = 0.12;
    elseif year == 2006
        filelength_n = 17524;  
        lastcolumn='DO';
        ustar_lim = 0.12;
    elseif year == 2007
        filelength_n = 17524;
        lastcolumn='DO';
        ustar_lim = 0.12;
    elseif year == 2008;
        filelength_n = 16253;
        lastcolumn='GP';
        ustar_lim = 0.11;
    end
    co2_min = -26; co2_max = 12;
    wind_min = 300; wind_max = 360; % these are given a sonic_orient = ;
    Tdry_min = 265; Tdry_max = 315;
    HS_min = -200; HS_max = 800;
    HSmass_min = -200; HSmass_max = 800;
    LH_min = -150; LH_max = 550;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;
    
elseif sitecode == 9;
    site = 'TX_grassland'
    if year == 2005
        filelength_n = 17524;  
        lastcolumn='DT';
        ustar_lim = 0.06;
    elseif year == 2006
        filelength_n = 17523;  
        lastcolumn='DO';
        ustar_lim = 0.06;
    elseif year == 2007
        filelength_n = 17524;
        lastcolumn='DO';
        ustar_lim = 0.07;
    elseif year == 2008;
        filelength_n = 16253;
        lastcolumn='GP';
        ustar_lim = 0.11;
    end
    co2_min = -26; co2_max = 12;
    wind_min = 300; wind_max = 360; % these are given a sonic_orient = ;
    Tdry_min = 265; Tdry_max = 315;
    HS_min = -200; HS_max = 800;
    HSmass_min = -200; HSmass_max = 800;
    LH_min = -150; LH_max = 550;
    rH_min = 0; rH_max = 1;
    h2o_max = 35; h2o_min = 0;
    press_min = 70; press_max = 130;

elseif sitecode == 10; % Pinyon Juniper girdle
    site = 'PJ_girdle'
    lastcolumn = 'FE';
    if year == 2009
        filelength_n = 17523;
        ustar_lim = 0.16;    
    elseif year == 2010
        filelength_n = 4017;
        ustar_lim = 0.16;    
    end      
    wind_min = 15; wind_max = 75; % these are given a sonic_orient = 225;
    co2_min = -10; co2_max = 6;
    Tdry_min = 240; Tdry_max = 310;
    HS_min = -100; HS_max = 640;
    HSmass_min = -100; HSmass_max = 640;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;
    
elseif sitecode == 11; % Pinyon Juniper girdle test
    site = 'PJG_test'
    lastcolumn = 'FE';
    if year == 2009
        filelength_n = 16826;
        ustar_lim = 0.16;    
    end    
    wind_min = 15; wind_max = 75; % these are given a sonic_orient = 225;
    co2_min = -10; co2_max = 6;
    Tdry_min = 240; Tdry_max = 310;
    HS_min = -100; HS_max = 640;
    HSmass_min = -100; HSmass_max = 640;
    LH_min = -150; LH_max = 450;
    rH_min = 0; rH_max = 1;
    h2o_max = 30; h2o_min = 0;
    press_min = 70; press_max = 130;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up file name and file path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

drive='c:';
row1=5;  %first row of data to process - rows 1 - 4 are header
filename = strcat(site,'_flux_all_',num2str(year))
%filename = strcat(site,'_new_radiation_flux_all_',num2str(year))
filelength = num2str(filelength_n);
%datalength = filelength_n - row1 + 1; 
filein = strcat(drive,'\Research - Flux Towers\Flux Tower Data by Site\',site,'\',filename)
outfolder = strcat(drive,'\Research - Flux Towers\Flux Tower Data by Site\',site,'\processed flux\');
range = strcat('B',num2str(row1),':',lastcolumn,filelength);
headerrange = strcat('B2:',lastcolumn,'2');
time_stamp_range = strcat('A5:A',filelength);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Open file and parse out dates and times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('reading data...')
[num text] = xlsread(filein,headerrange);
headertext = text;
[num text] = xlsread(filein,range);  %does not read in first column because it's text!!!!!!!!
data = num; % data from annual flux_ALL file
ncol = size(data,2)+1;
datalength = size(data,1);
[num text] = xlsread(filein,time_stamp_range);
timestamp = text;
[year month day hour minute second] = datevec(timestamp);
datenumber = datenum(timestamp);
disp('file read');

qcfile = strcat(outfolder,filename,'_qc.xls');

[qc_num qc_text] = xlsread(qcfile,'data');

jday=qc_num(:,7);
u_star=qc_num(:,10);
air_temp_hmp=qc_num(:,32);
wnd_dir_compass=qc_num(:,11);
wnd_spd=qc_num(:,12);
fc_raw_massman_wpl=qc_num(:,21);
HSdry_massman=qc_num(:,28);
HL_wpl_massman=qc_num(:,30);
soil_heat_flux_1=qc_num(:,34);
soil_heat_flux_2=qc_num(:,35);
Tsoil_hfp=qc_num(:,33);
precip=qc_num(:,36);
rH=qc_num(:,38);
atm_press=qc_num(:,37);
CO2_mean=qc_num(:,13);
NR_tot=qc_num(:,46);
Par_Avg=qc_num(:,39);
sw_incoming=qc_num(:,40);
sw_outgoing=qc_num(:,41);
lw_incoming=qc_num(:,42);
lw_outgoing=qc_num(:,43);
E_wpl_massman=qc_num(:,26);
H2O_mean=qc_num(:,15);
       
    dummy(year>0)=-9999;
    dummy=dummy';
    intjday=int16(jday);
    intjday=double(intjday);
    jdayout(dummy==-9999)=(1/48);
    jdayout=(cumsum(jdayout)+1)';
           
% Site specific soil met properties.

if sitecode == 1 % Grassland
        if year(1)==2007
        Tsoil_1=Tsoil_hfp;
        Tsoil_2=data(:,213); % deep well 10 cm
        Tsoil_3=dummy;
        % Soil water content calculations from microsecond period
        x = (data(:,165:187));
        x_tc_2nd=(0.526-0.052.*x+0.00136.*(x.*x));
        TS=(20-Tsoil_hfp); TS=repmat(TS,1,size(x_tc_2nd,2));
        x_tc=x+TS.*x_tc_2nd;
        vwc=repmat(-0.0663,(size(x_tc)))-0.00636.*x_tc+0.0007.*(x_tc.*x_tc); % temperature corrected
        vwc2=repmat(-0.0663,(size(x)))-0.00636.*x+0.0007.*(x.*x); % not temperature corrected 
        vwc(vwc>1)=NaN; vwc(vwc<0)=NaN;
        vwc2(vwc2>1)=NaN; vwc2(vwc2<0)=NaN;
        SWC_1=nanmean(cat(2,vwc(:,1),vwc(:,4),vwc(:,7),vwc(:,10),vwc(:,13),vwc(:,18))'); SWC_1=SWC_1';
        SWC_2=nanmean(cat(2,vwc2(:,3),vwc2(:,6),vwc2(:,9),vwc2(:,12),vwc2(:,15),vwc2(:,20))'); SWC_2=SWC_2';
        SWC_3=nanmean(cat(2,vwc2(:,17),vwc2(:,22))'); SWC_3=SWC_3';
        figure; 
        aa = gcf
        subplot(2,1,1)
        plot(vwc)
        vwc=data(:,188:210);
        vwc(vwc>1)=NaN; vwc(vwc<0)=NaN;
        SWC_21=nanmean(cat(2,vwc(:,1),vwc(:,4),vwc(:,7),vwc(:,10),vwc(:,13),vwc(:,18))'); SWC_21=SWC_1';
        SWC_22=nanmean(cat(2,vwc(:,3),vwc(:,6),vwc(:,9),vwc(:,12),vwc(:,15),vwc(:,20))'); SWC_22=SWC_2';
        SWC_23=nanmean(cat(2,vwc(:,17),vwc(:,22))'); SWC_23=SWC_3';
        figure(aa)
        subplot(2,1,2)
        plot(SWC_1); hold on; plot(SWC_2,'r'); hold on; plot(SWC_3,'g'); hold on
        plot(SWC_21,'o'); hold on; plot(SWC_22,'ro'); hold on; plot(SWC_23,'go')
        SWC_1(1:8000)=SWC_21(1:8000);
        SWC_2(1:8000)=SWC_22(1:8000);
        SWC_3(1:8000)=SWC_23(1:8000);
        
        elseif year(1) ==2008
        Tsoil_1=Tsoil_hfp;
        Tsoil_2=data(:,216); % deep well 10 cm
        Tsoil_3=dummy;
        % Soil water content calculations from microsecond period
        x = (data(:,165:187));
        x_tc_2nd=(0.526-0.052.*x+0.00136.*(x.*x));
        TS=(20-Tsoil_hfp); TS=repmat(TS,1,size(x_tc_2nd,2));
        x_tc=x+TS.*x_tc_2nd;
        vwc=repmat(-0.0663,(size(x_tc)))-0.00636.*x_tc+0.0007.*(x_tc.*x_tc); % temperature corrected
        vwc2=repmat(-0.0663,(size(x)))-0.00636.*x+0.0007.*(x.*x); % not temperature corrected 
        vwc(vwc>1)=NaN; vwc(vwc<0)=NaN;
        vwc2(vwc2>1)=NaN; vwc2(vwc2<0)=NaN;
        SWC_1=nanmean(cat(2,vwc(:,1),vwc(:,4),vwc(:,7),vwc(:,10),vwc(:,13),vwc(:,18))'); SWC_1=SWC_1';
        SWC_2=nanmean(cat(2,vwc2(:,3),vwc2(:,6),vwc2(:,9),vwc2(:,12),vwc2(:,15),vwc2(:,20))'); SWC_2=SWC_2';
        SWC_3=nanmean(cat(2,vwc2(:,17),vwc2(:,22))'); SWC_3=SWC_3';
    
        end
        
        % Calculate ground heat flux
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=vwc(:,23); theta(isnan(theta))=SWC_1(isnan(theta)); theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1398; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground=shf+storage;
        figure; plot(ground);
             
        
elseif sitecode == 2 % Shrubland
    if year(1) < 2009
        Tsoil_1=Tsoil_hfp;
        Tsoil_2=dummy;
        Tsoil_3=dummy;
        % Soil water content calculations from microsecond period
        x = (data(:,165:186));
        x_tc_2nd=(0.526-0.052.*x+0.00136.*(x.*x));
        TS=(20-Tsoil_hfp); TS=repmat(TS,1,size(x_tc_2nd,2));
        x_tc=x+TS.*x_tc_2nd;
        vwc=repmat(-0.0663,(size(x_tc)))-0.00636.*x_tc+0.0007.*(x_tc.*x_tc); % temperature corrected
        vwc2=repmat(-0.0663,(size(x)))-0.00636.*x+0.0007.*(x.*x); % not temperature corrected
        %        
        SWC_1=nanmean(cat(2,vwc(:,1),vwc(:,6),vwc(:,11),vwc(:,16))'); SWC_1=SWC_1';
        SWC_2=nanmean(cat(2,vwc2(:,3),vwc2(:,8),vwc(:,13),vwc2(:,18))'); SWC_2=SWC_2';
        SWC_3=nanmean(cat(2,vwc2(:,5),vwc2(:,10),vwc(:,15),vwc2(:,20))'); SWC_3=SWC_3';
        figure; plot(SWC_1); hold on; plot(SWC_2,'r'); hold on; plot(SWC_3,'g')
        % Calculate ground heat flux
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=vwc(:,21); theta(isnan(theta))=SWC_1(isnan(theta)); theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1327; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground=shf+storage;
        figure; plot(ground);
    end
       
elseif sitecode == 3 % Juniper savannah
   if year(1)==2007
        vwc=data(:,175:190);
        vwc(vwc>1)=NaN; vwc(vwc<0)=NaN;
        SWC_1=nanmean(cat(2,vwc(:,1),vwc(:,5),vwc(:,9),vwc(:,13))'); SWC_1=SWC_1';
        SWC_2=nanmean(cat(2,vwc(:,3),vwc(:,7),vwc(:,11),vwc(:,15))'); SWC_2=SWC_2';
        SWC_3=nanmean(cat(2,vwc(:,4),vwc(:,8),vwc(:,12),vwc(:,16))'); SWC_3=SWC_3';
        
        tt=data(:,191:210);
        Tsoil_1=nanmean(cat(2,tt(:,1),tt(:,6),tt(:,11),tt(:,16))'); Tsoil_1=Tsoil_1';
        Tsoil_2=nanmean(cat(2,tt(:,3),tt(:,8),tt(:,13),tt(:,18))'); Tsoil_2=Tsoil_2';
        Tsoil_3=nanmean(cat(2,tt(:,4),tt(:,9),tt(:,14),tt(:,19))'); Tsoil_3=Tsoil_3';

        % Calculate ground heat flux 2 set ups at JSav
        Tsoil_hfp=data(:,219);
        soil_heat_flux_1=data(:,221);
        soil_heat_flux_2=data(:,222);
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1720; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground1=shf+storage;
        % And for second set up
        Tsoil_hfp=data(:,220);
        soil_heat_flux_1=data(:,223);
        soil_heat_flux_2=data(:,224);
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1720; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground2=shf+storage;
        ground=nanmean(cat(2,ground1,ground2)'); ground=ground';
        
   elseif year(1)==2008
        vwc=data(:,175:190);
        vwc(vwc>1)=NaN; vwc(vwc<0)=NaN;
        SWC_1=nanmean(cat(2,vwc(:,1),vwc(:,5),vwc(:,9),vwc(:,13))'); SWC_1=SWC_1';
        SWC_2=nanmean(cat(2,vwc(:,3),vwc(:,7),vwc(:,11),vwc(:,15))'); SWC_2=SWC_2';
        SWC_3=nanmean(cat(2,vwc(:,4),vwc(:,8),vwc(:,12),vwc(:,16))'); SWC_3=SWC_3';
        
        tt=data(:,191:210);
        Tsoil_1=nanmean(cat(2,tt(:,1),tt(:,6),tt(:,11),tt(:,16))'); Tsoil_1=Tsoil_1';
        Tsoil_2=nanmean(cat(2,tt(:,3),tt(:,8),tt(:,13),tt(:,18))'); Tsoil_2=Tsoil_2';
        Tsoil_3=nanmean(cat(2,tt(:,4),tt(:,9),tt(:,14),tt(:,19))'); Tsoil_3=Tsoil_3';

        % Calculate ground heat flux 2 set ups at JSav
        Tsoil_hfp=data(:,211);
        soil_heat_flux_1=data(:,213);
        soil_heat_flux_2=data(:,214);
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1720; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground1=shf+storage;
        % And for second set up
        Tsoil_hfp=data(:,212);
        soil_heat_flux_1=data(:,215);
        soil_heat_flux_2=data(:,216);
        deltaT=cat(1,Tsoil_hfp,1)-cat(1,1,Tsoil_hfp); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1720; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage=storage/(60*30); % in Wm-2
        shf=nanmean(cat(2,soil_heat_flux_1,soil_heat_flux_2)'); shf=shf';
        ground2=shf+storage;
        ground=nanmean(cat(2,ground1,ground2)'); ground=ground';
   end
        
elseif sitecode == 4 % Pinon-juniper
        Tsoil_1=Tsoil_1;
        Tsoil_2=Tsoil_2;
        Tsoil_3=Tsoil_3;
        SWC_1=dummy;
        SWC_2=dummy;
        SWC_3=dummy;
        soil_heat_flux_1=(soil_heat_flux_1+soil_heat_flux_2)./2;

elseif sitecode == 5  
    if year(1)==2007
        tsoil_2cm=Tsoil_hfp;
        tsoil_6cm=soil_heat_flux_1;
        vwc=soil_heat_flux_2;
    
        Tsoil_1=tsoil_2cm;
        Tsoil_2=tsoil_6cm;
        Tsoil_3=dummy;
        SWC_1=vwc;
        SWC_2=dummy;
        SWC_3=dummy;
        
        deltaT=cat(1,Tsoil_1,1)-cat(1,1,Tsoil_1); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1071; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage1=storage/(60*30); % in Wm-2
        
        deltaT=cat(1,Tsoil_2,1)-cat(1,1,Tsoil_2); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1071; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage2=storage/(60*30); % in Wm-2
                      
        ground=(storage1+storage2);
    elseif year(1)==2008
    end
        
elseif sitecode == 6  
        if year(1)==2007
        tsoil_2cm=Tsoil_hfp;
        tsoil_6cm=soil_heat_flux_1;
        vwc=soil_heat_flux_2;
    
        Tsoil_1=tsoil_2cm;
        Tsoil_2=tsoil_6cm;
        Tsoil_3=dummy;
        SWC_1=vwc;
        SWC_2=dummy;
        SWC_3=dummy;
        
        deltaT=cat(1,Tsoil_1,1)-cat(1,1,Tsoil_1); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1354; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage1=storage/(60*30); % in Wm-2
        
        deltaT=cat(1,Tsoil_2,1)-cat(1,1,Tsoil_2); deltaT=deltaT(2:length(deltaT));
        theta=SWC_1; theta(isnan(theta))= 0.05; % Gapfill soil moisture with other shallow measurements; big gap in soil moisture firstpart of 2007 fill with 0.05
        bulk=1354; scap=837; wcap=4.19e6; depth=0.05; % parameter values
        bulk=bulk.*ones(size(dummy,1),1);
        scap=scap.*ones(size(dummy,1),1);
        wcap=wcap.*ones(size(dummy,1),1);
        depth=depth.*ones(size(dummy,1),1);
        cv=(bulk.*scap)+(wcap.*theta);
        storage=cv.*deltaT.*depth; % in Joules
        storage2=storage/(60*30); % in Wm-2
                      
        ground=(storage1+storage2);
    elseif year(1)==2008
    end
    
    
end
    
    
    years=num2str(year(1,1));
    gf_file=strcat(outfolder,'DataSetafterGapfill_',years,'.txt');
    gf_in=dlmread(gf_file,'',1,0);
    [~, b]=size(gf_in);
    gf_in=cat(1,ones(1,b).*-9999,gf_in); % Add an extra row on top as for some reason gf file starts at 1am.
    pt1_file=strcat(outfolder,'DataSetafterFluxpart_',years,'.txt');
    pt1_in=dlmread(pt1_file,'',1,0);
    [~, b]=size(pt1_in);
    pt1_in=cat(1,ones(1,b).*-9999,pt1_in); % Add an extra row on top as for some reason gf file starts at 1am.    
    pt2_file=strcat(outfolder,'DataSetafterFluxpartGL2010_',years,'.txt');
    pt2_in=dlmread(pt2_file,'',1,0);
    [~, b]=size(pt2_in);
    pt2_in=cat(1,ones(1,b).*-9999,pt2_in); % Add an extra row on top as for some reason gf file starts at 1am.
    
   % use new partitioning
    NEE_f=pt2_in(:,9);
    RE_f =pt2_in(:,6);
    GPP_f=pt2_in(:,7);
    VPD_f=gf_in(:,18);
    Tair_f=gf_in(:,35);
    Rg_f=gf_in(:,42);
    LE_f=gf_in(:,28);
       
    RE = dummy;
    GPP = dummy;
    VPD = dummy;
    
    f_flag=dummy+10000;
    
    TA_flag=f_flag;
    TA_flag(~isnan(air_temp_hmp))=0; 
    Rg_flag=f_flag;
    Rg_flag(~isnan(sw_incoming))=0;
    VPD_flag=f_flag;
    VPD_flag(~isnan(rH))=0;
    NEE_flag=f_flag;
    NEE_flag(~isnan(fc_raw_massman_wpl))=0;
    LE_flag=f_flag;
    LE_flag(~isnan(E_wpl_massman))=0;
        
    RE(~isnan(fc_raw_massman_wpl)) = RE_f(~isnan(fc_raw_massman_wpl));
    GPP(~isnan(fc_raw_massman_wpl)) = GPP_f(~isnan(fc_raw_massman_wpl));
    VPD(~isnan(rH))=VPD_f(~isnan(rH));
    HL_wpl_massman(isnan(E_wpl_massman))=NaN;
    

     
        %data with gaps
        if sitecode==1
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2.5cm','TS_10cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','SWC_2.5cm','SWC_22.5cm','SWC_52.5cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'};
        elseif sitecode ==2
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2.5cm','TS_2','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','SWC_2.5cm','SWC_22.5cm','SWC_52.5cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'};            
        elseif sitecode ==3
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2cm','TS_8cm','TS_16cm','PRECIP','RH','PA','CO2',...
            'VPD','SWC_5cm','SWC_20cm','SWC_40cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'}; 
        elseif sitecode ==4
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','SWC_1','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'}; 
        elseif sitecode ==5
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','SWC_2.5','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'}; 
        elseif sitecode ==6
        header1 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','WD','WS','NEE','FC',...
            'SFC','H','SSA','LE','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','SWC_2.5cm','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','GPP','APAR'}; 
        end
        units1 = {'-','-','-','-','m/s','deg C','deg','m/s','mumol/m2/s','mumol/m2/s',...
            'mumol/m2/s','W/m2','W/m2','W/m2','W/m2','W/m2','deg C','deg C','deg C','mm','%','kPA','mumol/mol',...
            'kPA','m3/m3','W/m2','mumol/m2/s','mumol/m2/s','mumol/m2/s','W/m2','W/m2','W/m2',...
            'W/m2','W/m2','mg/m2/s','mmol/mol','mumol/m2/s','mumol/m2/s','mumol/m2/s'};
        datamatrix3 = [year,intjday,(hour.*100)+minute,jdayout,u_star,air_temp_hmp,wnd_dir_compass,wnd_spd,...
            dummy,fc_raw_massman_wpl,dummy,HSdry_massman,dummy,HL_wpl_massman,dummy,ground,...
            Tsoil_1,Tsoil_2,Tsoil_3,precip,rH.*100,atm_press,CO2_mean,VPD,SWC_1,SWC_2,SWC_3,NR_tot,Par_Avg,dummy,dummy,sw_incoming,...
            dummy,sw_outgoing,lw_incoming,lw_outgoing,E_wpl_massman./0.018,H2O_mean,RE,GPP,dummy];
        datamatrix3(isnan(datamatrix3))=-9999;

        % Gap filled data
        if sitecode==1
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2.5cm','TS_10cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_2.5cm','SWC_22.5cm','SWC_52.5cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};
        elseif sitecode==2
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2.5cm','TS_2','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_2.5cm','SWC_22.5cm','SWC_52.5cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};     
        elseif sitecode==3
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2cm','TS_8cm','TS_16cm','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_5cm','SWC_20cm','SWC_40cm','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};   
        elseif sitecode==4
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_1','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};   
        elseif sitecode==5
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_2.5cm','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};   
        elseif sitecode==6
        header2 = {'YEAR','DOY','HRMIN','DTIME','UST','TA','TA_flag','WD','WS','NEE','FC','FC_flag',...
            'SFC','H','SSA','LE','LE_flag','SLE','G1','TS_2cm','TS_6cm','TS_3','PRECIP','RH','PA','CO2',...
            'VPD','VPD_flag','SWC_2.5cm','SWC_2','SWC_3','RNET','PAR','PAR_DIFF','PAR_out','Rg','Rg_flag','Rg_DIFF','Rg_out',...
            'Rlong_in','Rlong_out','FH2O','H20','RE','RE_flag','GPP','GPP_flag','APAR'};   
        end
            
        units2 = {'-','-','-','-','m/s','deg C','-','deg','m/s','mumol/m2/s','mumol/m2/s','-',...
            'mumol/m2/s','W/m2','W/m2','W/m2','-','W/m2','W/m2','deg C','deg C','deg C','mm','%','kPA','mumol/mol',...
            'kPA','-','m3/m3','m3/m3','m3/m3','W/m2','mumol/m2/s','mumol/m2/s','mumol/m2/s','W/m2','-','W/m2','W/m2',...
            'W/m2','W/m2','mg/m2/s','mmol/mol','mumol/m2/s','-','mumol/m2/s','-','mumol/m2/s'};
        datamatrix4 = [year,intjday,(hour.*100)+minute,jdayout,u_star,Tair_f,TA_flag,wnd_dir_compass,wnd_spd,...
            dummy,NEE_f,NEE_flag,dummy,HSdry_massman,dummy,LE_f,LE_flag,dummy,ground,...
            Tsoil_1,Tsoil_2,Tsoil_3,precip,rH.*100,atm_press,CO2_mean,VPD_f,VPD_flag,SWC_1,SWC_2,SWC_3,NR_tot,Par_Avg,dummy,dummy,Rg_f,Rg_flag,...
            dummy,sw_outgoing,lw_incoming,lw_outgoing,E_wpl_massman./0.018,H2O_mean,RE_f,NEE_flag,GPP_f,NEE_flag,dummy];
            datamatrix4(isnan(datamatrix4))=-9999; 
        
  
time_out=fix(clock);
time_out=datestr(time_out);


% sitecode key
afnames(1,:) = 'US-Seg'; % 1-GLand
afnames(2,:) = 'US-Ses'; % 2-SLand
afnames(3,:) = 'US-Wjs'; % 3-JSav
afnames(4,:)='US-Mpj'; % 4-PJ
afnames(5,:)='US-Vcp'; % 5-PPine
afnames(6,:)='US-Vcm'; % 6-MCon
afnames(7,:)='US-FR2'; % 7-TX_savanna
% 8-TX_forest
% 9-TX_grassland

sname={'Site name: ',afnames(sitecode,:)};
email={'Email: mlitvak@unm.edu'};
timeo={'Created: ',time_out};
    outfilename = strcat(outfolder,afnames(sitecode,:),'_',years,'_with_gaps.xls');
    xlswrite(outfilename,sname,'data','A1');
    xlswrite(outfilename,email,'data','A2');
    xlswrite(outfilename,timeo,'data','A3');
    xlswrite(outfilename,header1,'data','A4');
    xlswrite(outfilename,units1,'data','A5');
    xlswrite(outfilename,datamatrix3,'data','A6');    

    
    outfilename = strcat(outfolder,afnames(sitecode,:),'_',years,'_gapfilled.xls');
    xlswrite(outfilename,sname,'data','A1');
    xlswrite(outfilename,email,'data','A2');
    xlswrite(outfilename,timeo,'data','A3');
    xlswrite(outfilename,header2,'data','A4');
    xlswrite(outfilename,units2,'data','A5');
    xlswrite(outfilename,datamatrix4,'data','A6');
    
    
   

    