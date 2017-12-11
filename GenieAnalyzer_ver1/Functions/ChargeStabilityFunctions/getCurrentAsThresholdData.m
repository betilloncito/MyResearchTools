function [ CZthresh ] = getCurrentAsThresholdData( CZ, thresh )
%GETCURRENTASTHRESHOLDDATA Takes in the current data and a threshold for
%the current.  It returns the data as simply a 0 or 1 depending on if the
%current is above or below threshold.
    
    [rows, cols] = size(CZ);
    CZthresh = zeros(rows,cols);
    for ii = 1:rows
        for jj = 1:cols
            if abs(CZthresh(ii,jj)) >= thresh
                CZthresh(ii,jj) = 1;
            else
                CZthresh(ii,jj) = 0;
            end
        end
    end
end

