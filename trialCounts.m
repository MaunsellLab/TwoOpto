% twoOpto TrialCounts

[~, name] = system('hostname');
name = lower(name);
if contains(name, 'nrb')
    filePath = '/Users/jacksoncone/Documents/GitHub/TwoOpto/';
else
    filePath = '/Users/Shared/Data/TwoOpto/';
end

% Generate Master Struct, UPDATED FOR DIFFERENT GROUPS
[masterStruct] = twoOptoGetData(1);

% Number of unique mice
mouseList = zeros(1,length(masterStruct));
for session = 1:length(masterStruct)
    mouseList(session) = str2num(masterStruct(session).mouse);
end
mice = unique(mouseList);
nMice = length(mice);
clear session

%% Count up trial types
counts = [masterStruct(:).trialCounts];
nSessions = length(masterStruct);
nTwoOptoTrials  = sum([counts(:).twoOpto]);
nControlTrials  = sum([counts(:).noOpto]);
nV1Trials       = sum([counts(:).V1]);
nSCTrials       = sum([counts(:).SC]);
nTopUpTrials    = sum([counts(:).topUp]);

% Sessions Per Mouse
mouseNumbers = zeros(1,nSessions);
for sessionNum = 1:nSessions
    mouseNumbers(1,sessionNum) = str2double(masterStruct(sessionNum).mouse);
end

twoOptoTrialsByMouse = zeros(1,nMice);

for mouseNum = 1:nMice
    logIdx = mouseNumbers == mice(1,mouseNum);
    twoOptoTrialsByMouse(1, mouseNum) = sum([counts(logIdx).twoOpto]);
end


%% dPrimes
dPrimes = [masterStruct(:).dPrimes];
% Means
meanControld = nanmean([dPrimes(:).noOpto]);
meanV1d      = nanmean([dPrimes(:).V1]);
meanSCd      = nanmean([dPrimes(:).SC]);
meanTwoOptod = nanmean([dPrimes(:).twoOpto]);
% SEM
semControld = nanstd([dPrimes(:).noOpto])/sqrt(nSessions);
semV1d      = nanstd([dPrimes(:).V1])/sqrt(nSessions);
semSCd      = nanstd([dPrimes(:).SC])/sqrt(nSessions);
semTwoOptod = nanstd([dPrimes(:).twoOpto])/sqrt(nSessions);

% Plot
figure;
axis square;
hold on;
scatter([1 2 3 4], [meanControld,meanV1d,meanSCd,meanTwoOptod], 50, 'k', 'filled');
plot([1 1], [meanControld-semControld meanControld+semControld], 'Color', 'k', 'LineWidth',1);
plot([2 2], [meanV1d-semV1d meanV1d+semV1d], 'Color', 'k', 'LineWidth',1);
plot([3 3], [meanSCd-semSCd meanSCd+semSCd], 'Color', 'k', 'LineWidth',1);
plot([4 4], [meanTwoOptod-semTwoOptod meanTwoOptod+semTwoOptod], 'Color', 'k', 'LineWidth',1);
xlabel('Stimulation Condition');
ylabel('d''');
title('Average d'' n = 9 mice');
set(gca, 'TickDir', 'out');
set(gca, 'FontSize', 16);
set(gca, 'LineWidth',1);
xlim([0.5 4.5]);
ylim([1.1 1.9]);
set(gca, 'XTick', [1 2 3 4 5]);
set(gca, 'YTick', [1.25, 1.5, 1.75]);
set(gca,'XTickLabel', {'control', 'V1', 'SC', 'V1+SC', 'Top Up'});
hold off;

d = table2array(struct2table(dPrimes));
d = d(:,1:end-1); % drop topUp
% Drop rows with Nans
d(any(isnan(d),2),:) = [];

% Are variances equal? If not, mst use non-parametric Test
pVar = vartestn(d);

% Non-Parametric Two Way ANOVA
[p,tbl,stats] = friedman(d,1);
[c,m,h,gnames] = multcompare(stats, 'Display','on'); % Post Hoc Test

%% dPrime by Mouse
mouseP = zeros(1,nMice);
multi = cell(1,nMice);

for mouseNum = 1:nMice
    logIdx = mouseNumbers == mice(1,mouseNum);
    sessNum = sum(logIdx);
    % d' for this mouse
    d1 = table2array(struct2table(dPrimes(logIdx)));
    d1 = d1(:,1:end-1); % drop topUp
    % Drop rows with Nans
    d1(any(isnan(d1),2),:) = [];
    [mouseP(1,mouseNum),tbl, stats] = friedman(d1,1);
    multi{1,mouseNum} = multcompare(stats);
end

%% Session Counts

sessionCounts = zeros(1,length(mice));

for i = 1:length(mice)
    sessionCounts(1,i) = sum(mouseNumbers == mice(1,i));
end

