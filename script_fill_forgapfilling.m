% script to fill for_gapfill files from nearby sites

draw_plots = true;
regress_on = true;
regress_off = false;

y = 2008;

for y = 2011
    %UNM_fill_met_gaps_from_nearby_site( 1, y, draw_plots, ...
    %                                    [ false false false ] )
    UNM_fill_met_gaps_from_nearby_site( 2, y, draw_plots, ...
                                        [ false false false ] )
    % UNM_fill_met_gaps_from_nearby_site( 3, y, draw_plots, ...
    %                                     [ true true true ] )
    UNM_fill_met_gaps_from_nearby_site( 4, y, draw_plots, ...
                                        [ false false false ])
    % UNM_fill_met_gaps_from_nearby_site( 5, y, draw_plots, ...
    %                                     [ false false true ] )
    UNM_fill_met_gaps_from_nearby_site( 6, y, draw_plots, ...
                                        [ false false true ])
    % UNM_fill_met_gaps_from_nearby_site( 10, y, draw_plots, ...
    %                                     [ false false false ] )
end

% UNM_fill_met_gaps_from_nearby_site( 11, 2010, draw_plots, ...
%                                     [ false false true ] )
