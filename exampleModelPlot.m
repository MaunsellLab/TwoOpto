% Two Opto Model Demo Figure

v1d = 0:0.01:3;
scd = 0:0.01:3;
nPoints = length(v1d);
sumModel = zeros(nPoints,nPoints);
maxModel = zeros(nPoints,nPoints);

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

%% Model all V1,SC combos
% Fill Out Sum and Max Model With Identical Samples
nSamps = 10000;
for i = 1:nPoints
    for j = 1:nPoints
        v1Samps = normrnd(v1d(i),1,[1, nSamps]);
        scSamps = normrnd(scd(j),1,[1, nSamps]);
        maxModel(i,j) = mean(max(v1Samps,scSamps));
        % sumModel(i,j) = v1d(i)+scd(j);
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


%% Make Plot
% Dashed Lines Connect identical predicted d'
% Change this to a region for a single example

%% Find Example Valid Region

% Steps To Plotting Valid Area
% 1 - Find all rows and columns that could produce dP_mu
% 2 - Exclude rows where dPmu + deltaDpV1_mu < 0
% 3 - Exclude columns where dP_mu + deltaDpSC_mu < 0 
% 4 - Plot a dashed white circle around those points.



[r1s, c1s] = find(round(sumModel,1) == round(dP_mu,1));
[r1m, c1m] = find(round(maxModel,1) == round(dP_mu,1));
[X, Y] = meshgrid(v1d, scd); % Replace xVector and yVector with your x and y axis vectors



% Find indices where Z approximately equals the desired value
tolerance = 0.01; % Allow for some tolerance in the Z value
indicesSum = abs(round(sumModel,1) - round(dP_mu,1)) < tolerance;
% Get the x, y values where Z is approximately the specified value
xRange = X(indicesSum);
yRange = Y(indicesSum);






figure('Position',[10,10,2000,800]);
subplot(1,2,1); 
pcolor(sumModel); 
shading interp; hold on;
plot([find(v1d==max(xRange)),0], [0, find(scd==max(yRange))], 'w--', 'LineWidth', 2);
xlabel('V1 d'''); ylabel('SC d'''); zlabel('Predicted d''');
xticks([0, 100, 200, 300]); xticklabels({'0', '1', '2', '3'});
yticks([0, 100, 200, 300]); yticklabels({'0', '1', '2', '3'});
title('Sum Model'); colorbar; colormap turbo; axis square;
set(gca, 'TickDir', 'out', 'FontSize', 16);
xlim([0,301]); ylim([0,301]); box off;
%zlim([0 6]); clim([0 6]);
hold off;

subplot(1,2,2); hold on;
surf(round(maxModel,1), 'EdgeColor','interp','FaceAlpha', 0.8); 
plot(r1m, c1m, 'LineStyle','--', 'LineWidth',1, 'Color', 'k');
xlabel('V1 d'''); ylabel('SC d'''); zlabel('Predicted d''');
xticks([0, 100, 200, 300]); xticklabels({'0', '1', '2', '3'});
yticks([0, 100, 200, 300]); yticklabels({'0', '1', '2', '3'});
title('Max Model'); colorbar; colormap turbo; axis square;
set(gca, 'TickDir', 'out', 'FontSize', 16);
xlim([0,301]); ylim([0,301]); zlim([0 6]); clim([0 6]); 
%view(0,90);
hold off;







