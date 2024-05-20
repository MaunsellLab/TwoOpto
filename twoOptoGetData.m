function [masterStruct] = twoOptoGetData(dataCode)

addpath '/Users/jacksoncone/Documents/GitHub/TwoOpto';
% Grab twoOpto Data and plot a heatmap of impairment by condition

% call mouseList to get list for final struct
[animals] = mouseList(dataCode);

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

% Init Master Struct
rowCounter = 1;
masterStruct = struct();

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
%% Extract Data from each session
    
for session = 1:numSessions
    %% Init Variable Placeholders
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

    load(mouseDir(session).name); % Load Session MatFile

    % Sometimes github won't have todays data but the file exists. When
    % this happens the file doesn't contain the 'trials' Struct. 
    % Check and skip this day if so.
    if ~exist('trials')
        continue
    end

    % Occassionally, trials will have been created by it's only 1 trials
    % long, that's not a session
    if length(trials) < 2
        continue
    end

    f = fieldnames(trials); % Which Fields are present

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

    % RT Struct
    reactionTimes.RTs        = RTs;
    reactionTimes.startRT    = startRT;
    reactionTimes.endRT      = endRT;
    reactionTimes.RTWindowMS = RTWindowMS;

    %% Logical Indexes for Different Stimulus Conditions
    noOptoIdx  = [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] == 0 & [trials(:).contrastPC] == 30;
    v1StimIdx  = [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] == 0;
    scStimIdx  = [trialStruct.opto0PowerMW] == 0 & [trialStruct.opto1PowerMW] > 0;
    twoOptoIdx = [trialStruct.opto0PowerMW] > 0 & [trialStruct.opto1PowerMW] > 0;
    topUpIdx   = [trials(:).contrastPC] == 50;
    % Append all indexes to a struct
    logicals.noOpto = noOptoIdx;
    logicals.v1Stim = v1StimIdx;
    logicals.scStim = scStimIdx;
    logicals.twoOpto = twoOptoIdx;
    logicals.topUp = topUpIdx;

    %% Trial Counts Appended to Struct
    % Total Trials
    trialCounts.noOpto = sum(noOptoIdx & ~theIndices.early);
    trialCounts.V1 = sum(v1StimIdx & ~theIndices.early);
    trialCounts.SC = sum(scStimIdx & ~theIndices.early);
    trialCounts.twoOpto = sum(twoOptoIdx & ~theIndices.early);
    trialCounts.topUp = sum(topUpIdx & ~theIndices.early);
    % Hit Counts
    hitCounts.noOpto = sum(noOptoIdx & theIndices.correct);
    hitCounts.V1 = sum(v1StimIdx & theIndices.correct);
    hitCounts.SC = sum(scStimIdx & theIndices.correct);
    hitCounts.twoOpto = sum(twoOptoIdx & theIndices.correct);
    hitCounts.topUp = sum(topUpIdx & theIndices.correct);

    % Compute pHit and then correct for false hits
    noOptoPHit  = hitCounts.noOpto/trialCounts.noOpto; 
    noOptoPHit  = (noOptoPHit - pFA) / (1.0 - pFA);
    v1PHit      = hitCounts.V1/trialCounts.V1; 
    v1PHit = (v1PHit - pFA) / (1.0 - pFA);
    scPHit      = hitCounts.SC/trialCounts.SC; 
    scPHit = (scPHit - pFA) / (1.0 - pFA);
    twoOptoPHit = hitCounts.twoOpto/trialCounts.twoOpto; 
    twoOptoPHit = (twoOptoPHit - pFA) / (1.0 - pFA);
    topUpPHit   = hitCounts.topUp/trialCounts.topUp; 
    topUpPHit = (topUpPHit - pFA) / (1.0 - pFA);
    % Output to Struct
    hitRate.noOpto = noOptoPHit; hitRate.V1 = v1PHit;
    hitRate.SC = scPHit; hitRate.twoOpto = twoOptoPHit;
    hitRate.topUp = topUpPHit;

    % Compute d' and c.
    [dP_noOpto, c_noOpto]   = dprime(noOptoPHit, pFA, true);
    [dP_V1stim, c_V1stim]   = dprime(v1PHit, pFA, true);
    [dP_SCstim, c_SCstim]   = dprime(scPHit, pFA, true);
    [dP_twoOpto, c_twoOpto] = dprime(twoOptoPHit, pFA, true);
    [dP_topUp, c_topUp]     = dprime(topUpPHit, pFA, true);

    % output to struct
    dPrimes.noOpto = dP_noOpto; dPrimes.V1 = dP_V1stim;
    dPrimes.SC = dP_SCstim; dPrimes.twoOpto = dP_twoOpto;
    dPrimes.topUp = dP_topUp;
    criterions.noOpto = c_noOpto; criterions.V1 = c_V1stim;
    criterions.SC = c_SCstim; criterions.twoOpto = c_twoOpto;
    criterions.topUp = c_topUp; 

    % Lapse Rate Based on Top Up Performance
    lapseRate = 1-(hitCounts.topUp/trialCounts.topUp);

    %% Output Session Data to Struct
   
    % Mouse and Session Info
    masterStruct(rowCounter).mouse = animals{1,mouse};
    masterStruct(rowCounter).date = mouseDir(session).name(1:10);
    % Delta d'
    masterStruct(rowCounter).v1DeltaDp = dP_V1stim - dP_noOpto;
    masterStruct(rowCounter).scDeltaDp = dP_SCstim - dP_noOpto;
    masterStruct(rowCounter).twoOptoDeltaDp = dP_twoOpto - dP_noOpto; 
    % d-Primes
    masterStruct(rowCounter).dPrimes = dPrimes;
    % Criterions
    masterStruct(rowCounter).criterions = criterions;
    % Hit Rates
    masterStruct(rowCounter).hitRates = hitRate;
    % number of trials in each stimulus condition
    masterStruct(rowCounter).trialCounts = trialCounts;
    % number of hits in each stimulus condition
    masterStruct(rowCounter).hitCounts = hitCounts;
    % Session Info
    masterStruct(rowCounter).outcomes = theIndices;
    masterStruct(rowCounter).visualStimPC = contrast;
    masterStruct(rowCounter).reactionTimes = reactionTimes;
    masterStruct(rowCounter).faRate = pFA;
    masterStruct(rowCounter).lapseRate = lapseRate;
    masterStruct(rowCounter).trialTypes = logicals;
    
% Go to Next Session, but first increment the counter
rowCounter = rowCounter+1;
clear trials stimDesc file dParam
end

end


