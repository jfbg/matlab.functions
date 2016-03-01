function [P SV] = rotPSV_ang(R,Z,ang)

% Rotate signals based on incident angle (counterclockwise)

if size(R,2) > size(R,1), R = R'; end
if size(Z,2) > size(Z,1), Z = Z'; end

dcos = [cosd(90+ang) -sind(90+ang);
         sind(90+ang)  cosd(90+ang)];

S1 = [R';Z'];
S2 = NaN(size(S1));

for i=1:length(S1)
    S2(:,i) = dcos*S1(:,i);
end

P = S2(1,:);
SV = S1(2,:);
