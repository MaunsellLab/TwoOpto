function [locs] = stimLocations(dataCode)
% Returns MasterList of stimulus Locations for TwoOpto Experiment

% ALIGNED CONDITION
% 2365 - (20,0) % 2401 - (30,-5) % 2452 - (20,0) % 2454 - (25,5)
% 2456 - (30,5) % 2475 - (25,0)  % 2476 - (25,0) % 2485 - (30,5)
% 2588 - (20,-15) % 2590 - (30,5)

% MISALIGNED CONDITION
% 2365 - (20,-5) % 2401 - (30,0) % 2452 - (20,5) % 2454 - (15,0)
% 2456 - (25,0) % 2475 - (30,0)  % 2476 - (20,5) % 2485 - (20,0)
% 2588 - (15,-5) % 2590 - (15,-5)
% CONTROL ANIMALS 

% 2396 - (25,0) % 2397 - (20,0) % 2453 - (25,5)
% 2487 - (25,0) % 2589 - (15,5) % 2623 - (30,0)

% dataCodes
% 1 = SC, V1 aligned
% 2 = SC, V1 misaligned 
% 3 = Control Mice

if dataCode == 1 % SC/V1 Aligned
    animals  = {'2365','2401','2452', '2454','2456',...
        '2475','2476','2485','2588','2590'};
    azimuth   = [20, 30, 20, 25, 30, 25, 25, 30, 20, 30];
    elevation = [0, -5, 0, 5, 5, 0, 0, 5, -15, 5];

elseif dataCode == 2 % SC/V1 Misaligned
    animals  = {'2365','2401','2452', '2454','2456',...
        '2475','2476','2485','2588','2590'};
    azimuth   = [20, 30, 20, 15, 25, 30, 20, 20, 15, 15];
    elevation = [-5, 0, 5, 0, 0, 0, 5, 0, -5, -5];

elseif dataCode == 3 % Controls
    animals = {'2396','2397', '2453', '2487', '2589', '2623'};
    azimuth   = [25, 20, 25, 25, 15, 30];
    elevation = [0, 0, 5, 0, 5, 0];
end

locs = table(animals', azimuth', elevation');
locs.Properties.VariableNames = {'animals', 'azimuth', 'elevation'};

end


