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
[masterStruct] = twoOptoGetData(1);
dPrimes = [masterStruct.dPrimes];
control = [dPrimes(:).noOpto];
V1d = [dPrimes(:).V1];
SCd = [dPrimes(:).SC];
twoOpto = [dPrimes(:).twoOpto];

% Observed Delta d'
deltaD_ob = twoOpto-control; % twoOpto Condition
deltaD_V1 = V1d - control; % V1 stimulation
deltaD_SC = SCd - control; % SC stimulation

% delta
deltaD_predSS = deltaD_V1 + deltaD_SC;

% deltaD_predPS 
% This is a little more complicated
% if both negative, take the max (the less negative Delta d')
% if both positive, take the max (the more positive)
% if V1 is negative and SC postive, take V1
% if SC is negative, and V1 positive, take SC

deltaD_predPS = zeros(1,length(masterStruct));
for i = 1:length(masterStruct)
    if deltaD_V1(1,i) <= 0 && deltaD_SC(1,i) <= 0
        deltaD_predPS(1,i) = max(deltaD_V1(1,i), deltaD_SC(1,i));
    elseif deltaD_V1(1,i) >= 0 && deltaD_SC(1,i) >= 0
        deltaD_predPS(1,i) = max(deltaD_V1(1,i), deltaD_SC(1,i));
    elseif deltaD_V1(1,i) < 0 && deltaD_SC(1,i) >= 0
        deltaD_predPS(1,i) = deltaD_SC(1,i);
    elseif deltaD_V1(1,i) >= 0 && deltaD_SC(1,i) < 0
        deltaD_predPS(1,i) = deltaD_V1(1,i);
    else
        deltaD_predPS(1,i) = NaN;
    end
end

%% Scatter Plot of Observed vs. Predicted

figure('Position',[10 10 1000 500]);
subplot(1,2,1);
% Mean Absolute Deviation
MAD_SS = nansum(abs(deltaD_ob - deltaD_predSS))/length(deltaD_ob); %#ok<NANSUM> 
hold on;
axis square;
scatter(deltaD_ob,deltaD_predSS, 30, 'k', 'filled');
plot([-2.5 1.5], [-2.5 1.5], 'LineStyle', '--', 'Color', 'r'); % Unity Line
xlabel('delta d'' Observed'); ylabel('delta d'' Predicted');
xlim([-2.5 1.5]); ylim([-2.5 1.5]);
set(gca, 'FontSize', 16); set(gca, 'TickDir', 'out');
title('Signal Summation');
set(gca, 'XTick', [-2 -1 0 1]); set(gca, 'YTick', [-2 -1 0 1]); 
set(gca, 'XTickLabel', {'-2', '-1', '0', '1'});
set(gca, 'YTickLabel', {'-2', '-1', '0', '1'});
text(-2, 1, sprintf('MAD = %0.3f', MAD_SS), 'FontSize', 14);
hold off;

subplot(1,2,2);
% Mean Absolute Deviation
MAD_PS = nansum(abs(deltaD_ob - deltaD_predPS))/length(deltaD_ob); %#ok<NANSUM> 
hold on;
axis square;
scatter(deltaD_ob,deltaD_predPS, 30, 'k', 'filled');
plot([-2.5 1.5], [-2.5 1.5], 'LineStyle', '--', 'Color', 'r'); % Unity Line
xlabel('delta d'' Observed'); ylabel('delta d'' Predicted');
xlim([-2.5 1.5]); ylim([-2.5 1.5]);
set(gca, 'FontSize', 16); set(gca, 'TickDir', 'out');
title('Probability Summation');
set(gca, 'XTick', [-2 -1 0 1]); set(gca, 'YTick', [-2 -1 0 1]); 
set(gca, 'XTickLabel', {'-2', '-1', '0', '1'});
set(gca, 'YTickLabel', {'-2', '-1', '0', '1'});
text(-2, 1, sprintf('MAD = %0.3f', MAD_PS), 'FontSize', 14);
hold off;

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
set(gca, 'FontSize', 16); set(gca, 'TickDir', 'out');
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
set(gca, 'FontSize', 16); set(gca, 'TickDir', 'out');
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









