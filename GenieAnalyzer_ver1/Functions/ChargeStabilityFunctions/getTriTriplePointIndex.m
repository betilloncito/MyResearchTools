function [ triplePointIndex ] = getTriTriplePointIndex( triPts )
%GETTRITRIPLEPOINT Finds the electron triple point for an inputted bias
%triangle

    % Check which bias triangle case we are in and select correct index
    if ((triPts(4)-triPts(2))/(triPts(3)-triPts(1))*(triPts(5) - triPts(1)) + triPts(2)) <= triPts(6)
        triplePointIndex = 2;
    else
        triplePointIndex = 1;
    end
end