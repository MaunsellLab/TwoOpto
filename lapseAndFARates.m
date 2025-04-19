% Grabs the master data, plots histograms of Lapse and False alarm rates
% across sessions.

% Create Master File
[masterStruct] = twoOptoGetData(1);

% Grab Lapse and False Alarm Rates
nSessions   = length(masterStruct);
lapseRates = [masterStruct(:).lapseRate];
faRates    = [masterStruct(:).faRate];
%% Median and IQRs
medianLapse = median(lapseRates);
medianFA    = median(faRates);
iqrFA       = prctile(faRates, [25 75]);
iqrLapse    = prctile(lapseRates, [25 75]);
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






