function [ang flip P SV] = rotPSV(R,Z,Sarr,lS,ROTATE)

% [ang P SV] = rotPSV(R,Z,Sarr,lS)
%
% Outputs incident angle (ang) calculated from covariance matrix of R and Z.
% Outputs rotated P and SV (if ROTATE == 1);
%
% Sarr is estimated S arrival in signal (index)
% lS is length of window from which to calculate cov matrix (Sarr:Sarr+lS)
%


%%% Calculate covariance matrix
% N = length(R)-1;
% mR = R-mean(R);
% mS = Z-mean(Z);
% C = [sum(mR.*mR)/N sum(mS.*mR)/N;
%      sum(mR.*mS)/N sum(mS.*mS)/N];
% Same as:
  C = cov(R(Sarr:Sarr+lS),Z(Sarr:Sarr+lS));





% Find orientation of eigenvector representing smallest variance
% This is orientation off P-axis.
  [V,D] = eig(C);
  paxis = V(:,diag(D) == min(diag(D)));

%Orientation of z-axis
  zaxis = [0; 1];

% Signed Angle from zaxis to paxis
  ang =  (atan2(zaxis(2),zaxis(1)) - atan2(paxis(2),paxis(1)))/2/pi*360;

  flip = 1;
  if ang>0, ang = ang-180; flip = -1; end


  if ROTATE == 1
  
  % Counterclockwise rotation by -(90+ang)
  dcos = [cosd(90+inc_ang) -sind(90+ang);
         sind(90+ang)  cosd(90+ang)];

    S1 = [R';Z'];
    S2 = NaN(size(S1));

    for i=1:length(S1)
        S2(:,i) = dcos*S1(:,i);
    end

    P = S2(1,:)';
    SV = S2(2,:)';


    else
      P = NaN;
      SV = NaN;
  end
  

end