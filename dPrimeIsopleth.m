function dPrimeIsopleth(dataCode)
% Plots an Isopleth of d' for SC or V1 inhibition as well as SC+V1 inhib

[masterStruct] = twoOptoGetData(dataCode);

% Plots the d' for each stimulation condition in Gigi's experiment
% [masterStruct] = twoOptoGetData();
nSessions = length(masterStruct);

% Get d'
dPrimes = [masterStruct.dPrimes];
nO = [dPrimes.noOpto];
V1 = [dPrimes.V1];
SC = [dPrimes.SC];
tO = [dPrimes.twoOpto];
% means
mean_nO = nanmean(nO);
mean_V1 = nanmean(V1);
mean_SC = nanmean(SC);
mean_tO = nanmean(tO);
% SEM
sem_nO = nanstd(nO)/sqrt(nSessions);
sem_V1 = nanstd(V1)/sqrt(nSessions);
sem_SC = nanstd(SC)/sqrt(nSessions);
sem_tO = nanstd(tO)/sqrt(nSessions);

% delta d'
delta_V1 = nO - V1;
delta_SC = nO - SC;
 
%% Make Plot
% Generate delta d' isopleths
% Make Circles
[x1, y1] = isopleth(0,0,0);
[x2, y2] = isopleth(0,0,1);
[x3, y3] = isopleth(0,0,2);
[x4, y4] = isopleth(0,0,3);

figure;
hold on;
axis square;
plot(x1, y1, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x2, y2, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x3, y3, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
plot(x4, y4, 'LineStyle', '--', 'Color', 'k', 'LineWidth', 0.5);
xlim([1 3]);
ylim([1 3]);

% plot points
scatter(mean_nO, mean_nO, 200, 'k', 'filled');
scatter(mean_V1, mean_nO, 200, 'cyan', 'filled');  % V1
scatter(mean_nO, mean_SC, 200, 'magenta', 'filled'); % SC
scatter(mean_tO, mean_tO, 200, 'red', 'filled'); % Two Opto

% ErrorBars
% Control
plot([mean_nO-sem_nO mean_nO+sem_nO],[mean_nO mean_nO],...
    'LineStyle','-', 'Color', 'k', 'LineWidth', 1);
plot([mean_nO mean_nO],[mean_nO-sem_nO mean_nO+sem_nO],...
    'LineStyle','-', 'Color', 'k', 'LineWidth', 1);
% V1
plot([mean_V1-sem_V1 mean_V1+sem_V1],[mean_nO mean_nO],...
    'LineStyle','-', 'Color', 'cyan', 'LineWidth', 1);
plot([mean_V1 mean_V1],[mean_nO-sem_nO mean_nO+sem_nO],...
    'LineStyle','-', 'Color', 'cyan', 'LineWidth', 1);
% SC
plot([mean_nO-sem_nO mean_nO+sem_nO],[mean_SC mean_SC],...
    'LineStyle','-', 'Color', 'magenta', 'LineWidth', 1);
plot([mean_nO mean_nO],[mean_SC-sem_SC mean_SC+sem_SC],...
    'LineStyle','-', 'Color', 'magenta', 'LineWidth', 1);
% Two Opto
plot([mean_tO-sem_tO mean_tO+sem_tO],[mean_tO mean_tO],...
    'LineStyle','-', 'Color', 'red', 'LineWidth', 1);
plot([mean_tO mean_tO],[mean_tO-sem_tO mean_tO+sem_tO],...
    'LineStyle','-', 'Color', 'red', 'LineWidth', 1);

legend('','','','','control', 'V1', 'SC', 'Both', 'location', 'northeast');


xlabel('V1 d''');
ylabel('SC d''');
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth', 1);
set(gca, 'XTick', [0 1 2 3]);
set(gca, 'YTick', [0 1 2 3]);
hold off;
