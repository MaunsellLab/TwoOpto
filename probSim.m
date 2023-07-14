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




