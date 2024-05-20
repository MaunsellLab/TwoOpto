% Two Opto Scatter Plots

% Call twoOptoGetData() First

% Get All Data
% [masterStruct] = twoOptoGetData();

% Extract dPrimes Struct
dPrimes = [masterStruct.dPrimes];

% Delta d' for V1 or SC stimulation alone
v1 = [masterStruct(:).v1DeltaDp];
sc = [masterStruct(:).scDeltaDp];
% Observed delta d' for V1 and SC inhibition
pO = [masterStruct(:).twoOptoDeltaDp];
% Delta d' expected by summing delta's from v1 and sc
p = v1+sc;

% Test for significant Effects
pV1 = signrank([dPrimes(:).V1],[dPrimes(:).noOpto]);
pSC = signrank([dPrimes(:).SC],[dPrimes(:).noOpto]);
pTO = signrank([dPrimes(:).twoOpto],[dPrimes(:).noOpto]);

% Medians
V1Med = nanmedian([dPrimes(:).V1]);
SCMed = nanmedian([dPrimes(:).SC]);
noOptoMed = nanmedian([dPrimes(:).noOpto]);
twoOptoMed = nanmedian([dPrimes(:).twoOpto]);

%% V1 d' for stim versus unstim
figure;
scatter([dPrimes(:).noOpto],[dPrimes(:).V1], 30, 'filled', 'MarkerFaceColor', 'k');
axis square;
hold on;
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth',1);
xlim([0 3.1]);
ylim([0 3.1]);
plot([0 3.1],[0 3.1],'LineStyle', '--', 'Color', 'r');
text(0.52, 2.25, sprintf('p < %0.3f', pV1), 'Color','red','FontSize',12);
title('dPrime: control vs. V1');
xlabel('d'' V1 control');
ylabel('d'' V1 inhibited');
grid on;
hold off;
%% SC d' for stim versus unstim
figure;
scatter([dPrimes(:).noOpto],[dPrimes(:).SC], 30, 'filled', 'MarkerFaceColor', 'k');
axis square;
hold on;
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth',1);
xlim([0 3.1]);
ylim([0 3.1]);
plot([0 3.1],[0 3.1],'LineStyle', '--', 'Color', 'r');
text(0.52, 2.25, sprintf('p < %0.3f', pSC), 'Color','red','FontSize',12);
title('dPrime: control vs. SC');
xlabel('d'' SC control');
ylabel('d'' SC inhibited');
grid on;
hold off;
%% SC delta d' vs. V1 delta d'
scatter(v1,sc, 30, 'filled', 'MarkerFaceColor', 'k');
axis square;
hold on;
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth',1);
xlim([-1.5 1]);
ylim([-1.5 1]);
plot([-1.5 1],[-1.5,1],'LineStyle', '--', 'Color', 'r');
title('Delta dPrime: V1 vs. SC');
xlabel('delta d'' V1');
ylabel('delta d'' SC');
hold off;
%% Two Opto Delta d' versus sc + v1 delta d'
scatter(p,pO, 30, 'filled', 'MarkerFaceColor', 'k');
axis square;
hold on;
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 14);
set(gca, 'LineWidth',1);
xlim([-2.5 1]);
ylim([-2.5 1]);
plot([-2.5 1],[-2.5,1],'LineStyle', '--', 'Color', 'r');
title('Delta dPrime: Two Opto');
xlabel('delta d'': deltaV1 + deltaSC');
ylabel('Observed delta d'': two Opto');
hold off;