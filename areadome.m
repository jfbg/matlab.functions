function area = areadome(distA,radius)

% FUNCTION area = areadome(dist,radius)
%
% This function outputs the area on a sphere delimited by a given
% epicentral distance (dist). It also requires de radius of the sphere.
% Distance should be in degrees.
%
% Output is in same units as inputed radius.

area = nan(size(distA));
At = 4*pi*radius^2;         % Sphere area
halfarea = At/2;

for ii = 1:length(distA)
    
    dist = distA(ii);

    % For dist <= 90
    if dist > 90;
        dist1 = 90;
    else
        dist1 = dist;
    end

    
    h = radius*(1 - sind(90-dist1));

    area(ii) = 2*pi*h*radius;

    if dist > 90
        dist2 = dist-90;
        h2 = radius - radius*sind(dist2);
        area2 = halfarea - 2*pi*h2*radius;

        area(ii) = area(ii)+area2;

    end
end
    
    
return    