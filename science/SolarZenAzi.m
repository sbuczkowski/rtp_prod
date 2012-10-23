function [Zen Azi] = SolarZenAzi(UTC,Lat,Lon,Alt)
% External Function Call Sequence:
%[Zen Azi] = SolarZenAzi(datenum('1991/05/19 13:00:00'),50,10,0)
%
% Function Description:
% SolarZenAzi will ingest a Universal Time, and specific site location on earth
% it will then output the solar Azimuth and Elevation angles relative to that
% site.
%
%Input Description:
% UTC (Coordinated Universal Time YYYY/MM/DD hh:mm:ss)
% Lat (Site Latitude in degrees -90:90 -> S(-) N(+))
% Lon (Site Longitude in degrees -180:180 W(-) E(+))
% Altitude of the site above sea level (km)
%
%Output Description:
%Azi (Azimuth location of the sun in degrees)
%Zen (Zenith location of the sun in degrees)

%Source References:
%Solar Position obtained from:
%http://stjarnhimlen.se/comp/tutorial.html#5

% Programed by Darin C. Koblick 2/17/2009
% Code Sequence

%compute JD
jd = UTC + 1721058.5;
d = jd-2451543.5;

% Keplerian Elements for the Sun (geocentric)
w = 282.9404+4.70935e-5*d; %    (longitude of perihelion degrees)
a = 1.000000;%                  (mean distance, a.u.)
e = 0.016709-1.151e-9*d;%       (eccentricity)
M = mod(356.0470+0.9856002585*d,360);%   (mean anomaly degrees)
L = w + M;                     %(Sun's mean longitude degrees)
oblecl = 23.4393-3.563e-7.*d;  %(Sun's obliquity of the ecliptic)

%auxiliary angle
E = M+(180/pi).*e.*sin(M.*(pi/180)).*(1+e*cos(M.*(pi/180)));

%rectangular coordinates in the plane of the ecliptic (x axis toward
%perhilion)
x = cos(E.*(pi/180))-e;
y = sin(E.*(pi/180)).*sqrt(1-e.^2);

%find the distance and true anomaly
r = sqrt(x.^2 + y.^2);
v = atan2(y,x).*(180/pi);

%find the longitude of the sun
lon = v + w;

%compute the ecliptic rectangular coordinates
xeclip = r.*cos(lon.*(pi/180));
yeclip = r.*sin(lon.*(pi/180));
zeclip = 0.0;

%rotate these coordinates to equitorial rectangular coordinates
xequat = xeclip;
yequat = yeclip.*cos(oblecl.*(pi/180))+zeclip*sin(oblecl.*(pi/180));
zequat = yeclip.*sin(23.4406.*(pi/180))+zeclip*cos(oblecl.*(pi/180));

%convert equatorial rectangular coordinates to RA and Decl:
r = sqrt(xequat.^2 + yequat.^2 + zequat.^2)-(Alt/149598000); %roll up the altitude correction
RA = atan2(yequat,xequat).*(180/pi);
delta = asin(zequat./r).*(180/pi);

%Following the RA DEC to Az Alt conversion sequence explained here:
%http://www.stargazing.net/kepler/altaz.html

%Find the J2000 value
J2000 = jd - 2451545.0;
UTH = mod(UTC,1)*24;

%Calculate local siderial time
GMST0=mod(L+180,360)/15;
SIDTIME = GMST0 + UTH + Lon/15;

%Replace RA with hour angle HA
HA = (SIDTIME*15 - RA);

%convert to rectangular coordinate system
x = cos(HA.*(pi/180)).*cos(delta.*(pi/180));
y = sin(HA.*(pi/180)).*cos(delta.*(pi/180));
z = sin(delta.*(pi/180));

%rotate this along an axis going east-west.
xhor = x.*cos((90-Lat).*(pi/180))-z.*sin((90-Lat).*(pi/180));
yhor = y;
zhor = x.*sin((90-Lat).*(pi/180))+z.*cos((90-Lat).*(pi/180));

%Find the h and AZ 
Azi = atan2(yhor,xhor).*(180/pi) + 180;
Zen = 90 - asin(zhor).*(180/pi);

