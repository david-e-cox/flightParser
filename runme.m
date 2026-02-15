

% Read IGC file, plot lat,lon and alt
[lat,lon,altPres,altGPS, hour,min,sec, fix3D,latD,lonD, extData]=readIGC('./data/shortFlight.igc');

% Read UDP file, plot lat,lon and alt
D = readUDP('./data/UDPlog_20260205_200ftar-3.txt');



% These could be in defined in ~/.octaverc (Edit->Preferences->General)
% Defaults for plotting
set(groot,'DefaultLineLineWidth',1.5);
set(groot,'DefaultAxesLineWidth',2);
set(groot,'DefaultAxesFontSize',16);
% Defaults for display 
struct_levels_to_print(0)

% Plot some IGC file data
h1=figure(1);,clf
subplot(1,2,1),
plot3(lat,lon,altGPS)
xlabel('Latitude');ylabel('Longitude');zlabel('Altitude');
grid on
subplot(1,2,2),
t = hour*3600+min*60+sec;t = t-t(1);
plot(t,altPres, t, altGPS);
legend('Pressure','GPS');
xlabel('Time,  sec'),ylabel('Altitude');
grid on
% Trying to force plot to resize and reposition
drawnow;set(h1,'Position',[100 100 1200 500]);refresh(h1);


% Plot some UDP file data
h2=figure(2);,clf,
subplot(1,2,1),
plot(D.time, D.pitchrate)
xlabel('Time, sec');ylabel('pitchrate');
grid on
subplot(1,2,2),
plot(D.time,D.gforce)
xlabel('Time, sec');ylabel('gforce');
grid on
% Trying to force plot to resize and reposition
drawnow;set(h2,'Position',[100 100 1200 500]);refresh(h2);
