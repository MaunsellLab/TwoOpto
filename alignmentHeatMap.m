%% Show HeatMap

% 5 degree step sizes on Stimulus Locations
scale = -25:5:25;
% Get Data
[alignedMaps] = stimFieldAlignment();
nMice = size(alignedMaps,1);

% Init Color and trial count maps
v1Map   = zeros(length(scale),length(scale),nMice);
v1Count = zeros(length(scale), length(scale),nMice);
scMap   = zeros(length(scale),length(scale),nMice);
scCount = zeros(length(scale),length(scale),nMice);


% Extract V1 and SC Maps into a tensor
for mouseNum = 1:nMice
    % Get Data From This Animal
    v1Azimuths   = alignedMaps(mouseNum).V1.azimuths;
    v1Elevations = alignedMaps(mouseNum).V1.elevations;
    v1Counts     = alignedMaps(mouseNum).V1.nTrials;
    v1DeltaHits  = alignedMaps(mouseNum).V1.deltaHitRate;
    scAzimuths   = alignedMaps(mouseNum).SC.azimuths;
    scElevations = alignedMaps(mouseNum).SC.elevations;
    scCounts     = alignedMaps(mouseNum).SC.nTrials;
    scDeltaHits  = alignedMaps(mouseNum).SC.deltaHitRate;

    for i = 1:size(v1Azimuths,1)
        v1Map(find(scale==v1Elevations(i)),...
            find(scale==v1Azimuths(i)),mouseNum)...
            = v1DeltaHits(i);

        v1Count(find(scale==v1Elevations(i)),...
            find(scale==v1Azimuths(i)),mouseNum)...
            = v1Counts(i);
    end

    for i = 1:size(scAzimuths,1)
        scMap(find(scale==scElevations(i)),...
            find(scale==scAzimuths(i)),mouseNum)...
            = scDeltaHits(i);

        scCount(find(scale==scElevations(i)),...
            find(scale==scAzimuths(i)),mouseNum)...
            = scCounts(i);
    end
end

% Compute Mean Maps

scCount_mean = mean(scCount,3);
scMap_mean   = mean(scMap,3);
v1Count_mean = mean(v1Count,3);
v1Map_mean   = mean(v1Map,3);

% Fraction of max trial counts
v1NormCounts = v1Count_mean/max(max(v1Count_mean));
scNormCounts = scCount_mean/max(max(scCount_mean));



% Plot Summary Results
figure('Position', [10 10 1000 1000]);
subplot(1,2,1);
hold on; axis square;
s = pcolor(v1Map_mean); s.EdgeColor = 'k';
s.AlphaData = v1NormCounts;    % set vertex transparencies by trial counts (peak normalized)
s.FaceAlpha = 'flat';
title(strcat('Change in Prop Detected: V1'));
set(gca, 'FontSize', 14); colormap("autumn");
ax = gca; cbh = colorbar;
xlabel('Difference from Tested Azimuth');
ylabel('Difference from Tested Elevation');
ax.FontSize = 14; ax.LineWidth = 1;
ax.TickDir = 'out';
ax.XTick = [2.5, 4.5, 6.5, 8.5, 10.5]; ax.YTick = [2.5, 4.5, 6.5, 8.5, 10.5];
xlim([3 length(v1Map_mean)-1]); ylim([3 length(v1Map_mean)-1]);
ax.XTickLabel = {'-20', '-10', '0', '+10', '+20'};
ax.YTickLabel =  {'-20', '-10', '0', '+10', '+20'};
caxis([-0.20, 0.10]);
cbh.Ticks = [-0.20, -0.10, 0, 0.10];
cbh.TickLabels ={'-0.20', '-0.10', '0', '0.05'};
hold off;

subplot(1,2,2);
hold on; axis square;
s = pcolor(scMap_mean); s.EdgeColor = 'k';
s.AlphaData = scNormCounts;    % set vertex transparencies by trial counts (peak normalized)
s.FaceAlpha = 'flat';
title(strcat('Change in Prop Detected: SC'));
set(gca, 'FontSize', 14); colormap("autumn");
ax = gca; cbh = colorbar;
xlabel('Difference from Tested Azimuth');
ylabel('Difference from Tested Elevation');
ax.FontSize = 14; ax.LineWidth = 1;
ax.TickDir = 'out';
ax.XTick = [2.5, 4.5, 6.5, 8.5, 10.5]; ax.YTick = [2.5, 4.5, 6.5, 8.5, 10.5];
xlim([3 length(scMap_mean)-1]); ylim([3 length(scMap_mean)-1]);
ax.XTickLabel = {'-20', '-10', '0', '+10', '+20'};
ax.YTickLabel =  {'-20', '-10', '0', '+10', '+20'};
caxis([-0.20, 0.10]);
cbh.Ticks = [-0.20, -0.10, 0, 0.10];
cbh.TickLabels ={'-0.20', '-0.10', '0', '0.05'};
hold off;