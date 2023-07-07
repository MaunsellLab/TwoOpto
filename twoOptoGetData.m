% twoOptoGetData

addpath '/Users/jacksoncone/Documents/GitHub/TwoOpto';
% Grab twoOpto Data and plot a heatmap of impairment by condition

% List of Animals in the twoOpto GitHub Folder
animals = {'2365','2394','2396','2397','2401','2452','2453','2454','2456','2475','2476','2485','2487','2589'};

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
        
        % SetUp the outcomes indicies
        indices.correct = outcomes == 0;
        indices.early = outcomes == 1;
        indices.fail = outcomes == 2;

        % Fit Logistic Function to Response Time Distribution
        % Reassign outcomes based on the fit.
        [respLimitsMS, theIndices, ~, ~] = getResponseLimits(file, trials, indices);
        
        % Specs of the Augmented RT Window
        startRT = respLimitsMS(1); endRT = respLimitsMS(2); RTWindowMS = diff(respLimitsMS);
            
        % Compute overall False Alarm Rate
        rateEarly = earlyRate(file, trials, theIndices.correct, theIndices.fail, theIndices.early);
        pFA = 1.0 - exp(-rateEarly * RTWindowMS / 1000.0);

        % Logical Indexes for Different Stimulus Conditions
        noOptoIdx  = [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] == 0 & [trials(:).contrastPC] == 30;
        v1StimIdx  = [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] == 0;
        scStimIdx  = [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] > 0;
        twoOptoIdx = [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] > 0;
        topUpIdx   = [trials(:).contrastPC] == 50;
    
        % Total Trials
        nNoOptoTrials   = sum(noOptoIdx & ~theIndices.early);
        nV1Trials       = sum(v1StimIdx & ~theIndices.early);
        nSCTrials       = sum(scStimIdx & ~theIndices.early);
        nTwoOptoTrials  = sum(twoOptoIdx & ~theIndices.early);
        nTopUpTrials    = sum(topUpIdx & ~theIndices.early);
    
        % Total Hits
        nNoOptoHits  = sum(noOptoIdx & theIndices.correct);
        nV1Hits      = sum(v1StimIdx & theIndices.correct);
        nSCHits      = sum(scStimIdx & theIndices.correct);
        nTwoOptoHits = sum(twoOptoIdx & theIndices.correct);
        nTopUpHits   = sum(topUpIdx & theIndices.correct);

         % Compute pHit and then correct for false hits
         noOptoPHit  = nNoOptoHits/nNoOptoTrials;
         noOptoPHit  = (noOptoPHit - pFA) / (1.0 - pFA);
         v1pHit      = nV1Hits/nV1Trials;
         v1pHit      = (v1pHit - pFA) / (1.0 - pFA);
         scPHit      = nSCHits/nSCTrials;
         scPHit      = (scPHit - pFA) / (1.0 - pFA);
         twoOptoPHit = nTwoOptoHits/nTwoOptoTrials;
         twoOptoPHit = (twoOptoPHit - pFA) / (1.0 - pFA);
         topUpPHit   = nTopUpHits/nTopUpTrials;
         topUpPHit   = (topUpPHit - pFA) / (1.0 - pFA);

        % Compute d' and c.
        [dP_noOpto, c_noOpto]   = dprime(noOptoPHit, pFA, true);
        [dP_V1stim, c_V1stim]   = dprime(v1pHit, pFA, true);
        [dP_SCstim, c_SCstim]   = dprime(scPHit, pFA, true);
        [dP_twoOpto, c_twoOpto] = dprime(twoOptoPHit, pFA, true);
        [dP_topUp, c_topUp]     = dprime(topUpPHit, pFA, true);

        % Output Session Data to Struct 

    end

    % Clean Up
    clear trials stimDesc file dParams numSessions


    
    %% Create a Master Table of all Trials
    masterTable = table(contrast', RTs', hit', miss', fa', noOptoIdx', v1StimIdx', scStimIdx', twoOptoIdx', topUpIdx');
    masterTable.Properties.VariableNames = {'contrastPC','RT','hit','miss','fa','noOptoTrial', 'v1Trial','scTrial', 'twoOptoTrial', 'topUpTrial'};

    %% Output a Struct




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


