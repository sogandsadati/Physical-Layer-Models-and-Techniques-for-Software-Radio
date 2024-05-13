clc
close all
clear all
 
%% Setting Parameters
Subcarriers = 64;    % total number of subcarrier (IFFT length equal to Subcarriers)
M = 16;              % number of constellations
k = log2(M);         % number of bits per constellation
numOfSym = 10^4;     % number of OFDM Symbols
GI = 1/4;            % Guard Interval or Cyclic Prefix, normaly 25 of the entire OFDM symbols
snr = 15;            % Signal to noise ratio in dB
variance = 0.5;      % variance of the rayleigh distribution

%% --------------------- TRANSMITER --------------------------------------
% Generate Data to be modulated on the subcarriers
TxData = randi([0, 1], Subcarriers, numOfSym);
 
% Implement QAM modulation
TxData_Modulated = qammod(TxData', M, 'InputType','bit');
 
% Perform IFFT
TxData_IFFT = ifft(TxData_Modulated');
 
% Adding cyclic Prefix
TxData_GI = [TxData_IFFT((1-GI)*Subcarriers+1:end,:);TxData_IFFT];
 
% Plotting OFDM signal in time domain
[row , col] = size(TxData_GI);
len = row*col;
ofdm_signal = reshape(TxData_GI, 1, len);
figure(1);
plot(real(ofdm_signal));
xlabel('Time');
ylabel('Amplitude');
title('OFDM Signal');
grid on;
%% ------------------------ CHANNEL ---------------------------------------
BER_vector_Rayleigh = zeros(1,21);
BER_vector_awgn = zeros(1,21);

i = 1;
for snr = -20:2:20

    % % 1) using Rayleigh channel:
    N0 = 1/10^(snr/10);
    for ii = 1:size(TxData_GI,1)
        ray = sqrt((variance)*((randn(1,length(TxData_GI(ii,:)))).^2+(randn(1,length(TxData_GI(ii,:)))).^2));
        % include the fading
        rx = TxData_GI(ii,:).*ray;
        % fading + gaussian noise
        Receive_Channel_rayleigh(ii,:) = rx + sqrt(N0/2)*(randn(1,length(TxData_GI(ii,:)))+1i*randn(1,length(TxData_GI(ii,:))));
    end

    % 2) using AWGN channel
    Receive_Channel_awgn = awgn(TxData_GI ,snr,'measured');

    %% --------------------- RECEIVER ---------------------------------------- 
    % 1)using _Rayleigh Channel
    % Cyclic Prefix  removal
    Recieve_GIremoved_Rayleigh  =  Receive_Channel_rayleigh(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    
    % FFT operation
    RecieveData_FFT_Rayleigh = fft(Recieve_GIremoved_Rayleigh);
    Signal_Magnitude_Rayleigh = real(RecieveData_FFT_Rayleigh);
    Signal_Phase_Rayleigh = imag(RecieveData_FFT_Rayleigh);
    
    % plot the received constellations for a specific subcarrier
    %n = 4; % selected subcarrier
    %scatterplot(RecieveData_FFT_Rayleigh(n,:));
    %title('FFT Output 16-QAM for Rayleigh');
    
    % Demodulation
    RecieveData_Rayleigh = qamdemod(RecieveData_FFT_Rayleigh',M, 'OutputType','bit');
    
    % Number of Bit Errors and Bit Error Rate computation
    [num_Rayleigh , BER_Rayleigh] = biterr(TxData, RecieveData_Rayleigh');
    BER_vector_Rayleigh(1,i) = BER_Rayleigh;
    %%
    % 2)using AWGN Channel
    % Cyclic Prefix  removal
    Recieve_GIremoved_awgn  =  Receive_Channel_awgn(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :);
    
    % FFT operation
    RecieveData_FFT_awgn = fft(Recieve_GIremoved_awgn);
    Signal_Magnitude_awgn = real(RecieveData_FFT_awgn);
    Signal_Phase_awgn = imag(RecieveData_FFT_awgn);
     
    % plot the received constellations for a specific subcarrier
    %n = 4; % selected subcarrier
    %scatterplot(RecieveData_FFT_awgn(n,:));
    %title('FFT Output 16-QAM for AWGN');
     
    % Demodulation
    RecieveData_awgn = qamdemod(RecieveData_FFT_awgn',M, 'OutputType','bit');
     
    % Number of Bit Errors and Bit Error Rate computation
    [num_awgn , BER_awgn] = biterr(TxData, RecieveData_awgn');
    BER_vector_awgn(1,i) = BER_awgn;
    
    i = i+1;
end

figure;
semilogy(1:21, BER_vector_awgn,'-ok', 1:21, BER_vector_Rayleigh, '-or');
grid;
ylabel('BER');
xlabel('SNR [dB]');
legend('AWGN', 'Rayleigh');
