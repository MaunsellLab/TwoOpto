% Probability Simulation

% Simulates detection performance based on activity at two distinct sites.
% Measures the change in detection probability depending on whether the
% signals are integrated (signal summation) 
% or decoded independently (probability summation) 


% In the unperturbed condition, performance = s
% Does s = s0 + s1 or does s = max(s0,s1)

% Assumptions
% Each site has independent noise (n0, n1)
% Each site sees some signal contaminated with noise (s0, s1)


% Signal Summation - the two signals are summed before being passed to
% decoder. Responses occur when the summed signal hits criterion. Sum the
% of two samples.

% Probability Summation - the two sites engage independent circuits all the
% way to the decoder mechanism. Responses occur whenever either of the two
% sites reach criterion. Max of the two samples.

% d' measured versus d' sum/ d' max

% In the SC/V1 stimualtion experiments

% unstimulated condition - control (s)
% V1 stimulation - delta hit rate/ delta d' estimates 
% s = (s0-perturbation) + s1
% SC stimulation - delta hit rate/ delta d' estimates
% s = s0 + (s1-perturbation)
% twoOpto - delta hit rate/delta d' estimates
% s = (s0-perturbation) + (s1-perturbation)

% Need to produce a landscape of s for both decoder types for different
% degrees of perturbation strength.

% We observe delta hit rate/delta d' for s0, s1, and s0+s1

%% Get Actual Performance Values
[masterStruct] = twoOptoGetData();
dPrimes = [masterStruct.dPrimes];
control = [dPrimes(:).noOpto];
V1d = [dPrimes(:).V1];
SCd = [dPrimes(:).SC];
twoOpto = [dPrimes(:).twoOpto];
%% Probability Summation Model

% According to signal summation, the observed d' corresponds to:
% d'= d' (V1) + d'(SC)

% Range of d'
d = 0:0.1:4; 
% Grid it
[X,Y] = meshgrid(d, d);
% Signal Summation d'
perfGrid = X + Y;

% Make a plot
figure; axis square; hold on;
surf(perfGrid);
xlabel('V1 d'''); ylabel('SC d''');
set(gca, 'FontSize', 14); set(gca, 'TickDir', 'out');
title('Control Performance Signal Summation');
xlim([0 41]); ylim([0 41]); shading interp;
set(gca, 'XTick', [0 10 20 30 40]); set(gca, 'YTick', [0 10 20 30 40]); 
set(gca, 'XTickLabel', {'0', '1', '2', '3', '4'});
set(gca, 'YTickLabel', {'0', '1', '2', '3', '4'});
h = colorbar; h.Label.String = 'd'' Signal Summation';
h.Label.Rotation = 270; h.Label.VerticalAlignment = "bottom";
view(315,45); hold off;

%%
V1deltaD = nanmedian(control) - nanmedian(V1d);
SCdeltaD = nanmedian(control) - nanmedian(SCd);
[X2p, Y2p] = meshgrid(d-V1deltaD, d-SCdeltaD);
predSS_grid = X2p + Y2p;

figure; axis square; hold on;
surf(predSS_grid);
xlabel('V1 d'''); ylabel('SC d''');
set(gca, 'FontSize', 14); set(gca, 'TickDir', 'out');
title('TwoOpto Performance Signal Summation');
xlim([0 41]); ylim([0 41]); shading interp;
set(gca, 'XTick', [0 10 20 30 40]); set(gca, 'YTick', [0 10 20 30 40]); 
set(gca, 'XTickLabel', {'0', '1', '2', '3', '4'});
set(gca, 'YTickLabel', {'0', '1', '2', '3', '4'});
h = colorbar; h.Label.String = 'd'' Signal Summation';
h.Label.Rotation = 270; h.Label.VerticalAlignment = "bottom";
view(315,45); hold off;

%% Probability Summation

% In probability summation model
% d' = max(d'(V1), d'(SC))








