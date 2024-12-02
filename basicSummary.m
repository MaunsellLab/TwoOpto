% Basic Analyses For Two Opto

% Get Master Struct
[masterStruct] = twoOptoGetData(1); % Switch number for off target placements
%% Raw d-primes

dPrimes = [masterStruct.dPrimes];
d_control = [dPrimes.noOpto];
d_v1      = [dPrimes.V1];
d_sc      = [dPrimes.SC];
d_to      = [dPrimes.twoOpto];

% bar plots
dP = [d_control', d_v1', d_sc', d_to']; % Combine the vectors into a matrix
nSessions = size(dP, 1); % Number of observations (rows)
means = nanmean(dP); %#ok<NANMEAN>
SEM = nanstd(dP)./sqrt(size(dP,1)); %#ok<NANSTD>
x = 1:4; % For the bar plot

% Plot the bar graph of means
figure;
hold on;
bar(x, means, 'FaceColor', [0.8 0.8 0.8]); % Gray bars
% SEM as error bars
errorbar(x, means, SEM, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, "CapSize",0); 
xlim([0.5 4.5]); xticks(1:4); set(gca, 'FontSize', 16);  
xticklabels({'Control', 'V1 Inhib', 'SC Inhib', 'V1+SC Inhib'}); % Label each column
ylabel('d'''); xlabel('Condition'); set(gca, 'TickDir', 'out');
title('Observed Effects'); box off; hold off;

% Scatter Plots
% Control Versus V1
figure('Position',[10 10 1000 1000]);
subplot(2,2,1); axis square;
scatter(d_v1, d_control, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
ylabel('d'' Control'); xlabel('d'' V1 Inhibition');
xlim([0 3]); ylim([0 3]); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('Control versus V1 inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% Control Versus SC
subplot(2,2,2); axis square;
scatter(d_sc, d_control, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
ylabel('d'' Control'); xlabel('d'' SC Inhibition');
xlim([0 3]); ylim([0 3]); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('Control versus SC inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% V1 Versus Dual Site
subplot(2,2,3); axis square;
scatter(d_v1, d_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('d'' V1 Inhibition'); ylabel('d'' V1+SC Inhibition');
xlim([0 3]); ylim([0 3]); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('V1 inhibition versus Dual Site Inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% SC Versus Dual Site
subplot(2,2,4); axis square;
scatter(d_sc, d_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('d'' SC Inhibition'); ylabel('d'' SC+V1 Inhibition');
xlim([0 3]); ylim([0 3]); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('SC inhibition versus Dual Site Inhibition');
set(gca, 'FontSize', 16); box off; hold off;

%% Statistics on d-primes

% Create a table 
T = array2table(dP, 'VariableNames', {'Control', 'V1', 'SC', 'Dual'});
% Fit a repeated measures model
rm = fitrm(T, 'Control-Dual ~ 1', 'WithinDesign', [1 2 3 4]);
% Perform repeated measures ANOVA
ranovatbl = ranova(rm);
disp(ranovatbl);

% Bonferroni  ==> Adjust by number of Comps
[~,p1] = ttest(T.Control, T.V1);
[~,p2] = ttest(T.Control, T.SC);
[~,p3] = ttest(T.Control, T.Dual);
[~,p4] = ttest(T.V1, T.SC);
[~,p5] = ttest(T.V1, T.Dual);
[~,p6] = ttest(T.SC, T.Dual);

% Bonferroni correction (number of comparisons = 6)
p_values = [p1, p2, p3, p4, p5, p6];
p_adjusted = p_values * 6;  % Adjust by the number of comparisons
clear p1 p2 p3 p4 p5 p6 p_values

%% Criterions

crit = [masterStruct.criterions];
c_control = [crit.noOpto];
c_v1      = [crit.V1];
c_sc      = [crit.SC];
c_to      = [crit.twoOpto];

% bar plots
c = [c_control', c_v1', c_sc', c_to']; % Combine the vectors into a matrix
nSessions = size(c, 1); % Number of observations (rows)
means_c = nanmean(c); %#ok<NANMEAN>
SEM_c = nanstd(c)./sqrt(size(c,1)); %#ok<NANSTD>
x = 1:4; % For the bar plot

limits = [0 2.5];

% Plot the bar graph of means
figure;
hold on;
bar(x, means_c, 'FaceColor', [0.8 0.8 0.8]); % Gray bars
% SEM as error bars
errorbar(x, means_c, SEM_c, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, "CapSize",0); 
xlim([0.5 4.5]); xticks(1:4); set(gca, 'FontSize', 16);  
xticklabels({'Control', 'V1 Inhib', 'SC Inhib', 'V1+SC Inhib'}); % Label each column
ylabel('Criterion'); xlabel('Condition'); set(gca, 'TickDir', 'out');
title('Observed Effects'); box off; hold off;

% Scatter Plots
% Control Versus V1
figure('Position',[10 10 1000 1000]);
subplot(2,2,1); axis square;
scatter(c_v1, c_control, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
ylabel('criterion: Control'); xlabel('criterion: V1 Inhibition');
xlim(limits); ylim(limits); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('Control versus V1 inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% Control Versus SC
subplot(2,2,2); axis square;
scatter(c_sc, c_control, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
ylabel('criterion: Control'); xlabel('criterion: SC Inhibition');
xlim(limits); ylim(limits); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('Control versus SC inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% V1 Versus Dual Site
subplot(2,2,3); axis square;
scatter(c_v1, c_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('criterion: V1 Inhibition'); ylabel('criterion: V1+SC Inhibition');
xlim(limits); ylim(limits); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('V1 inhibition versus Dual Site Inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% SC Versus Dual Site
subplot(2,2,4); axis square;
scatter(c_sc, c_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([0, 3], [0, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('criterion: SC Inhibition'); ylabel('criterion: SC+V1 Inhibition');
xlim(limits); ylim(limits); set(gca, 'TickDir', 'out');
xticks([0 1 2 3]); yticks([0 1 2 3]);
title('SC inhibition versus Dual Site Inhibition');
set(gca, 'FontSize', 16); box off; hold off;

%% Statistics on criterions

% Create a table 
T_c = array2table(c, 'VariableNames', {'Control', 'V1', 'SC', 'Dual'});
% Fit a repeated measures model
rm_c = fitrm(T_c, 'Control-Dual ~ 1', 'WithinDesign', [1 2 3 4]);
% Perform repeated measures ANOVA
ranovatbl_c = ranova(rm_c);
disp(ranovatbl_c);

% Bonferroni  ==> Adjust by number of Comps
[~,p1] = ttest(T_c.Control, T_c.V1);
[~,p2] = ttest(T_c.Control, T_c.SC);
[~,p3] = ttest(T_c.Control, T_c.Dual);
[~,p4] = ttest(T_c.V1, T_c.SC);
[~,p5] = ttest(T_c.V1, T_c.Dual);
[~,p6] = ttest(T_c.SC, T_c.Dual);

% Bonferroni correction (number of comparisons = 6)
p_values_c = [p1, p2, p3, p4, p5, p6];
p_adjusted_c = p_values_c * 6;  % Adjust by the number of comparisons
clear p1 p2 p3 p4 p5 p6 p_values


%% Delta d primes
dp_v1 = [masterStruct(:).v1DeltaDp];
dp_sc = [masterStruct(:).scDeltaDp];
dp_to = [masterStruct(:).twoOptoDeltaDp];

% How Many Sessions had increased d or no effect'?
nV1Pos = sum(dp_v1 >= 0);
nSCPos = sum(dp_sc >= 0);
nTOPos = sum(dp_to >= 0);
nNoModel = sum(dp_v1 >= 0|dp_sc >= 0|dp_to >= 0);
% which sessions were these? - examine
noModelIdx = dp_v1 >= 0|dp_sc >= 0|dp_to >= 0;

% are they the same mice?
miceNoModel = {masterStruct(noModelIdx).mouse};
sessionsNoModel = {masterStruct(noModelIdx).date};

%% Statistics on Delta d'

ddp = [dp_v1', dp_sc', dp_to'];

% Create a table 
Tdp = array2table(ddp, 'VariableNames', {'V1', 'SC', 'Dual'});
% Fit a repeated measures model
rmDP = fitrm(Tdp, 'V1-Dual ~ 1', 'WithinDesign', [1 2 3]);
% Perform repeated measures ANOVA
ranovatblDP = ranova(rmDP);
disp(ranovatblDP);

% Bonferroni  ==> Adjust by number of Comps
[~,p1] = ttest(Tdp.V1, Tdp.SC);
[~,p2] = ttest(Tdp.V1, Tdp.Dual);
[~,p3] = ttest(Tdp.SC, Tdp.Dual);

% Bonferroni correction (number of comparisons = 6)
p_values = [p1, p2, p3];
p_adjusted_ddp = p_values * 4;  % Adjust by the number of comparisons, -1 df for differencing
clear p1 p2 p3 p_values


%% Scatter Plots of Delta d'

% Dual Site Versus V1
figure('Position',[10 10 1000 400]);
subplot(1,2,1); axis square;
scatter(dp_v1, dp_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([-2, 3], [-2, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('∆d'' V1'); ylabel('∆d'' V1+SC');
xlim([-2 2]); ylim([-2 2]); set(gca, 'TickDir', 'out');
xticks([-2 -1 0 1 2]); yticks([-2 -1 0 1 2]);
title('V1 versus V1+SC inhibition');
set(gca, 'FontSize', 16); box off; hold off;

% Dual Site Versus SC
subplot(1,2,2); axis square;
scatter(dp_sc, dp_to, 30, 'filled', 'MarkerFaceColor','k'); hold on;
plot([-2, 3], [-2, 3], 'Color', 'k', 'LineStyle','--', 'LineWidth',0.5);
xlabel('∆d'' SC'); ylabel('∆d'' V1+SC');
xlim([-2 2]); ylim([-2 2]); set(gca, 'TickDir', 'out');
xticks([-2 -1 0 1 2]); yticks([-2 -1 0 1 2]);
title('SC versus V1+SC inhibition');
set(gca, 'FontSize', 16); box off; hold off;

%% Bar Plot With SEM
d = [dp_v1', dp_sc', dp_to']; % Combine the vectors into a matrix
nObservations = size(d, 1); % Number of observations (rows)
means = mean(d);
SEM = std(d)./sqrt(size(d,1)); 
x = 1:3; % For the bar plot

% Plot the bar graph of means
figure;
hold on;
bar(x, means, 'FaceColor', [0.8 0.8 0.8]); % Gray bars
% SEM as error bars
errorbar(x, means, SEM, 'k', 'LineStyle', 'none', 'LineWidth', 1.5, "CapSize",0); 
xlim([0.5 3.5]); % Limit x-axis to focus on the three columns
xticks(1:3);     % Set x-ticks to show 1, 2, 3 for the three vectors
xticklabels({'V1 Inhib', 'SC Inhib', 'V1+SC Inhib'}); % Label each column
ylabel('∆d'''); xlabel('Condition');
title('Observed Effects'); hold off;

%% Example Mouse

listOMice = unique({masterStruct.mouse});
nMice = length(listOMice);
mouseMeans = zeros(1,nMice);
mouseSEM   = zeros(1,nMice);

% mouse means
for mouseNum = 1:nMice
    mouseIdx = strcmp({masterStruct.mouse},listOMice{1,mouseNum});
    mouseMeans(1,mouseNum) = nanmean(d_control(1,mouseIdx)); %#ok<*NANMEAN>
    mouseMeans(2,mouseNum) = nanmean(d_v1(1,mouseIdx));
    mouseMeans(3,mouseNum) = nanmean(d_sc(1,mouseIdx));
    mouseMeans(4,mouseNum) = nanmean(d_to(1,mouseIdx));
    mouseSEM(1,mouseNum)   = nanstd(d_control(1,mouseIdx))./sqrt(sum(mouseIdx)); %#ok<*NANSTD>
    mouseSEM(2,mouseNum)   = nanstd(d_v1(1,mouseIdx))./sqrt(sum(mouseIdx));
    mouseSEM(3,mouseNum)   = nanstd(d_sc(1,mouseIdx))./sqrt(sum(mouseIdx));
    mouseSEM(4,mouseNum)   = nanstd(d_to(1,mouseIdx))./sqrt(sum(mouseIdx));
end

% Example mice - scatter and line plot
% 4, 7, 10

figure('Position',[10 10 1500 1500]);
for mouseNum = 1:length(listOMice)
    mouseIdx = strcmp({masterStruct.mouse},listOMice{1,mouseNum});
    dP_mouse = dP(mouseIdx,:);
    nObservations = size(dP_mouse,1);
    nConditions = size(dP_mouse,2);
    x = 1:nConditions;
    colors = lines(nObservations);
    subplot(3,4,mouseNum);
    hold on;
    % Loop over each observation (row) and plot connected lines
    for i = 1:nObservations
        plot(x, dP_mouse(i, :), '-o', 'LineWidth',...
            1.5, 'MarkerSize', 10, 'MarkerFaceColor', colors(i,:),...
            'Color', colors(i,:));  % Plot each row as a line with points (circles)
        ylim([-0.5 3]);
        yticks([0 1 2 3]);
    end
    xlim([0.5 nConditions+0.5]); xticks(1:nConditions);
    xticks([1 2 3 4]);
    set(gca, 'TickDir', 'out'); set(gca, 'FontSize', 16);
    xticklabels({'Control', 'V1 Inhib.', 'SC Inhib.', 'V1+SC Inhib.'}); % Label each column
    ylabel('d'''); xlabel('Condition'); title(sprintf('Mouse # %s', listOMice{1,mouseNum})); hold off;
end







