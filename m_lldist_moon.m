function [dist,dlat,dlon] = m_lldist_moon(long,lat,N)
% M_LLDIST Spherical moon distance between points in long/lat coordinates. 
%   RANGE=M_LLDIST(LONG,LAT) gives the distance in kilometers between
%   successive points in the vectors LONG and LAT, computed
%   using the Haversine formula on a spherical moon of radius
%   1737.4 km. Distances are probably good to better than 1% of the
%   "true" distance on the ellipsoidal moon
%
%   [RANGE,dlat,LONGS,LATS]=M_LLDIST(LONG,LAT,N) computes the N-point geodesics
%   between successive points. Each geodesic is returned on its
%   own row of length N+1.
%
%   See also M_XYDIST
%
%   MODIFIED FROM m_lldist.m by JFBG on MAR-22-2010.
%       All I have done was to change the radius value to 1737.4 km.

% Rich Pawlowicz (rich@ocgy.ubc.ca) 6/Nov/00
% This software is provided "as is" without warranty of any kind. But
% it's mine, so you can't sell it.
%
% 30/Dec/2005 - added n-point geodesic computations, based on an algorithm
%               coded by Jeff Barton at Johns Hopkins APL in an m-file
%               I looked at mathworks.com.


pi180=pi/180;
moon_radius=1737.4;

m=length(long)-1;

long1=reshape(long(1:end-1),m,1)*pi180;
long2=reshape(long(2:end)  ,m,1)*pi180;
lat1= reshape(lat(1:end-1) ,m,1)*pi180;
lat2= reshape(lat(2:end)   ,m,1)*pi180;

dlon = long2 - long1; 
dlat = lat2 - lat1; 
a = (sin(dlat/2)).^2 + cos(lat1) .* cos(lat2) .* (sin(dlon/2)).^2;
angles = 2 * atan2( sqrt(a), sqrt(1-a) );
dist = moon_radius * angles;


