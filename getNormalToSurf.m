function [n axis_1 axis_2 axis_3] = getNormalToSurf(corners)

    axis_1 = corners(2,:)-corners(1,:);
    axis_1 = axis_1/norm(axis_1);
    
    axis_2 = corners(4,:)-corners(1,:);
    axis_2 = axis_2/norm(axis_2);
    
    axis_3 = cross(axis_1,axis_2);
    axis_3 = axis_3/norm(axis_3);
    
    n=axis_3;
end