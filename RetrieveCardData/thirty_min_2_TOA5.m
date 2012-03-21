function [success, toa5_fname] = thirty_min_2_TOA5(site, raw_data_dir)
% THIRTY_MIN_2_TOA5 - convert the thirty minute file (*.flux.dat) to a TOA5
% file

    success = true;
    
    thirty_min_file = dir(fullfile(raw_data_dir, '*.flux.dat'));
    ts_data_file = dir(fullfile(raw_data_dir, '*.ts_data.dat'));
    toa5_data_dir = fullfile(get_site_directory(get_site_code(site)), 'toa5');
    if isempty(thirty_min_file)
        error('There is no thirty-minute data file in the given directory');
    elseif length(thirty_min_file) > 1
        error('There are multiple thirty-minute data files in the given directory');
    else
        %create a temporary directory for the TOA5 output
        output_temp_dir = tempname();
        mkdir(output_temp_dir);
        
        %create the configuration file for CardConvert
        toa5_ccf_file = tempname();
        ccf_success = build_TOA5_card_convert_ccf_file(toa5_ccf_file, ...
                                                       raw_data_dir, ...
                                                       output_temp_dir);
        card_convert_exe = fullfile('C:', 'Program Files (x86)', 'Campbellsci', ...
                                    'CardConvert', 'CardConvert.exe');
        card_convert_cmd = sprintf('"%s" "runfile=%s"', ...
                                   card_convert_exe, ...
                                   toa5_ccf_file);

        % card convert will try to apply the ccf file to every .dat file in
        % the directory.  We want to use a different ccf file for the TS
        % data, so temporarily change the .dat extension so CardConvert will
        % ignore it for now.
        ts_file_ignore = fullfile(raw_data_dir, ...
                                  strrep(ts_data_file.name, '.dat', '.donotconvert'));
        sprintf('%s --> %s\n', fullfile(raw_data_dir, ts_data_file.name), ...
                ts_file_ignore);
        ts_file_fullpath = fullfile(raw_data_dir, ts_data_file.name);        
        % matlab's movefile takes minutes to rename a 2 GB ts data file.  The
        % java method does it instantly though
        move_success = ...
            java.io.File(ts_file_fullpath).renameTo(java.io.File(ts_file_ignore));
        success = success & move_success;
        if not(move_success)
            error('thirty_min_2_TOA5:rename_fail', 'renaming TS data file failed');
        end

        % run CardConvert
        [convert_status, result] = system(card_convert_cmd);
        success = success & (convert_status == 0);
        if convert_status ~= 0
            error('thirty_min_2_TOA5:CardConvert', 'CardConvert failed');
        end
        
        %restore the .dat extension on the TS data file
        move_success = ...
            java.io.File(ts_file_ignore).renameTo(java.io.File(ts_file_fullpath));
        success = success & move_success;
        if not(move_success)
            error('thirty_min_2_TOA5:rename_fail',...
                  'restoring TS data .dat extension failed');
        end
        
        %rename the TOA5 file according to the site and place it in the
        %site's TOA5 directory
        default_root = sprintf('TOA5_%s',...
                                char(regexp(thirty_min_file.name, ...
                                            '[0-9]*\.flux', 'match')));
        default_name = dir(fullfile(output_temp_dir, [default_root, '*']));
        newname = strrep(default_name.name, default_root, sprintf('TOA5_%s', site));
        default_fullpath = fullfile(output_temp_dir, default_name.name);
        newname_fullpath = fullfile(toa5_data_dir, newname);
        if exist(newname_fullpath) == 2
            % if file already exists, overwrite it
            delete(newname_fullpath);
        end
        move_success = ...
            java.io.File(default_fullpath).renameTo(java.io.File(newname_fullpath));
        success = move_success & success;
        if not(move_success)
            error('thirty_min_2_TOA5:rename_fail',...
                  'moving TOA5 file to TOA5 directory failed');
        end

        %remove the temporary output directory & CardConvert ccf file
        [rm_success, msgid, msg] = rmdir(output_temp_dir);
        success = rm_success & success;
        %remove the ccf file
        delete(toa5_ccf_file);  %delete seems not to return an output status
    end
    toa5_fname = newname_fullpath;
