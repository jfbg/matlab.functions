load GFS_folder

eval(['cd ' folder])

! \rm liste
! ls > liste
! grep 'out\.' liste > liste2
! \rm liste
! sed -e "1,$ s/out\.//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/\.12\.//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/\.14\.//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/\.15\.//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/\.16\.//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpx//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/lpy//g" < liste2 > liste
! \rm liste2
! sed -e "1,$ s/lpz//g" < liste > liste2
! \rm liste
! sed -e "1,$ s/spz//g" < liste2 > liste
! \rm liste2



liste = unique(load('liste'));

load StatChan
chan = {'x' 'y' 'z' 's'};


counter = [0 0];

%% Look at all files, open, save as .mat, then delete.

for i = 1:length(liste)
    
    fprintf('\n%4.0f/%4.0f - %11.0f - ',i,length(liste),liste(i));
    
    for j = 1:length(stations)
        
        fprintf('%.0f',stations(j));
        
        for k = 1:length(channels) %#ok<USENS>
            
           
            
            varname = sprintf('out.%11.0f.%2.0f.%s',liste(i),stations(j),channels{k});
            varname2 = sprintf('out_%11.0f_%2.0f_%s',liste(i),stations(j),channels{k});
    
    
           if exist([folder varname],'file') == 2
                fprintf('%s',chan{k}); 
                D = load([folder varname]);
                T = D(:,1);
                D = D(:,2);
                save([folder varname2 '.mat'],'T','D','-mat')
                
                eval(['! \rm ' folder varname])
                
                
           end
           
    
        end
    end
end