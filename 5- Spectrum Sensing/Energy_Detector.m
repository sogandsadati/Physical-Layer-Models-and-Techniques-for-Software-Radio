clc
clear
close all
 
%% Load the OFDM signal (at the secondary user side)
load('rxOFDM_signal.mat');
 
%% Extract a specific sub-carrier to search the presence of the Primary User
signal = rxOFDM_signal(6,:);
 
%% Create the Ground Truth
ground_truth = zeros(1, size(rxOFDM_signal,2));
for i=1:size(signal,2)
    if abs(signal(1,i)) >= 1 % if the amplitude of symbol i greater or equal to 1 -> the PU is present
        ground_truth(1,i) = 1; % 1: PU is present /  0: PU is absent
    end
end
 
%% Calculate the energy of each OFDM symbol
for j=1:size(signal,2)
    energy_signal(1,j) = (abs(signal(1,j))).^2;
end
 
%% Normalize the energy signal
dataNorm = normalize(energy_signal);
 
%% Calculate the ROC
[Roc_f] = Roc_calculation(dataNorm, ground_truth);
 
x = [0 1];
y = [1 0];
z = [0 1];
zz = [0 1];
figure;
sm=0.8;
plot(smooth(Roc_f(1,:),sm), smooth(Roc_f(2,:),sm), 'LineWidth',3);
hold on;
plot(x,y, '--', 'LineWidth',1.2);
plot(z,zz,'--', 'LineWidth',1.2);
title('ROC');
xlabel('Probability of False Alarm (Pfa)');
ylabel('Probability of Detection (Pd)');
grid on;
