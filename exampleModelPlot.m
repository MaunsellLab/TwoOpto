% Two Opto Model Demo Figure

v1d = 0:0.01:3;
scd = 0:0.01:3;
nPoints = length(v1d);
sumModel = zeros(nPoints,nPoints);
maxModel = zeros(nPoints,nPoints);
rng(10);

%% Example Distributions for one point

nSamps = 2500;
v1Samps = normrnd(1,1,[1, nSamps]);
scSamps = normrnd(1,1,[1, nSamps]);
limits = [0,0.2];
bins = -4:0.4:6;
edge = 0.00;

figure('Position',[10,10,1250,1250]);
subplot(2,2,1);
histogram(v1Samps, bins, 'Normalization','probability',...
    'FaceColor', 'm', 'FaceAlpha', 0.3, 'EdgeAlpha', edge); hold on; 
xlim([-4 6]); ylim([limits(1), limits(2)]);
plot([1 1], [limits(1), limits(2)],...
    'LineStyle','-','Color', 'k', 'LineWidth',1);
set(gca, 'TickDir', 'out', 'FontSize', 16); axis square;
yticks([0, 0.05, 0.1, 0.15, 0.2]); box off;
xlabel('V1 Signal'); ylabel('Probability'); title('V1 Signal'); 
hold off;

subplot(2,2,2);
histogram(scSamps, bins, 'Normalization','probability',...
    'FaceColor','c', 'FaceAlpha', 0.3, 'EdgeAlpha', edge); hold on; 
xlim([-4 6]); ylim([limits(1), limits(2)]);
plot([1 1], [limits(1), limits(2)],...
    'LineStyle','-','Color', 'k', 'LineWidth',1);
set(gca, 'TickDir', 'out', 'FontSize', 16); axis square;
yticks([0, 0.05, 0.1, 0.15, 0.2]); box off; 
xlabel('SC Signal'); ylabel('Probability'); title('SC Signal'); 
hold off;

subplot(2,2,3);
histogram(v1Samps + scSamps, bins, 'Normalization','probability',...
    'FaceColor', "#EDB120", 'FaceAlpha', 0.3, 'EdgeAlpha', edge); hold on; 
xlim([-4 6]); ylim([limits(1), limits(2)]);
plot([mean(v1Samps + scSamps) mean(v1Samps + scSamps)],...
    [limits(1), limits(2)], 'LineStyle','-','Color', 'k', 'LineWidth',1);
set(gca, 'TickDir', 'out', 'FontSize', 16); axis square;
yticks([0, 0.05, 0.1, 0.15, 0.2]); box off;
xlabel('Combined Signal'); ylabel('Probability'); title('Sum Model'); 
hold off;

subplot(2,2,4);
histogram(max(v1Samps,scSamps), bins, 'Normalization','probability',...
    'FaceColor',"#EDB120", 'FaceAlpha', 0.3, 'EdgeAlpha', edge); hold on;
xlim([-4 6]); ylim([limits(1), limits(2)]);
plot([mean(max(v1Samps,scSamps)) mean(max(v1Samps,scSamps))],...
    [limits(1), limits(2)], 'LineStyle','-','Color', 'k', 'LineWidth',1);
set(gca, 'TickDir', 'out', 'FontSize', 16); axis square;
yticks([0, 0.05, 0.1, 0.15, 0.2]); box off;
xlabel('Combined Signal'); ylabel('Probability'); title('Max Model'); 
hold off;

%% Means of the Distributions

max_mu = mean(max(v1Samps,scSamps));
sum_mu = mean(v1Samps+scSamps);
v1_mu  = mean(v1Samps);
sc_mu  = mean(scSamps);

%% Model all V1,SC combos
% Fill Out Sum and Max Model With Identical Samples
nSamps = 10000;
for i = 1:nPoints
    for j = 1:nPoints
        v1Samps = normrnd(v1d(i),1,[1, nSamps]);
        scSamps = normrnd(scd(j),1,[1, nSamps]);
        maxModel(i,j) = mean(max(v1Samps,scSamps));
        sumModel(i,j) = mean(v1Samps)+mean(scSamps); 
    end
end

%% Import TwoOptoTable to highlight valid regions
data = readtable('twoOptoTable.csv'); 

% valid Region spans the min and max control d'
valid = [min(data.noStimDp), max(data.noStimDp)];

dP_mu      = round(nanmean(data.noStimDp),2); %#ok<*NANMEAN>
dp_sem     = round(nanstd(data.noStimDp)/sqrt(height(data)),2); %#ok<*NANSTD>
dPV1_mu    = round(nanmean(data.v1StimDp),2);
dPV1_sem   = round(nanstd(data.v1StimDp)/sqrt(height(data)),2);
dPSC_mu    = round(nanmean(data.scStimDp),2);
dPSC_sem   = round(nanstd(data.scStimDp)/sqrt(height(data)),2);
dPboth_mu  = round(nanmean(data.obStimDp),2);
dPboth_sem = round(nanstd(data.obStimDp)/sqrt(height(data)),2);

deltaDpV1_mu    = round(nanmean(data.v1StimDp- data.noStimDp),2);
deltaDpSC_mu    = round(nanmean(data.scStimDp - data.noStimDp),2);
deltaDpboth_mu  = round(nanmean(data.obStimDp - data.noStimDp),2);
deltaDpV1_sem   = round(nanstd(data.v1StimDp - data.noStimDp)/sqrt(height(data)-1),2);
deltaDpSC_sem   = round(nanstd(data.scStimDp - data.noStimDp)/sqrt(height(data)-1),2);
deltaDpboth_sem = round(nanstd(data.obStimDp - data.noStimDp)/sqrt(height(data)-1),2);

%% Find Example Valid Region

% Steps To Plotting Valid Area
% 1 - Find all rows and columns that could produce dP_mu
% 2 - Exclude rows where dPmu + deltaDpV1_mu < 0
% 3 - Exclude columns where dP_mu + deltaDpSC_mu < 0 
% 4 - Plot a dashed white circle around those points.

%  Sum Model: Valid Rows and Columns for the observed control d'
[r1s, c1s] = find(round(sumModel,1) == round(dP_mu,1)); % indexes of sum locs that match observed d'
% Find Values where the observed delta d' keeps the V1/SC d' > 0
% Assumes that d' from each area was positive, otherwise inhibiting that
% structure would improve the observed d'
validSum = [(v1d(r1s) + round(deltaDpV1_mu,1) > 0)',...
    (scd(c1s) + round(deltaDpSC_mu,1) > 0)'];
% Only locations where both SC/V1 > 0 are valid
validSumIdx = validSum(:,1) & validSum(:,2);
% Filter the valid locations 
% Remaining are Valid Starting Rows/Cols based on observed control d'
r1s = r1s(validSumIdx); c1s = c1s(validSumIdx);

% For Predictions shift all the valid locations by the observed delta d'
predSum = [(v1d(r1s) + deltaDpV1_mu)',...
    (scd(c1s) + deltaDpSC_mu)'];

% Predicted Performance of Each Valid Start Point
predPerfSum = mean(predSum(:,1) + predSum(:,2));

% find x,y locations of the valid predictions
[r1s_Pred, c1s_Pred] = find(round(sumModel,2) == round(predPerfSum,2)); % indexes of sum locs that match observed d'







% for development
validLocsSum  = [r1s, c1s];
validDSum     = [v1d(r1s)', scd(c1s)'];

% Now Label Predicted End Locations Given the Average Shifts
% Predicted d' = dP_mu + (deltaDpV1_mu + deltaDpSC_mu) 
predPerfSum = dP_mu + (deltaDpV1_mu + deltaDpSC_mu); 

bool = zeros(length(validLocsSum),1);
for i = 1:length(validLocsSum)
    bool(i) = round(sumModel(validLocsSum(i,1),validLocsSum(i,2))...
            + (deltaDpV1_mu + deltaDpSC_mu),1) == 1.20;
end
bool = logical(bool);
sum(bool)

validLocsSum(bool,:)

% All Valid Predicted Values Regardless of start location
[r1s_Pred, c1s_Pred] = find(round(sumModel,1) == round(predPerfSum,1)); % indexes of sum locs that match observed d'
% Filter preds to only come from valid starts

% Observed Average Shift = dPboth_mu
[r1s_Obs, c1s_Obs] = find(round(sumModel,2) == round(dPboth_mu,2)); % indexes of sum locs that match observed d'


%% Plot!

figure('Position',[10,10,2000,800]);
subplot(1,2,1); 
pcolor(sumModel); 
shading interp; hold on;
% Plot Valid Starting Points
plot(r1s, c1s, 'LineStyle',':', 'LineWidth',1.5, 'Color', 'w');
% Plot Predicted Ending Points
plot(r1s_Pred, c1s_Pred, 'LineStyle',':', 'LineWidth',2.5, 'Color', 'r');
% Plot Observed Ending Points
plot(r1s_Obs, c1s_Obs, 'LineStyle',':', 'LineWidth',2.5, 'Color', 'm');
xlabel('V1 d'''); ylabel('SC d'''); zlabel('Predicted d''');
xticks([0, 100, 200, 300]); xticklabels({'0', '1', '2', '3'});
yticks([0, 100, 200, 300]); yticklabels({'0', '1', '2', '3'});
title('Sum Model'); colorbar; colormap turbo; axis square;
set(gca, 'TickDir', 'out', 'FontSize', 16);
xlim([0,301]); ylim([0,301]); box off;
hold off;



%%
% Max Model
[r1m, c1m] = find(round(maxModel,1) == round(dP_mu,1)); % indexes of max locs that match observed d'


subplot(1,2,2); hold on;
surf(round(maxModel,1), 'EdgeColor','interp','FaceAlpha', 0.8); 
plot(r1m, c1m, 'LineStyle','--', 'LineWidth',1, 'Color', 'w');
xlabel('V1 d'''); ylabel('SC d'''); zlabel('Predicted d''');
xticks([0, 100, 200, 300]); xticklabels({'0', '1', '2', '3'});
yticks([0, 100, 200, 300]); yticklabels({'0', '1', '2', '3'});
title('Max Model'); colorbar; colormap turbo; axis square;
set(gca, 'TickDir', 'out', 'FontSize', 16);
xlim([0,301]); ylim([0,301]); zlim([0 6]); clim([0 6]); 
%view(0,90);
hold off;


%%


% % Find indices where Z approximately equals the desired value
% tolerance = 0.01; % Allow for some tolerance in the Z value
% indicesSum = abs(round(sumModel,1) - round(dP_mu,1)) < tolerance;
% [X, Y] = meshgrid(v1d, scd); % May not be needed



