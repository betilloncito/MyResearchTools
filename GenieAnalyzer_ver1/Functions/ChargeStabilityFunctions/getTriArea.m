function [ area ] = getTriArea(pts)
    % Find the area of the bias triangle for a given set of tri pts
    x = [pts(1) pts(3) pts(5)];
    y = [pts(2) pts(4) pts(6)];

    area = polyarea(x,y);
end
