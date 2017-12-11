function [ thresh ] = getCurrentThreshold( current )
%GETCURRENTTHRESHOLD makes a histrogram of all the current values.  It then
%selects an appropriate threshold for saying when there is current/no
%current.
    
    nbins = 100;
    [values, edges] = histcounts(current,nbins);
	threshold_bin = 5; % In case there's an error in the threshold guessing, just pick 5% of the max current
    
    total = sum(values);
    curr_sum = 0;
	relPercentThresh = 0.05;
    % Loop through each bin and sum up the total number of current points
    % in the bins going from 0 -> max current.  When stepping each bin,
    % find how much the percentage of current points binned is changing as
    % adding bins are increasing.  When this percentage is not increasing
    % by more than n%, we will call that bin our threshold current.
    for ii = 1:length(values)
        old_per = curr_sum/total;
        curr_sum = curr_sum + values(ii);
        curr_per = curr_sum/total;
        if (curr_per - old_per) < relPercentThresh
            threshold_bin = ii;
            break;
        end
    end
    
    thresh = edges(threshold_bin);
end

