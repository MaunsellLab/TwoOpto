% twoOptoGetData

addpath '/Users/jacksoncone/Documents/GitHub/TwoOpto';
% Grab twoOpto Data and plot a heatmap of impairment by condition

% List of Animals in the twoOpto GitHub Folder
animals = {'2339','2365','2394','2396', '2397','2401','2454','2456','2475','2485','2488', '2589'};

% Set this to the location of the data files on your machine
[~, name] = system('hostname');
name = lower(name);
if contains(name, 'nrb')
    filePath = '/Users/jacksoncone/Documents/GitHub/TwoOpto/';
else
    filePath = '/Users/Shared/Data/TwoOpto/';
end

% Get all Folders on the filePath
twoOptoDir = dir(filePath);
% Filter Folders by the list of animals
twoOptoDir = twoOptoDir(ismember({twoOptoDir.name}, animals));

%% 

%% Loop Through Mouse Folders
for mouse = 1:length(twoOptoDir)
    cd(strcat(filePath,twoOptoDir(mouse).name,'/','MatFiles/'));
    % How Many Sessions for This Mouse?
    mouseDir = dir('**/*.mat');
    numSessions = length(mouseDir);
    
    % Check the dates, and delete before 6-20 (when opto ramp was set to +50)
    idx = zeros(1,numSessions); 
    for i = 1:numSessions
        temp = mouseDir(i).name;
        temp = datetime(temp(1:end-4));
        idx(i) = temp > datetime('16-Jun-2023'); 
    end
    
    % How many sessions made the cut
    numSessions = sum(idx);
    if numSessions == 0
        continue
    end
    
    % Update the Mouse Directory with sessions that make the cut
    mouseDir = mouseDir(logical(idx));
    %% Init 
    stimDesc = [];
    azimuths = [];
    elevations = [];
    noOptoIdx = [];
    v1StimIdx = [];
    scStimIdx = [];
    twoOptoIdx = [];
    topUpIdx = [];
    outcomes = [];
    RTs = [];
    contrast = [];

    for session = 1:numSessions
        % Load Session MatFile
        load(mouseDir(session).name);

        % Sometimes github won't have todays data but the file exists.
        if ~exist('trials')
            continue
        end

        % Which Fields are present
        f = fieldnames(trials);

        if any(strcmp(f,'stimDesc')) % Not all files had the visual stim info
            stimDesc = [trials.stimDesc];
            azimuths = [azimuths, azimuths, stimDesc.azimuthDeg];
            elevations = [elevations, stimDesc.elevationDeg];
        end

        outcomes = [outcomes, trials.trialEnd];
        RTs = [RTs, trials.reactTimeMS];
        contrast = [contrast, trials.contrastPC];


        % Get Stim Info for reach trial
        trialStruct = [trials(:).trial];

        % Logical Indexes for Different Stimulus Conditions
        noOptoIdx = [noOptoIdx, [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] == 0 & [trials(:).contrastPC] == 30];
        v1StimIdx = [v1StimIdx, [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] == 0];
        scStimIdx = [scStimIdx, [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] > 0];
        twoOptoIdx = [twoOptoIdx, [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] > 0];
        topUpIdx  = [topUpIdx, [trials(:).contrastPC] == 50];

    end

    % Clean Up
    clear trials stimDesc file dParams numSessions

    % Get Outcomes and Filter
    hit = outcomes == 0; fa = outcomes == 1; miss = outcomes == 2;
    
    %% Create a Master Table of all Trials
    masterTable = table(contrast', RTs', hit', miss', fa', noOptoIdx', v1StimIdx', scStimIdx', twoOptoIdx', topUpIdx');
    masterTable.Properties.VariableNames = {'contrastPC','RT','hit','miss','fa','noOptoTrial', 'v1Trial','scTrial', 'twoOptoTrial', 'topUpTrial'};

    %% Compute Performance 
    

    % Total Trials
    nV1Trials       = sum(masterTable.v1Trial & ~masterTable.fa);
    nSCTrials       = sum(masterTable.scTrial & ~masterTable.fa);
    nTwoOptoTrials  = sum(masterTable.twoOptoTrial & ~masterTable.fa);
    nNoOptoTrials   = sum(masterTable.noOptoTrial & ~masterTable.fa);
    nTopUpTrials    = sum(masterTable.topUpTrial & ~masterTable.fa);
    
    % Total Hits
    nV1Hits = sum(masterTable.v1Trial & masterTable.hit);
    nSCHits = sum(masterTable.scTrial & masterTable.hit);
    nTwoOptoHits = sum(masterTable.twoOptoTrial & masterTable.hit);
    nNoOptoHits = sum(masterTable.noOptoTrial & masterTable.hit);
    nTopUpHits = sum(masterTable.topUpTrial & masterTable.hit);

    % Compute pHit and CIs given alpha (CI) 
    [V1phat,V1pci] = binofit(nV1Hits,nV1Trials);
    [SCphat,SCpci] = binofit(nSCHits,nSCTrials);
    [twoOptophat,twoOptopci] = binofit(nTwoOptoHits,nTwoOptoTrials);
    [noOptophat,noOptopci] = binofit(nNoOptoHits,nNoOptoTrials);
    [topUpphat,topUppci] = binofit(nTopUpHits,nTopUpTrials);


%% Plot Results For This Mouse
    locs = [1 2 3 4 5];
    perf = [noOptophat, V1phat, SCphat, twoOptophat, topUpphat];

    % Plot Summary Results
    figure('Position', [10 10 500 500]);
    hold on;
    axis square;
    scatter(locs,perf, 75,'black','filled');
    % Add CIs
    plot([1 1], [noOptopci(1) noOptopci(2)], 'Color', 'k', 'LineWidth',1);
    plot([2 2], [V1pci(1) V1pci(2)], 'Color', 'k', 'LineWidth',1);
    plot([3 3], [SCpci(1) SCpci(2)], 'Color', 'k', 'LineWidth',1);
    plot([4 4], [twoOptopci(1) twoOptopci(2)], 'Color', 'k', 'LineWidth',1);
    plot([5 5], [topUppci(1) topUppci(2)], 'Color', 'k', 'LineWidth',1);
    % CUSTOMMIZE
    title(strcat('Hit Rate: Mouse'," ", animals{1,mouse}));
    ax = gca;
    ax.FontSize = 14;
    ax.LineWidth = 1;
    xlim([0.5 5.5]);
    ylim([0 1]);
    ax.TickDir = 'out';
    ax.TickDir = 'out';
    ax.XTick = [1, 2, 3, 4, 5];
    ax.XTickLabel = {'control', 'V1', 'SC', 'V1+SC', 'Top Up'};
    ax.YTick = [0, 0.25, 0.5, 0.75, 1.0];
    ax.YTickLabel =  {'0.00', '0.25', '0.50', '0.75', '1.00'};
    xlabel('Stim Condition');
    ylabel('Proportion Correct');
    hold off;

    % Save Figure
    saveas(gcf, [strcat(filePath, 'Results/', animals{1,mouse},'.tif')]);
end


