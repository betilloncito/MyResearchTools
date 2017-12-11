function [ slope ] = getTriMainSlopePoints(tri_pts)
    % Figure out which pair of points determine the dy/dx slope to shift
    % our triangle.  Do this by seeing which slope is closest to +1.  I am
    % trying to phase out using this function by making the common
    % convention that [1,2] dictates the main slope.. But still this could
    % be useful if we automate more later
%     min_dis = 1e10;
%     for ii = 1:3
%         for jj = 1:3
%             if ii == jj 
%                 continue
%             end
%             curr_slope = (tri_pts(ii*2)-tri_pts(jj*2))/(tri_pts(ii*2-1)-tri_pts(jj*2-1));
%             if curr_slope < 0
%                 continue
%             end
%             if abs(curr_slope - 1) < min_dis
%                 slope = [ii jj];
%                 min_dis = abs(curr_slope - 1);
%             end
%         end
%     end
    
    slope = [1,2];
end
