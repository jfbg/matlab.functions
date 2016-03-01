function DespikeALL_s(liste)

% DespikeALL(liste) 
%
% Despike all events in liste. If no input, script checks to make sure that
% all traces in GFS_folder have a depsiked counterparts.


load GFS_folder

if nargin  == 0 

currentdir = pwd;
save /Users/JF/src/MatLab/Functions/currentdir.mat currentdir

eval(['cd ' folder])

! \rm liste
! ls > liste
! grep 'out.' liste > liste2
! \rm liste
! sed -e "1,$ s/out_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/_12_//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/_14_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/_15_//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/_16_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpx//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/lpy//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpz//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/spz//g" < liste2 > liste
! \rm liste2

liste1 = unique(load('liste'));

eval(['cd ' folder '/DESPIKED'])

! \rm liste
! ls > liste
! grep 'out.' liste > liste2
! \rm liste
! sed -e "1,$ s/out_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/_12_//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/_14_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/_15_//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/_16_//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpxd//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/lpyd//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpzd//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/spzd//g" < liste2 > liste
! \rm liste2

listeD = unique(load('liste'));


liste = setdiff(liste1,listeD);

end

%%

load StatChan
chan = { 'x' 'y' 'z' 's'};




fprintf('%.0f events to despike\n',length(liste));



for i = 1:length(liste)
    
    fprintf('\n%4.0f/%4.0f - %11.0f - ',i,length(liste),liste(i));
    
    for j = 1:length(stations)
        
        fprintf('%.0f',stations(j));
        
        for k = 1:length(channels) 
            
            if k < 4, lmed = 500;
            elseif k == 4, lmed = 500*8; end
            
            
            fprintf('%s',chan{k}); 
            
            varname = sprintf('out.%11.0f.%2.0f.%s',liste(i),stations(j),channels{k});
            varname2 = sprintf('out_%11.0f_%2.0f_%s',liste(i),stations(j),channels{k});
    
    
            if exist([folder '/DESPIKED/' varname2 'd.mat'], 'file') == 2
                continue
            elseif exist([folder varname2 '.mat'],'file') == 2
                load([folder varname2])
                D = despike(D,lmed);
                save([folder '/DESPIKED/' varname2 'd.mat'],'T','D','-mat')
            end
    
        end
    end
end
        

%% LEFT OVERS

if nargin == 0
fprintf('Checking for leftovers\n');

count11 = 0;

for i = 1:length(liste1)
    
    fprintf('\n%4.0f/%4.0f - %11.0f - ',i,length(liste1),liste1(i));
    
    for j = 1:length(stations)
        
        fprintf('%.0f',stations(j));
        
        for k = 1:length(channels) 
            
            if k < 4, lmed = 500;
            elseif k == 4, lmed = 500*8; end
            
            fprintf('%s',chan{k}); 
            
            varname = sprintf('out.%11.0f.%2.0f.%s',liste1(i),stations(j),channels{k});
            varname2 = sprintf('out_%11.0f_%2.0f_%s',liste1(i),stations(j),channels{k});
    
    
            if exist([folder '/DESPIKED/' varname2 'd.mat'], 'file') == 2
                continue
            elseif exist([folder varname2 '.mat'],'file') == 2
                count11 = count11+1;
%                 load([folder varname2]);
%                 D = despike(D,lmed);
%                 save([folder '/DESPIKED/' varname2 'd.mat'],'T','D','-mat')
            end
    
        end
    end
end


fprintf('count = %.0f',count11);

back
end

%%

