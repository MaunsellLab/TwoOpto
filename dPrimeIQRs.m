% Grabs the master data, computes the d' medians and IQRS

% Create Master File
[masterStruct] = twoOptoGetData(1);

% Grab the d'
nSessions   = length(masterStruct);

% Init
noStim = zeros(nSessions,1);
v1Stim = zeros(nSessions,1);
scStim = zeros(nSessions,1);
toStim = zeros(nSessions,1);

for i = 1:nSessions
    noStim(i) = [masterStruct(i).dPrimes.noOpto];
    v1Stim(i) = [masterStruct(i).dPrimes.V1];
    scStim(i) = [masterStruct(i).dPrimes.SC];
    toStim(i) = [masterStruct(i).dPrimes.twoOpto];
end

%% Median and IQRs
medianNoStim = nanmedian(noStim); %#ok<*NANMEDIAN>
medianV1     = nanmedian(v1Stim);
medianSC     = nanmedian(scStim);
medianTO     = nanmedian(toStim);

iqrNoStim = prctile(noStim, [25 75]);
iqrV1     = prctile(v1Stim, [25 75]);
iqrSC     = prctile(scStim, [25 75]);
iqrTO     = prctile(toStim, [25 75]);


%% plot distributions across sessions
edgeFA    = -0.02:0.02:0.2;
edgeLapse = 0:0.05:0.7;
figure('Position',[10 10 1000 500]); 

subplot(1,2,1);
axis square; hold on;
histogram(faRates, edgeFA, 'FaceColor','w');
yl = ylim();
plot([median(faRates) median(faRates)], [yl(1) yl(2)], 'Color', 'k', 'LineStyle', '--')
title('False Alarm Rates');
ylabel('Counts'); xlabel('Session False Alarm Rate');
set(gca, 'TickDir', 'out', 'FontSize', 14); hold off;

subplot(1,2,2);
axis square; hold on;
histogram(lapseRates, edgeLapse, 'FaceColor','w');
yl1 = ylim();
plot([median(lapseRates) median(lapseRates)], [yl1(1) yl1(2)], 'Color', 'k', 'LineStyle', '--')
title('Lapse Rates'); xlim([0 0.6]);
ylabel('Counts'); xlabel('Session Lapse Rate');
set(gca, 'TickDir', 'out', 'FontSize', 14); hold off;






