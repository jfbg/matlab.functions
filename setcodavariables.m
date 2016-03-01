%% Set variables

fold1 = '/Users/jf/Documents/UBC/Moon/CodaCharacterization/ProcessingScripts/';
fold2 = '/Users/jf/Documents/UBC/Moon/CodaCharacterization/MatFiles/';

load([fold2 'EventFilesF'])
load([fold1 'FitFilesF'])
load([fold1 'FitListF'])
load([fold1 'FitResultsF'])
load([fold1 'Analysis/ignore'])
load([fold1 'Analysis/KeepShortCDec'])
% load([fold1 'ArrivalsF'])
load([fold1 'TsF'])
load([fold1 'PandSarrF'])


load([fold1 'Tcalc_FitParams'])
% *_Tcalc is 1372x6 where each column is parameter retrieved when fitting
% using: (1/(t+Tcalc)^alpha*exp(-(t+Tcalc)/tau_d) where Tcalc is eetimated
% S-wave travel time + S-wave rise time.
%
% *_noT0 is 1372x6 where each column is parameter retrieved when fitting
% using: (1/(t)^alpha*exp(-(t)/tau_d).
RMSmis_Tcalc = SSE_Tcalc.^.5;
RMSmis_noT0 = SSE_noT0.^.5;

alphas = [0 .5 .75 1 1.5 2];

Desc = {EDescF{FitListF(:,4)}};
ED = EpiDistF(FitListF(:,4));
LOC = LocationsF(FitListF(:,4),:);

maxtime = maxEtimeF';
maxtime = maxtime(:);

maxAmp = maxEF';
maxAmp = maxAmp(:);

DeLOG = EDepthsLOGF(FitListF(:,4),:);
Cluster = EClusterF(FitListF(:,4));

CDec = FitParamsF(:,2);
CDecShortF(KeepShortCDec) = 0;
CDec(CDecShortF == 1) = NaN;
CDec(ignore,:) = NaN;

fLP = [.5 1 1.5];
fSP = [3 5 7 9];
Qc = nan(size(CDec));

iLP = find((FitListF(:,3) < 4 | FitListF(:,3) == 5) == 1 & isnan(CDec) == 0); 
Qc(iLP) = CDec(iLP) .* fLP(FitListF(iLP,5))'*pi;
iSP = find(FitListF(:,3) == 4 & isnan(CDec) == 0); 
Qc(iSP) = CDec(iSP) .* fSP(FitListF(iSP,5))'*pi;



% Fit Parameters:
% 
%     FitUncerF(ii,1) = length(fit);
%     FitUncerF(ii,2) = dt;
%     FitUncerF(ii,3) = sum(res.^2);
%     FitUncerF(ii,4) = sum(res/maxEF(eID,bID)).^2/length(fit);

RMSmis = (FitUncerF(:,3)./FitUncerF(:,1)).^.5;
