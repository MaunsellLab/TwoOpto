function [alignedMaps] = stimFieldAlignment()

% Transect Alignment Plot
% Expresses Impact of V1 Stimulation As Offset from Optimal SC Location
% Expresses Impact of SC Stimulation As Offset from Optimal V1 Location

trialCutoff = 100;
brainArea = {'V1','SC'};

% Path to Alignment Sessions
% Set this to the location of the transect data files on your machine
[~, name] = system('hostname');
name = lower(name);
if contains(name, 'nrb')
    filePath = '/Users/jacksoncone/Documents/GitHub/Transect/';
    addpath('/Users/jacksoncone/Documents/GitHub/Transect');
    addpath('/Users/jacksoncone/Documents/GitHub/TwoOpto');
else
    filePath = '/Users/Shared/Data/Transect/';
    addpath('/Users/Shared/Data/Transect/');
    addpath('/Users/Shared/Data/TwoOpto/');
end

% List of Experimental Animals and Visual Stimulus Locations
% dataCodes
% 1 = SC, V1 aligned % 2 = SC, V1 misaligned % 3 = Control Mice
[locs] = stimLocations(1); 

% Extract Relevant Variables
nMice     = size(locs,1);
azimuth   = locs.azimuth;
elevation = locs.elevation;
animals   = locs.animals;

% Get all Folders on the filePath
transectDir = dir(filePath);
% Filter Folders by the list of animals
transectDir = transectDir(ismember({transectDir.name}, animals));

% Init Storage Struct For Aligned Maps
alignedMaps = struct('animal',animals,'V1',[],'SC',[]);

%% Loop Through Mouse Folders
 % One Folder for V1 and One Folder SC

 for mouse = 1:nMice
     for j = 1:length(brainArea)

         % start with V1
         cd(strcat(filePath,transectDir(mouse).name,'/','MatFiles/',brainArea{j}));
         % How Many Sessions for This Mouse
         mouseDir = dir('**/*.mat');
         numSessions = length(mouseDir);
         % 
         % if numSessions == 0
         %     continue
         % end

         % Init
         stimDesc = [];
         azimuths = [];
         elevations = [];
         stimTrial = [];
         outcomes = [];
         RTs = [];
         contrast = [];
         topUp = [];
         %% Get Data for this mouse
         for session = 1:numSessions
             % Load Session MatFile
             load(mouseDir(session).name);

             stimDesc = [trials.stimDesc];
             azimuths = [azimuths, stimDesc.azimuthDeg];
             elevations = [elevations, stimDesc.elevationDeg];
             stimTrial = [stimTrial, stimDesc.powerIndex];
             outcomes = [outcomes, trials.trialEnd];
             RTs = [RTs, trials.reactTimeMS];
             contrast = [contrast, trials.contrastPC];

             % Some Sessions Had TopUps Others Didn't
             if isfield(stimDesc,'topUpStimulus')
                 topUp = [topUp, stimDesc.topUpStimulus];
             else
                 topUp = [topUp, zeros(1,length(stimDesc))];
             end
         end

         % Clean Up
         clear trials stimDesc file dParams

         % Get Outcomes and Filter
         hit = outcomes == 0; fa = outcomes == 1; miss = outcomes == 2;

         % Create Table Of all trials
         masterTable = table(azimuths', elevations', hit', miss', fa', topUp', stimTrial');
         masterTable.Properties.VariableNames = {'azimuths','elevations','hit','miss','fa','topUp','stimTrial'};

         testedLocs = [];
         % Unique Stimulus Locations
         testedLocs = unique(masterTable(:,[1 2]), 'rows');
         % Find all stimulus conditions that match
         numLocs = size(testedLocs,1);

         %% Change in Perf at each location
         nTrials = [];
         nStimTrials = [];
         nNoStimTrials = [];
         stimHits = [];
         noStimHits = [];
         stimHitRate = [];
         noStimHitRate = [];
         deltaHitRate = [];

         for i = 1:numLocs
             % Stim indexes for this Loc
             idx = table2array(testedLocs(i,:));
             % Logical For Indexing
             stimLogical = masterTable.azimuths == idx(1) & masterTable.elevations == idx(2);
             % Sub Select Table
             subTable = masterTable(stimLogical',3:end);
             % Delete False Alarms
             subTable = subTable(subTable.fa ~= 1,[1,2,4,5]);
             % Delete TopUp Trials
             subTable = subTable(subTable.topUp == 0,[1,2,4]);

             % Number of Trials
             nTrials(i,:) = size(subTable,1);
             % Opto Trials
             nStimTrials = nTrials(i,:) - sum(subTable.stimTrial==0);
             % No-Opto Trials
             nNoStimTrials = nTrials(i,:) - nStimTrials;
             % stimHits
             stimHits = sum(subTable.hit==1 & subTable.stimTrial==1);
             % noStimHits
             noStimHits = sum(subTable.hit==1 & subTable.stimTrial==0);
             % stimHitRate
             stimHitRate(i,:) = stimHits/nStimTrials;
             % noStimHitRate
             noStimHitRate(i,:) = noStimHits/nNoStimTrials;
             % Delta Hit Rate
             deltaHitRate(i,:) = stimHitRate(i)-noStimHitRate(i);
         end

         perfTable = []; % Init
         % Add Performance Data To Table
         perfTable = table(stimHitRate, noStimHitRate, deltaHitRate, nTrials);
         % Append to Output Table
         testedLocs = [testedLocs, perfTable];
         % Only Consider Sessions with more than a certain number of trials
         testedLocs = testedLocs(testedLocs.nTrials>trialCutoff,:);

         %% Now Re-Compute Tested Locs as difference from Experimental Location

         expAz = azimuth(mouse);
         expEl = elevation(mouse);

         for i = 1:height(testedLocs)
             testedLocs.azimuths(i) = expAz - testedLocs.azimuths(i);
             testedLocs.elevations(i) = expEl - testedLocs.elevations(i);
         end

         %% Output Data To Struct
         alignedMaps(mouse).(brainArea{j}) = testedLocs;

     end
 end

