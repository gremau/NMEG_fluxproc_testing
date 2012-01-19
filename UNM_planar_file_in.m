%program to feed 10Hz data files to other programs for analysis
%DO NOT RUN FOR FILES FROM SEPARATE YEARS
%FILES MUST BE FOR CONSECUTIVE DAYS
%FOR FILES THAT START MIDDAY, MUST ENTER INFO MANUALLY AT BOTTOM 
%works for years 2000-2099.
%modified by Krista 3/11/07
%modified by John DeLong and Marcy Litvak May-July 2008

function[filename,date,jday,site,sitecode,outfolder]=UNM_planar_file_in(drive,sitecode,f_year,f_jday,l_jday,starttime_num,dircode)

starttime_str = num2str(starttime_num);

if starttime_num > 999 
   starttime = strcat(starttime_str,'.DAT');
elseif starttime_num < 1000 && starttime_num ~= 0;
    starttime = strcat('0',starttime_str,'.DAT');
elseif starttime_num == 0
    starttime = '0000.DAT';
end

if f_year== 2008 || f_year==2012 || f_year==2016 ||f_year==2020
    febdays=29; %changes to 29 for leapyear
else
    febdays=28;
end

if sitecode == 1
    site ='GLand'
elseif sitecode == 2
    site = 'SLand'
elseif sitecode == 3
    site = 'JSav'
elseif sitecode == 4
    site = 'PJ'
elseif sitecode == 5
    site = 'PPine'
elseif sitecode == 6
    site = 'MCon'
elseif sitecode == 7
    site = 'TX'
elseif sitecode == 8
    site = 'TX_forest'
elseif sitecode == 9
    site = 'TX_grassland'
elseif sitecode == 10
    site = 'PJ_girdle'    
elseif sitecode == 11
    site = 'New_GLand' 
else
end

filedir=strcat(drive,'\','Research - Flux Towers\', 'Flux Tower Data by Site\' ...
               ,site,'\ts_data\');
%% special version to read TX 2010 data from external hard drive -- TWH Dec 2011
filedir = fullfile( 'i:', 'Raw uncompressed data folders', 'TX Data', 'TX2010', ...
                    'ConvertedCardData' );
outfolder=strcat(drive,'\','Research - Flux Towers\','Flux Tower Data by Site\',...
                 site,'\matlab output\');
sitedir=strcat(drive,'\','Research - Flux Towers\','Flux Tower Data by Site\', ...
               site,'\');
fn_beg='\TOB1_1300.ts_data'; %beginning of filename (before site & date)

fn_end='_0000.DAT'; %end of filename


%calculate number of days (= number of files):
if (f_jday <= l_jday)
    ndays=l_jday-f_jday+1;
end 

datematrix=zeros(ndays, 5);   %column 1- number; column 2- year; column3-month,column4-date column5-julian day

for i=1:ndays
    datematrix(i,1)=i;
    datematrix(i,2)=f_year;     
    jday= f_jday-1+i;
    datematrix(i,5)= jday;
        if (jday <=31)                                    %jan
            datematrix(i,3)=1;
            datematrix(i,4)=jday;
        elseif (jday > 31 && jday<=febdays+31)            %feb
            datematrix(i,3)=2;
            datematrix(i,4)=jday-31;
        elseif (jday > febdays+31 && jday<=febdays+62)     %march
            datematrix(i,3)=3;
            datematrix(i,4)=jday-(febdays+31);
        elseif (jday> febdays+62 && jday<=febdays+92)     %april
            datematrix(i,3)=4;
            datematrix(i,4)=jday-(febdays+62);
        elseif (jday> febdays+92 && jday<=febdays+123)     %may
            datematrix(i,3)=5;
            datematrix(i,4)=jday-(febdays+92);
       elseif (jday>febdays+123 && jday<=febdays+153)     %june
            datematrix(i,3)=6;
            datematrix(i,4)=jday-(febdays+123);
       elseif (jday>febdays+153 && jday<=febdays+184)     %july
            datematrix(i,3)=7;
            datematrix(i,4)=jday-(febdays+153);
       elseif (jday>febdays+184 && jday<=febdays+215)     %august
            datematrix(i,3)=8;
            datematrix(i,4)=jday-(febdays+184);
       elseif (jday>febdays+215 && jday<=febdays+245)     %september
            datematrix(i,3)=9;
            datematrix(i,4)=jday-(febdays+215);
       elseif (jday>febdays+245 && jday<=febdays+276)     %october
            datematrix(i,3)=10;
            datematrix(i,4)=jday-(febdays+245);
      elseif (jday> febdays+276 && jday<=febdays+306)     %november
            datematrix(i,3)=11;
            datematrix(i,4)=jday-(febdays+276);
      elseif (jday>febdays+306 && jday<=febdays+337)     %december
            datematrix(i,3)=12;
            datematrix(i,4)=jday-(febdays+306);
      end          
end

datematrix %prints out the matrix to run to screen

%CREATE VARIABLES TO FEED TO UNM_data_processor:
for i=1:ndays;
%generate filename year, month, and day strings
year_s=int2str(datematrix(i,2));
if (datematrix(i,3) < 10)
    mstr=int2str(datematrix(i,3));
    month_s=strcat('0', mstr);
elseif (datematrix(i,3) >= 10)
    month_s=int2str(datematrix(i,3));
end
date_s=int2str(datematrix(i,4));
if (datematrix(i,4) < 10)
    dstr=int2str(datematrix(i,4));
    date_s=strcat('0', dstr);
elseif (datematrix(i,4) >= 10)
    date_s=int2str(datematrix(i,4));
end

if dircode==0;
    if i==1
        filename=strcat(fn_beg,'_',year_s,'_',month_s,'_',date_s,'_',starttime) %, '.DAT'
    else
        filename=strcat(fn_beg,'_',year_s,'_',month_s,'_',date_s,fn_end)
    end
elseif dircode == 1;
    if i == 1
        filename = strcat(filedir,fn_beg,'_',year_s,'_',month_s,'_',date_s,'_',starttime) %, '.DAT'
       %  filename=strcat(filedir, fn_beg,year_s,'_',month_s,'_',date_s,'_',starttime) %, '.DAT'
    else
        filename = strcat(filedir,fn_beg,'_', year_s,'_',month_s,'_',date_s,fn_end)
      %  filename=strcat(filedir,fn_beg, year_s,'_',month_s,'_',date_s,fn_end)
    end
end

jday = datematrix(i,5);
date = datematrix(i,3)*10000 + datematrix(i,4)*100 + (datematrix(i,2)-2000);

[DATE,hr] = UNM_planar_processor(f_year,filename,date,jday,site,sitecode,sitedir);

end