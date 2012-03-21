args = UNM_data_feeder( 'TX', ...
                        'year_start', 2011, ...  
                        'cmon_start', 3, ...
                        'cday_start', 29, ...
                        'hour_start', 14, ...
                        'min_start', 11, ...
                        'year_end', 2011, ...
                        'cmon_end', 5, ...
                        'cday_end', 1 );
%args_xls = UNM_data_feeder('GLand', 'input_from_excel', true); 

fnames = get_ts_file_names('TX', args.date_start, args.date_end);
%fnames = {'/tmp/TOB1_TX_2011_03_30_0000.DAT', '/tmp/TOB1_TX_2011_03_30_0000.DAT'};
[date, hr, fco2out, tdryout, hsout, hlout, iokout] = ...
    UNM_data_processor(fnames{1}, args.date_start, ...
                       args.site, args.figures, args.rotation, 0, ...
                       args.writefluxall);

% [infile_names, all_dates] = UNM_filebuilder(args.site, args.date_start, args.date_end);

% for i = 1:5
%   UNM_data_processor(infile_names{i}, all_dates(i), args.site, args.figures, ...
% 		     args.rotation, args.lag_nsteps, args.writefluxall);
% end
