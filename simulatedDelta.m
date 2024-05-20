% simulatedDelta

% Simulates detection performance based on activity at two distinct sites 
% depending on whether the signals are integrated (signal summation) 
% or decoded independently (probability summation) 

% Signal Summation - the two signals are integrated before being passed a
% decoder. Responses occur when the total signal hits criterion. 
% The resultant d' is simply sum of the two independent d's.

% Probability Summation - the two sites engage independent circuits all the
% way to the decoder. Responses occur whenever either of the two
% sites reach criterion. Max of the two samples.

%% Summation MODEL

% range of d' for V1 and SC
d = 0:0.05:4;

% Set up Grid for Expected d'
sumGrid = zeros(length(d), length(d));

% Expected d' for sum model given specific V1 and SC d'
for v1d = 1:length(d)
    for scd = 1:length(d)
        sumGrid(v1d,scd) = d(v1d) + d(scd);
    end
end

% Show Expected d' Grid
figure;
surf(d,d,sumGrid);
xlabel('V1 d''');
ylabel('SC d''');
zlabel('Expected d''');
set(gca, 'FontSize', 14);
title('Predicted d'' Signal Summation');

%% Expected delta d' given observed impairment produced by V1 and SC
% For the summation model, it's simple
% s = s0 + s1
% s = (s0-perturbation) + (s1-perturbation)
% Equivalently
% d' = d'v1 + d'sc - (deltad'v1 + deltad'sc)





%% MAX Model in Y/N Task

% d' = z(H) - z(FA)

% z(H)  = (mu_s - c)/sigma_s
% z(FA) = (mu_n - c)/sigma_n
% k = sigma_s/sigma_n











% In the unperturbed condition, performance = s
% Does s = s0 + s1 or does s = max(s0,s1)

% Assumptions
% Each site has independent noise (n0, n1)
% Each site sees some signal contaminated with noise (s0, s1)




% d' measured versus d' sum/ d' max

% In the SC/V1 experiments

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

