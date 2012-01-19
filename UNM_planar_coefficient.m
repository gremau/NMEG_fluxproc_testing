%program to calculate planar rotation coefficeints, as described in Wilczak et al. 2001.
% originally by Krista Anderson Teixeira, Jan 2008
% modified by John DeLong summer 2008.

clear all; clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Choose a binning option and a site code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bin_option = 1; %1 for binning by month, 2 for binning by windspeed, 3 for binning by wind direction, 4 TX 2007, 5 for whole year, 6 two groups by month,
    % 7 binning by wind speed without february, 8 binning by ustar, 9 TX_forest 2007
sitecode = 11;
year = 2010;

%1-GLand (2006-July 2007)
%2-SLand (2006-July2007)
%3-JSav
%4-PJ
%5-PPine
%6-MCon
%7-TX
%8-TX_forest
%9-TX_grassland

drive = 'c:\Research - Flux Towers\Flux Tower Data by Site\';

if sitecode==1;
    filelength_n=17521-1; %for 2007 use 10052
    site='GLand'
    filename = 'GLand_windspeeds';
    min_wind = 30;
    max_wind = 330;
elseif sitecode==2;
    filelength_n=10334-1; 
    site='SLand'
    filename = 'SLand_windspeeds';
    min_wind = 30;
    max_wind = 330;
elseif sitecode==3;
    filelength_n=9361-1; % for 2007 use 11588; for 2008 use 9361
    site='JSav'
    filename = 'JSav_windspeeds';
    min_wind = 15;
    max_wind = 75;    
elseif sitecode==4;
    filelength_n=10774; % 10774 for 2008
    site='PJ'
    filename = 'PJ_windspeeds';
    min_wind = 15;
    max_wind = 75;      
elseif sitecode==5;
    filelength_n=12251-1; % 7825 for 2008
    site='PPine'
    filename = 'PPine_windspeeds';
    min_wind = 109;
    max_wind = 179;    
elseif sitecode==6;
    filelength_n=14271-1; %
    site='MCon'
    filename = 'MCon_windspeeds';
    min_wind = 123;
    max_wind = 183;    
elseif sitecode == 7;
    filelength_n = 10175-1; % for 2007 n = 16955, for 2006 n = 17520, for 2005 n = 
    site = 'TX'
    filename = 'TX_windspeeds';
    min_wind = 296;
    max_wind = 356;
elseif sitecode == 8;
    filelength_n = 16100-1;
    site = 'TX_forest'
    filename = 'TX_forest_windspeeds';
    min_wind = 126;
    max_wind = 186;
elseif sitecode == 9;
    filelength_n = 17518-1;
    site = 'TX_grassland'
    filename = 'TX_grassland_windspeeds';
    min_wind = 90;
    max_wind = 150;
elseif sitecode == 10;
    filelength_n = 5089-1;
    site = 'PJ_girdle'
    filename = 'PJ_girdle_windspeeds';
    min_wind = 15;
    max_wind = 75;
elseif sitecode==11;
    filelength_n=12383; 
    site='New_GLand'
    filename = 'New_GLand_windspeeds';
    min_wind = 30;
    max_wind = 330;
end

filelength=num2str(filelength_n);
filein = strcat(drive,site,'\',filename);
range=strcat('A2:O',filelength);  

%read in 30 min flux data
disp('reading data...')

[num text] = xlsread(filein,num2str(year),range);
data = num;
timestamp=text;
[year month day hour minute second] = datevec(timestamp);

disp('file read');

u = data(:,9);
v = data(:,10);
w = data(:,11);
theta = data(:,12);
windspeed = data(:,13);
%ustar = data(:,14);

u=u';
v=v';
w=w';

if bin_option == 1; %binning by month
    
    for i = 1:12

        mon(i) = i;

        ubin = u(find(month == i & (theta <= max_wind | theta >= min_wind))); ubin = ubin(find(isnan(ubin) == 0));
        vbin = v(find(month == i & (theta <= max_wind | theta >= min_wind))); vbin = vbin(find(isnan(vbin) == 0));
        wbin = w(find(month == i & (theta <= max_wind | theta >= min_wind))); wbin = wbin(find(isnan(wbin) == 0));
        
        flen(i) = length(ubin);

        if flen(i) > 50

            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H=[flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g=[sw suw svw]'; %transpose of g
            x=H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);

        else            
            b0(i) = NaN;
            b1(i) = NaN;
            b2(i) = NaN;

            k3(i) = NaN;
            k1(i) = NaN;
            k2(i) = NaN;       
        end

    end

    out = [mon',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A2:H13');    
    
elseif bin_option == 2; %binning by windspeed
    
    for i = 1:2

        wind(i) = i;

        if i == 1
            ubin = u(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind))); wbin = wbin(find(isnan(wbin) == 0));
        elseif i == 2
            ubin = u(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind))); wbin = wbin(find(isnan(wbin) == 0));            
        end
            flen(i) = length(ubin);

            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H=[flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g=[sw suw svw]'; %transpose of g
            x=H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);
    end

    out = [wind',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A16:H17');
            
elseif bin_option == 3; % binning by wind direction (theta)
    
    for i = 1:12
        
        winddirection(i) = i;
        
        if i == 1
            startbin(i) = 0;
        elseif i > 1
            startbin(i) = i*30;
        end
        endbin(i) = startbin(i) + 30;
        
        ubin = u(find(theta > startbin(i) & theta <= endbin(i))); ubin = ubin(find(isnan(ubin) == 0));
        vbin = v(find(theta > startbin(i) & theta <= endbin(i))); vbin = vbin(find(isnan(vbin) == 0));
        wbin = w(find(theta > startbin(i) & theta <= endbin(i))); wbin = wbin(find(isnan(wbin) == 0));

        flen(i) = length(ubin);

        if flen(i) > 336
            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H=[flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g=[sw suw svw]'; %transpose of g
            x=H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);

        else
            b0(i) = NaN;
            b1(i) = NaN;
            b2(i) = NaN;

            k3(i) = NaN;
            k1(i) = NaN;
            k2(i) = NaN;       
        end

    end
    
    out = [winddirection',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A20:H31');

elseif bin_option == 4; %binning by Jan and Feb versus March and on, with windspeeds for each period (for TX 2007)
    
    for i = 1:3

        period(i) = i;
        
        if i == 1
            ubin = u(find((month == 1 | month == 2) & (theta < 296 | theta > 356))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find((month == 1 | month == 2) & (theta < 296 | theta > 356))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find((month == 1 | month == 2) & (theta < 296 | theta > 356))); wbin = wbin(find(isnan(wbin) == 0));
            
        elseif i == 2
            ubin = u(find((month == 3 | month == 4) & (theta < 296 | theta > 356))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find((month == 3 | month == 4) & (theta < 296 | theta > 356))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find((month == 3 | month == 4) & (theta < 296 | theta > 356))); wbin = wbin(find(isnan(wbin) == 0));            

        elseif i == 3            
            ubin = u(find((month >= 5 & month <= 12) & (theta < 296 | theta > 356))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find((month >= 5 & month <= 12) & (theta < 296 | theta > 356))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find((month >= 5 & month <= 12) & (theta < 296 | theta > 356))); wbin = wbin(find(isnan(wbin) == 0));

        end

            flen(i) = length(ubin);

            if flen > 100

                su=sum(ubin); %sums of velocities
                sv=sum(vbin);
                sw=sum(wbin);

                suv=sum(ubin*vbin'); %sums of velocity products
                suw=sum(ubin*wbin');
                svw=sum(vbin*wbin');
                su2=sum(ubin*ubin');
                sv2=sum(vbin*vbin');

                H = [flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
                g = [sw suw svw]'; %transpose of g
                x = H\g; %matrix left division

                b0(i) = x(1);
                b1(i) = x(2);
                b2(i) = x(3);

                k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
                k1(i) = -b1(i)*k3(i);
                k2(i) = -b2(i)*k3(i);

            else
                b0(i) = NaN;
                b1(i) = NaN;
                b2(i) = NaN;

                k3(i) = NaN;
                k1(i) = NaN;
                k2(i) = NaN;
            end
    end

    out = [period',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A34:H36');
    
elseif bin_option == 5; %5 for whole year

    period = 1;
    flen = length(u);
    
    ubin = u(find(theta <= max_wind | theta >= min_wind)); ubin = u(find(isnan(u) == 0));
    vbin = v(find(theta <= max_wind | theta >= min_wind)); vbin = v(find(isnan(v) == 0));
    wbin = w(find(theta <= max_wind | theta >= min_wind)); wbin = w(find(isnan(w) == 0));
    
    su=sum(ubin); %sums of velocities
    sv=sum(vbin);
    sw=sum(wbin);

    suv=sum(ubin*vbin'); %sums of velocity products
    suw=sum(ubin*wbin');
    svw=sum(vbin*wbin');
    su2=sum(ubin*ubin');
    sv2=sum(vbin*vbin');

    H = [flen su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
    g = [sw suw svw]'; %transpose of g
    x = H\g; %matrix left division

    b0 = x(1);
    b1 = x(2);
    b2 = x(3);

    k3 = 1/(1 + b1^2 + b2^2)^0.5;
    k1 = -b1*k3;
    k2 = -b2*k3;

    out = [period,b0,b1,b2,k1,k2,k3,flen];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A34:H34');
    
elseif bin_option == 6; %splitting the year into sets of two groups by month
    
    for i = 1:2

        period(i) = i;
        
        if i == 1
            ubin = u(find((month >= 1 & month <= 4) & (theta < max_wind | theta > min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find((month >= 1 & month <= 4) & (theta < max_wind | theta > min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find((month >= 1 & month <= 4) & (theta < max_wind | theta > min_wind))); wbin = wbin(find(isnan(wbin) == 0));
            
        elseif i == 2
            ubin = u(find((month >= 6 & month <= 12) & (theta < max_wind | theta > min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find((month >= 6 & month <= 12) & (theta < max_wind | theta > min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find((month >= 6 & month <= 12) & (theta < max_wind | theta > min_wind))); wbin = wbin(find(isnan(wbin) == 0));

        end

            flen(i) = length(ubin);

            if flen > 100

                su=sum(ubin); %sums of velocities
                sv=sum(vbin);
                sw=sum(wbin);

                suv=sum(ubin*vbin'); %sums of velocity products
                suw=sum(ubin*wbin');
                svw=sum(vbin*wbin');
                su2=sum(ubin*ubin');
                sv2=sum(vbin*vbin');

                H = [flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
                g = [sw suw svw]'; %transpose of g
                x = H\g; %matrix left division

                b0(i) = x(1);
                b1(i) = x(2);
                b2(i) = x(3);

                k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
                k1(i) = -b1(i)*k3(i);
                k2(i) = -b2(i)*k3(i);

            else
                b0(i) = NaN;
                b1(i) = NaN;
                b2(i) = NaN;

                k3(i) = NaN;
                k1(i) = NaN;
                k2(i) = NaN;
            end
            clear ubin; clear vbin; clear wbin;
    end

    out = [period',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A34:H35');
    
elseif bin_option == 7; % binning by wind speed without february

    for i = 1:2

        wind(i) = i;

        if i == 1
            ubin = u(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(windspeed >= 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); wbin = wbin(find(isnan(wbin) == 0));
        elseif i == 2
            ubin = u(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(windspeed < 5 & (theta <= max_wind | theta >= min_wind) & month >= 6)); wbin = wbin(find(isnan(wbin) == 0));            
        end
            flen(i) = length(ubin);

            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H=[flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g=[sw suw svw]'; %transpose of g
            x=H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);
    end

    out = [wind',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A16:H17');
    
elseif bin_option == 8; % binning by ustar

    for i = 1:2

        wind(i) = i;

        if i == 1
            ubin = u(find(ustar >= 0.11 & (theta <= max_wind | theta >= min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(ustar >= 0.11 & (theta <= max_wind | theta >= min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(ustar >= 0.11 & (theta <= max_wind | theta >= min_wind))); wbin = wbin(find(isnan(wbin) == 0));
        elseif i == 2
            ubin = u(find(ustar < 0.11 & (theta <= max_wind | theta >= min_wind))); ubin = ubin(find(isnan(ubin) == 0));
            vbin = v(find(ustar < 0.11 & (theta <= max_wind | theta >= min_wind))); vbin = vbin(find(isnan(vbin) == 0));
            wbin = w(find(ustar < 0.11 & (theta <= max_wind | theta >= min_wind))); wbin = wbin(find(isnan(wbin) == 0));            
        end
            flen(i) = length(ubin);

            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H=[flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g=[sw suw svw]'; %transpose of g
            x=H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);
    end

    out = [wind',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A38:H39');
    
elseif bin_option == 9; % TX_forest 2007    
    
    for i = 1:4

        period(i) = i;
        
        startbin(1) = 1; endbin(1) = 60;
        startbin(2) = 61; endbin(2) = 210;
        startbin(3) = 211; endbin(3) = 270;
        startbin(4) = 271; endbin(4) = 360;
        
        ubin = u(find(theta > startbin(i) & theta <= endbin(i))); ubin = ubin(find(isnan(ubin) == 0));
        vbin = v(find(theta > startbin(i) & theta <= endbin(i))); vbin = vbin(find(isnan(vbin) == 0));
        wbin = w(find(theta > startbin(i) & theta <= endbin(i))); wbin = wbin(find(isnan(wbin) == 0));

        flen(i) = length(ubin);

        if flen > 100

            su=sum(ubin); %sums of velocities
            sv=sum(vbin);
            sw=sum(wbin);

            suv=sum(ubin*vbin'); %sums of velocity products
            suw=sum(ubin*wbin');
            svw=sum(vbin*wbin');
            su2=sum(ubin*ubin');
            sv2=sum(vbin*vbin');

            H = [flen(i) su sv; su su2 suv; sv suv sv2]; %create 3 x 3 matrix
            g = [sw suw svw]'; %transpose of g
            x = H\g; %matrix left division

            b0(i) = x(1);
            b1(i) = x(2);
            b2(i) = x(3);

            k3(i) = 1/(1 + b1(i)^2 + b2(i)^2)^0.5;
            k1(i) = -b1(i)*k3(i);
            k2(i) = -b2(i)*k3(i);

        else
            b0(i) = NaN;
            b1(i) = NaN;
            b2(i) = NaN;

            k3(i) = NaN;
            k1(i) = NaN;
            k2(i) = NaN;
        end
        clear ubin; clear vbin; clear wbin;
    end

    out = [period',b0',b1',b2',k1',k2',k3',flen'];
    planar_bk = strcat(drive,site,'\',site,'_coefficients')
    xlswrite(planar_bk,out,num2str(year(10)),'A34:H37');
    
end