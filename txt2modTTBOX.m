function txt2modTTBOX(in,model_name,planet_name)



% txt2modTTBOX(TXT,model_name,planet_name)
% 
% TXT is a text file containing info about layers organized as:
% 
% RADIUS      -999        -999    -999    -999
% YEAR        -999        -999    -999    -999
% DEPTH_START DEPTH_END   V_P     V_S     RHO
% DEPTH_START DEPTH_END   V_P     V_S     RHO
% ...
%     
% This creates a .clr file for use with TTBOX.
% The file will be saved in:
% 
% /Users/JF/Documents/UBC/Moon/VelocityModels/

TXT = load(in);

radius = TXT(1,1);
year = TXT(2,1);
TXT(1:2,:) = [];

[nr nc]=size(TXT);

lay = input('Do you want to name the layers (Y/N) ?\n','s');

if strcmp(lay,'Y') == 1
    for i = 1:nr
        names{i,1} = input(sprintf('Name for layer %.0f?\n',i),'s');
    end
else
    for i = 1:nr
        names{i,1} = sprintf('Layer%.0f',i);
    end
end

% Model information

model_folder = '/Users/JF/Documents/UBC/Moon/VelocityModels/';

fid = fopen([model_folder model_name '.clr'],'w');

fprintf(fid,'// %s Seismic velocity model\n',model_name);
fprintf(fid,'//\n');
fprintf(fid,'// Generated automatically on %s\n\n',date);
fprintf(fid,'!name %s\n',model_name);
fprintf(fid,'!year %4.0f\n',year);
fprintf(fid,'!planet !name %s\n',planet_name);
fprintf(fid,'!planet !radius %.2f\n\n',radius);


% Layers information

for i = 1:nr
    fprintf(fid,'!layer !start %s\n',names{i});
    fprintf(fid,'!layer !depth %.2f %.2f\n',TXT(i,1),TXT(i,2));
    fprintf(fid,'!layer !vp %.2f\n',TXT(i,3));
    fprintf(fid,'!layer !vs %.2f\n',TXT(i,4));
    if TXT(i,5) ~= -999
        fprintf(fid,'!layer !rho %.2f\n',TXT(i,5));
    else
    end
    fprintf(fid,'!layer !end\n\n');
end

% Discontinuities information


disc = input('Add a discontinuity (Y/N)?\n','s');

while strcmp(disc,'Y') == 1
    disc_name = input('Name of discontinuity?\n(moho, outer core, innner core)\n','s');
    disc_depth = input(sprintf('Depth of %s?\n',disc_name));
    
    fprintf(fid,'!discon !depth %.2f %s\n',disc_depth,disc_name);
    disc = input('Add a discontinuity (Y/N)?\n','s');
end



fclose(fid);
