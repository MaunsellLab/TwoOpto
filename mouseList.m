function [animals] = mouseList(dataCode)
% Returns MasterList of mice for TwoOpto Experiment depending on histology

% dataCodes
% 1 = SC, V1 correct placements
% 2 = SC only
% 3 = V1 only 
% 4 = Control Mice
% 5 = All

if dataCode == 1 % SC/V1
    animals = {'2365','2401','2452', '2454','2456',...
        '2475','2476','2485','2588','2590'};
elseif dataCode == 2 % SC Only 
    animals = {'2623'};
elseif dataCode == 3 % V1 Only
    animals = {'2401','2452'};
elseif dataCode == 4 % Controls
    animals = {'2396','2397','2453','2487','2589','2623'};
elseif dataCode == 5
    animals = {'2365','2396','2397',...
        '2401','2452','2453','2454','2456','2475','2476','2485','2487',...
        '2588','2589', '2590', '2623'};
end
