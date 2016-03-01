function makeNDTAU(modelname,radius,z,vp,vs,rho)

% makeND(modelname,radius,z,vp,vs,rho)
%
% Generates and plot ND models using TTBOX.

if length(vp) ~= length(vs)
    error('Lengths of the velocity vectors vp and vs must be the same\n');
end

if nargin == 6
    if length(vp) ~= length(rho)
        error('Length of velocity and rho vectors must be the same.\n');
    end
elseif nargin == 5
    rho = ones(size(vp));
end
    
%% ND
fid = fopen([modelname '.nd'],'w');

fprintf(fid,'!name %s\n',modelname);
fprintf(fid,'!year 2015\n');
fprintf(fid,'!radius %.2f\n',radius);

for ii = 1:length(vp)
    
    fprintf(fid,'%4.6f %2.6f %2.6f %2.6f\n',z(ii),vp(ii),vs(ii),rho(ii));
    
end

fclose(fid);

%% TAU

fid = fopen([modelname '_taup.nd'],'w');

for ii = 1:length(vp)
    
    fprintf(fid,'%4.6f %2.6f %2.6f %2.6f\n',z(ii),vp(ii),vs(ii),rho(ii));
    
end

fclose(fid);

%% Plot
%{
model=mkreadnd([modelname '.nd']);
ttc=mkttcurves(model,0,.5);

figure
mkplotttcurves(ttc,'k');
title(sprintf('%s - Impact',modelname),'Interpreter','none')
ylabel('Time (s)')
xlabel('Epicentral Distance (deg)')

%save Figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [5 8]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 5 8]);
print(gcf, '-dpng', [modelname '_TTbox.png']);
%}
