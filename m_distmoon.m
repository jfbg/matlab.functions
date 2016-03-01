function [dist] = m_distmoon(long,lat,ILON,ILAT)

% [dist,lons,lats] = m_lldist_moon(long,lat,ILON,ILAT)
%
% long and lat are matrices.
% ILON and ILAT	are longitude and latitude of center of crater.
%	Longitude and latitude of interest, all distances will be calculated
%	based on those coordinates.
%
% dist is a matrix of the same dimension as long and lat (IN METERS).
%
% Based on m_lldist_moon

% [nr nc] = size(long);



pi180=pi/180;
moon_radius=1737400;

% Convert to radians
long = long*pi180;
lat = lat*pi180;
ILON = ILON*pi180;
ILAT = ILAT*pi180;


% long = long(:)*pi180;
% lat = lat(:)*pi180;
% ILON = ILON*pi180;
% ILAT = ILAT*pi180;


% long1=reshape(long(1:end-1),m,1)*pi180;
% long2=reshape(long(2:end)  ,m,1)*pi180;
% lat1= reshape(lat(1:end-1) ,m,1)*pi180;
% lat2= reshape(lat(2:end)   ,m,1)*pi180;

dlon = (ILON - long); 
dlat = (ILAT - lat); 


a = ((sin(dlat/2)).^2 + cos(lat) .* cos(ILAT) .* (sin(dlon/2)).^2);
a(a>1) = 1;
angles = 2 * atan2( sqrt(a), sqrt(1-a) );
dist = moon_radius * angles;

% dist = (reshape(dist1,nr,nc));

