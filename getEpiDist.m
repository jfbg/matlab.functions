function [EDdeg, EDkm] = getEpiDist(loc1,loc2)

% [EDdeg, EDkm] = getEpiDist(point1,point2)
%
% Calculate the epicentral distance (ED) between two points on the Moon
%
% point1 = [Colatitude_of_point_1,Longitude_of_point_1]
% point2 = [Colatitude_of_point_2,Longitude_of_point_2]
%
% EDdeg is epicentral distance in degrees
% EDkm is epicentral distance in km

eCL = loc1(1);
eLO = loc1(2);

sCL = loc2(1);
sLO = loc2(2);

EDdeg = acosd(cosd(eCL)*cosd(sCL) + sind(eCL)*sind(sCL)*cosd(sLO - eLO));

moon_radius = 1737.4;
deg = 2*pi*moon_radius/360;

EDkm = EDdeg*deg;
