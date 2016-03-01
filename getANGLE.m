function [ang dcos] = getANGLE(R,Z)

% Ouput incident angle and direction cosines matrix to rotate the signal

% N = length(R)-1;

% mR = R-mean(R);
% mS = Z-mean(Z);

% C = [sum(mR.*mR)/N sum(mS.*mR)/N;
%      sum(mS.*mR)/N sum(mS.*mS)/N];
 
C = cov(R,Z);

[dcos,e] = eig(C);

% % % % m = find(abs(diag(e)) == abs(min(diag(e))));

% % % % aR = [1 0];
% % % % 
% % % % nPa = v(:,m);
% % % % % v(:,m) = [];
% % % % % nSV = v;

% ang = acosd( dot(aR,nPa) / (norm(aR)*norm(nPa)));

ang = acosd(dcos(2,2));

% dcos = v;
% Clockwise rotation
% dcos = [cosd(-ang) sind(-ang);
%         -sind(-ang) cosd(-ang)];

    
return