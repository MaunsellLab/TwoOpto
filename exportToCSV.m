% Convert twoOpto Data to Table
% First run twoOptoGetData

for i = 1:length(masterStruct)
    % Which mouse did the data come from
    mouse{i,1}     = masterStruct(i).mouse;
    
    % d-Primes
    noStimDp(i,1)  = masterStruct(i).dPrimes.noOpto;
    v1StimDp(i,1)  = masterStruct(i).dPrimes.V1;
    scStimDp(i,1)  = masterStruct(i).dPrimes.SC;
    obStimDp(i,1)  = masterStruct(i).dPrimes.twoOpto;

    % criterions
    noStimC(i,1)   = masterStruct(i).criterions.noOpto;
    v1StimC(i,1)   = masterStruct(i).criterions.V1;
    scStimC(i,1)   = masterStruct(i).criterions.SC;
    obStimC(i,1)   = masterStruct(i).criterions.twoOpto;

    % Impact of Inhibition
    v1DeltaDp(i,1) = masterStruct(i).v1DeltaDp;
    scDeltaDp(i,1) = masterStruct(i).scDeltaDp;
    obDeltaDp(i,1) = masterStruct(i).twoOptoDeltaDp;
    
    % Trial Counts
    nNoStim(i,1)   = masterStruct(i).trialCounts.noOpto;
    nV1Stim(i,1)   = masterStruct(i).trialCounts.V1;
    nSCStim(i,1)   = masterStruct(i).trialCounts.SC;
    nDualStim(i,1) = masterStruct(i).trialCounts.twoOpto;
    
    % Lapse and False Alarms
    faRate(i,1)    = masterStruct(i).faRate;
    lapseRate(i,1) = masterStruct(i).lapseRate;
end


% Export to Table
masterTable = table(mouse,noStimDp,v1StimDp,scStimDp,obStimDp,....
    noStimC,v1StimC,scStimC,obStimC,v1DeltaDp,scDeltaDp,obDeltaDp,...
    nNoStim,nV1Stim,nSCStim,nDualStim,faRate,lapseRate);

writetable(masterTable,'twoOptoTable.csv');
 
