function twoOptoPlots(lapseCut,faCut, dataCode)

% Inputs
% LapseCut [range: 0-1]: If lapse rate on topUp > lapseCut, the session is
% dropped from analysis
% faCut [range: 0-1]: If the estimate false alarm rate > faCut, the session is
% dropped from analysis

[~, name] = system('hostname');
name = lower(name);
if contains(name, 'nrb')
    filePath = '/Users/jacksoncone/Documents/GitHub/TwoOpto/';
else
    filePath = '/Users/Shared/Data/TwoOpto/';
end

% Generate Master Struct
[masterStruct] = twoOptoGetData(dataCode);

% Number of unique mice
mouseList = zeros(1,length(masterStruct));
for session = 1:length(masterStruct)
    mouseList(session) = str2num(masterStruct(session).mouse);
end
mice = unique(mouseList);
nMice = length(mice);
clear session

for mouseNum = 1:nMice
    % Indexes of Sessions for this mouse
    idx = mouseList == mice(1,mouseNum);
    % Sub-Select Table for this mouse
    U = masterStruct(1,idx);
    % Sub-Select Table based on False Alarm and lapse Cuts specified below
    subIdx = [U.faRate] <= faCut & [U.lapseRate] <= lapseCut;
    U = U(1,subIdx);
    % How Many Sessions Survived the cuts
    numSessions = length(U);

    %% Get Data Values For Plotting
    for session = 1:numSessions
        % dPrimes
        dp_noOpto(session) = U(session).dPrimes.noOpto;
        dp_V1(session)     = U(session).dPrimes.V1;
        dp_SC(session)     = U(session).dPrimes.SC;
        dp_twoOpto(session)= U(session).dPrimes.twoOpto;
        dp_topUp(session)  = U(session).dPrimes.topUp;
        % criterions
        c_noOpto(session) = U(session).criterions.noOpto;
        c_V1(session)     = U(session).criterions.V1;
        c_SC(session)     = U(session).criterions.SC;
        c_twoOpto(session)= U(session).criterions.twoOpto;
        c_topUp(session)  = U(session).criterions.topUp;
        % get hit rates
        hr_noOpto(session) = U(session).hitRates.noOpto;
        hr_V1(session)     = U(session).hitRates.V1;
        hr_SC(session)     = U(session).hitRates.SC;
        hr_twoOpto(session)= U(session).hitRates.twoOpto;
        hr_topUp(session)  = U(session).hitRates.topUp;
        % delta d'
        deltaDp_V1(session) = U(session).v1DeltaDp;
        deltaDp_SC(session) = U(session).scDeltaDp;
        deltaDp_2p(session) = U(session).twoOptoDeltaDp;
        % RTs
        RTs = [U(session).reactionTimes.RTs];
        noOptoIdx = [U(session).trialTypes.noOpto];
        v1Idx = [U(session).trialTypes.v1Stim];
        scIdx = [U(session).trialTypes.scStim];
        twoOptoIdx = [U(session).trialTypes.twoOpto];
        topUpIdx = [U(session).trialTypes.topUp];
        hitIdx = U(session).reactionTimes.RTs >= U(session).reactionTimes.startRT...
            & U(session).reactionTimes.RTs <= U(session).reactionTimes.endRT;
        % Compute average RT
        noOptoRT(session) = mean(RTs(noOptoIdx & hitIdx));
        v1RT(session)  = mean(RTs(v1Idx & hitIdx));
        scRT(session)  = mean(RTs(scIdx & hitIdx));
        twoOptoRT(session)  = mean(RTs(twoOptoIdx & hitIdx));
        topUpRT(session)  = mean(RTs(topUpIdx & hitIdx));
    end

    %% Plot Results For This Mouse

    %% d-prime
    locs = [1 2 3 4 5];
    perf = [nanmean(dp_noOpto), nanmean(dp_V1), nanmean(dp_SC), nanmean(dp_twoOpto), nanmean(dp_topUp)];
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add SEM
    noOptoSEM = nanstd(dp_noOpto)/sqrt(length(isnan(dp_noOpto)));
    v1SEM = nanstd(dp_V1)/sqrt(length(isnan(dp_V1)));
    scSEM = nanstd(dp_SC)/sqrt(length(isnan(dp_SC)));
    twoOptoSEM = nanstd(dp_twoOpto)/sqrt(length(isnan(dp_twoOpto)));
    topUpSEM = nanstd(dp_topUp)/sqrt(length(isnan(dp_topUp)));
    plot([1 1], [perf(1)-noOptoSEM perf(1)+noOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [perf(2)-v1SEM perf(2)+v1SEM], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [perf(3)-scSEM perf(3)+scSEM], 'Color', 'k', 'LineWidth',1);
    plot([4 4], [perf(4)-twoOptoSEM perf(4)+twoOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([5 5], [perf(5)-topUpSEM perf(5)+topUpSEM], 'Color', 'k', 'LineWidth',1);
    % CUSTOMIZE
    title(strcat('d-prime: Mouse:'," ", num2str(mice(1,mouseNum))));
    ax = gca; ax.FontSize = 16; ax.LineWidth = 1; ax.TickDir = 'out';
    xlim([0.5 5.5]); ylim([0.5 3]);
    ax.XTick = [1, 2, 3, 4, 5]; ax.YTick = [0.5, 1, 1.5, 2, 2.5, 3];
    ax.XTickLabel = {'control', 'V1', 'SC', 'V1+SC', 'Top Up'};
    ax.YTickLabel =  {'0.50', '1.00', '1.50', '2.00', '2.50', '3.00'};
    xlabel('Stimulation Condition'); ylabel('d''');
    hold off;
    % Save Figure
    saveas(gcf, [strcat(filePath,'Results/dPrime/',num2str(mice(1,mouseNum)),'.tif')]);
    %% Criterions
    locs = [1 2 3 4 5];
    perf = [nanmean(c_noOpto), nanmean(c_V1), nanmean(c_SC), nanmean(c_twoOpto), nanmean(c_topUp)];
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add SEM
    noOptoSEM = nanstd(c_noOpto)/sqrt(length(isnan(c_noOpto)));
    v1SEM = nanstd(c_V1)/sqrt(length(isnan(c_V1)));
    scSEM = nanstd(c_SC)/sqrt(length(isnan(c_SC)));
    twoOptoSEM = nanstd(c_twoOpto)/sqrt(length(isnan(c_twoOpto)));
    topUpSEM = nanstd(c_topUp)/sqrt(length(isnan(c_topUp)));
    plot([1 1], [perf(1)-noOptoSEM perf(1)+noOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [perf(2)-v1SEM perf(2)+v1SEM], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [perf(3)-scSEM perf(3)+scSEM], 'Color', 'k', 'LineWidth',1);
    plot([4 4], [perf(4)-twoOptoSEM perf(4)+twoOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([5 5], [perf(5)-topUpSEM perf(5)+topUpSEM], 'Color', 'k', 'LineWidth',1);
    % CUSTOMIZE
    title(strcat('criterion: Mouse:'," ", num2str(mice(1,mouseNum))));
    ax = gca; ax.FontSize = 16; ax.LineWidth = 1; ax.TickDir = 'out';
    xlim([0.5 5.5]); ylim([0.4 1.6]);
    ax.XTick = [1, 2, 3, 4, 5]; ax.YTick = [0.5, 1.0, 1.5];
    ax.XTickLabel = {'control', 'V1', 'SC', 'V1+SC', 'Top Up'};
    ax.YTickLabel =  {'0.50', '1.00', '1.50'};
    xlabel('Stimulation Condition'); ylabel('criterion');
    hold off;
    % Save Figure
    saveas(gcf, [strcat(filePath,'Results/criterion/',num2str(mice(1,mouseNum)),'.tif')]);
    %% Hit Rates
    locs = [1 2 3 4 5];
    perf = [nanmean(hr_noOpto), nanmean(hr_V1), nanmean(hr_SC), nanmean(hr_twoOpto), nanmean(hr_topUp)];
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add SEM
    noOptoSEM = nanstd(hr_noOpto)/sqrt(length(isnan(hr_noOpto)));
    v1SEM = nanstd(hr_V1)/sqrt(length(isnan(hr_V1)));
    scSEM = nanstd(hr_SC)/sqrt(length(isnan(hr_SC)));
    twoOptoSEM = nanstd(hr_twoOpto)/sqrt(length(isnan(hr_twoOpto)));
    topUpSEM = nanstd(hr_topUp)/sqrt(length(isnan(hr_topUp)));
    plot([1 1], [perf(1)-noOptoSEM perf(1)+noOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [perf(2)-v1SEM perf(2)+v1SEM], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [perf(3)-scSEM perf(3)+scSEM], 'Color', 'k', 'LineWidth',1);
    plot([4 4], [perf(4)-twoOptoSEM perf(4)+twoOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([5 5], [perf(5)-topUpSEM perf(5)+topUpSEM], 'Color', 'k', 'LineWidth',1);
    % CUSTOMIZE
    title(strcat('hit Rate: Mouse:'," ", num2str(mice(1,mouseNum))));
    ax = gca; ax.FontSize = 16; ax.LineWidth = 1; ax.TickDir = 'out';
    xlim([0.5 5.5]); ylim([0 1]);
    ax.XTick = [1, 2, 3, 4, 5]; ax.YTick = [0, 0.25 0.5 0.75 1.0];
    ax.XTickLabel = {'control', 'V1', 'SC', 'V1+SC', 'Top Up'};
    ax.YTickLabel =  {'0.00', '0.25', '0.50', '0.75', '1.00'};
    xlabel('Stimulation Condition'); ylabel('Hit Rate');
    hold off;
    % Save Figure
    saveas(gcf, [strcat(filePath,'Results/hitRate/',num2str(mice(1,mouseNum)),'.tif')]);
    %% Reaction Times
    locs = [1 2 3 4 5];
    perf = [nanmean(noOptoRT), nanmean(v1RT), nanmean(scRT), nanmean(twoOptoRT), nanmean(topUpRT)];
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add SEM
    noOptoSEM = nanstd(noOptoRT)/sqrt(length(isnan(noOptoRT)));
    v1SEM = nanstd(v1RT)/sqrt(length(isnan(v1RT)));
    scSEM = nanstd(scRT)/sqrt(length(isnan(scRT)));
    twoOptoSEM = nanstd(twoOptoRT)/sqrt(length(isnan(twoOptoRT)));
    topUpSEM = nanstd(topUpRT)/sqrt(length(isnan(topUpRT)));
    plot([1 1], [perf(1)-noOptoSEM perf(1)+noOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [perf(2)-v1SEM perf(2)+v1SEM], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [perf(3)-scSEM perf(3)+scSEM], 'Color', 'k', 'LineWidth',1);
    plot([4 4], [perf(4)-twoOptoSEM perf(4)+twoOptoSEM], 'Color', 'k', 'LineWidth',1);
    plot([5 5], [perf(5)-topUpSEM perf(5)+topUpSEM], 'Color', 'k', 'LineWidth',1);
    % CUSTOMIZE
    title(strcat('Reaction Times: Mouse:'," ", num2str(mice(1,mouseNum))));
    ax = gca; ax.FontSize = 16; ax.LineWidth = 1; ax.TickDir = 'out';
    xlim([0.5 5.5]); ylim([175 350]);
    ax.XTick = [1, 2, 3, 4, 5]; ax.YTick = [200, 250, 300, 350];
    ax.XTickLabel = {'control', 'V1', 'SC', 'V1+SC', 'Top Up'};
    ax.YTickLabel =  {'200', '250', '300', '350'};
    xlabel('Stimulation Condition'); ylabel('Reaction Time (ms)');
    hold off;
    % Save Figure
    saveas(gcf, [strcat(filePath,'Results/RTs/',num2str(mice(1,mouseNum)),'.tif')]);
    %% Delta D'
    locs = [1 2 3];
    perf = [nanmean(deltaDp_V1), nanmean(deltaDp_SC), nanmean(deltaDp_2p)];
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add SEM
    v1SEM = nanstd(deltaDp_V1)/sqrt(length(isnan(deltaDp_V1)));
    scSEM = nanstd(deltaDp_SC)/sqrt(length(isnan(deltaDp_SC)));
    twoOptoSEM = nanstd(deltaDp_2p)/sqrt(length(isnan(deltaDp_2p)));
    plot([1 1], [perf(1)-v1SEM perf(1)+v1SEM], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [perf(2)-scSEM perf(2)+scSEM], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [perf(3)-twoOptoSEM perf(3)+twoOptoSEM], 'Color', 'k', 'LineWidth',1);
    % CUSTOMIZE
    title(strcat('Delta d'': Mouse:'," ", num2str(mice(1,mouseNum))));
    ax = gca; ax.FontSize = 16; ax.LineWidth = 1; ax.TickDir = 'out';
    xlim([0.5 3.5]); ylim([-2 0.5]);
    ax.XTick = [1, 2, 3]; ax.YTick = [-2, -1.5, -1, -0.5, 0, 0.5];
    ax.XTickLabel = {'V1', 'SC', 'V1+SC'};
    ax.YTickLabel =  {'-2', '-1.5', '-1', '-0.5', '0.0', '0.5'};
    xlabel('Stimulation Condition'); ylabel('Delta d''');
    hold off;
    % Save Figure
    saveas(gcf, [strcat(filePath,'Results/delta dPrime/',num2str(mice(1,mouseNum)),'.tif')]);
    
    close all % close all the figures
end
