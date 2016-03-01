function plotS1S2(T1,D1,T2,D2)

% plotS1S2(T1,D1,T2,D2)

mD1 = mean(abs(D1));
mD2 = mean(abs(D2));

subplot(211)
plot(T1/60,D1)
ylabel('DU')

if max(abs(D1)) > 200*mD1
    ylim([-15*mD1 15*mD1])
else 
end
xlim([min(T1)/60 max(T1)/60])

subplot(212)
plot(T2/60,D2)
if max(abs(D2)) > 100*mD2
    ylim([-15*mD2 15*mD2])
else 
end
xlim([min(T2)/60 max(T2)/60])

ylabel('DU')
xlabel('Time (min)')
