function [ dx, dy ] = getTriDxDy(tri_pts, linepts)
    % Used in a couple other functions to find the dx and dy components of
    % a slope based on some linepoints for a bias triangle
    dx = tri_pts(7);
    dy = (tri_pts(linepts(1)*2)-tri_pts(linepts(2)*2))/(tri_pts(linepts(1)*2-1)-tri_pts(linepts(2)*2-1))*dx;
end
