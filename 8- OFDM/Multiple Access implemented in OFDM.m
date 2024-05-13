
%% Setting Parameters
Subcarriers = 64;  % total number of subcarrier (IFFT length equal to Subcarriers) N
Subcarriers1 = 16;
Subcarriers2 = 16;
Subcarriers3 = 16;
Subcarriers4 = 16;

M1 = 4;            % number of constellations 4-QAM
M2 = 16;           % number of constellations 16-QAM
M3 = 64;           % number of constellations 64-QAM
M4 = 256;          % number of constellations 256-QAM
k1 = log2(M1);     % number of bits per constellation m
k2 = log2(M2);     % number of bits per constellation m
k3 = log2(M3);     % number of bits per constellation m
k4 = log2(M4);     % number of bits per constellation m
numOfSym = 10^4;   % number of OFDM Symbols  
GI = 1/4;          % Guard Interval or Cyclic Prefix, normaly 0.25 of the entire OFDM symbols 
snr = 15;          % Signal to noise ratio in dB


%% --------------------- TRANSMITER --------------------------------------
% Generate Data to be modulated on the subcarriers
TxData1 = randi([0,M1-1], Subcarriers1, numOfSym); %Matrix of Subcareer x numOfsym filled with nrandom nums from 1 to M-1(15)                            
TxData2 = randi([0,M2-1], Subcarriers2, numOfSym);
TxData3 = randi([0,M3-1], Subcarriers3, numOfSym);
TxData4 = randi([0,M4-1], Subcarriers4, numOfSym);

% Implement QAM modulation
TxData_Modulated1 = qammod(TxData1,M1);
TxData_Modulated2 = qammod(TxData2,M2);
TxData_Modulated3 = qammod(TxData3,M3);
TxData_Modulated4 = qammod(TxData4,M4);

TxData_Modulated = [TxData_Modulated1;TxData_Modulated2;TxData_Modulated3;TxData_Modulated4];

% Perform IFFT
TxData_IFFT = ifft(TxData_Modulated);
 
% Adding cyclic Prefix
TxData_GI = [TxData_IFFT((1-GI)*Subcarriers+1:end,:);TxData_IFFT];
 
% Plotting OFDM signal in time domain 
[row , col] = size(TxData_GI);
len = row*col; %for here is 80k
ofdm_signal = reshape(TxData_GI, 1, len); %returns 1 x 80,000 matrix with TxData_GI 's elemnts in that vector
figure(1);
plot(real(ofdm_signal)); 
xlabel('Time'); 
ylabel('Amplitude');
title('OFDM Signal');
grid on;


%% Channel
BER_vector1 = zeros(1,21);
BER_vector2 = zeros(1,21);
BER_vector3 = zeros(1,21);
BER_vector4 = zeros(1,21);

i = 1;
for snr = -20:2:20
    rx_signal = awgn(TxData_GI ,snr,'measured');
    

    %% --------------------- RECEIVER ----------------------------------------
    
    % Cyclic Prefix  removal
    Recieve_GIremoved  =  rx_signal(GI*Subcarriers+1 : Subcarriers+GI*Subcarriers, :); 
     
    % FFT operation
    RecieveData_FFT = fft(Recieve_GIremoved);
    Signal_Magnitude = real(RecieveData_FFT);
    Signal_Phase = imag(RecieveData_FFT);
     
    % plot the received constellations for a specific subcarrier
    % figure(2)
    % subplot(5,4,i);
    n = 4; % selected subcarrier out of 64
    %scatterplot(RecieveData_FFT(n,:)); 
    %title('FFT Output 16-QAM');
     
    % Demodulation
    RecieveData1 = qamdemod(RecieveData_FFT(1 :16,:),M1);
    RecieveData2 = qamdemod(RecieveData_FFT(17:32,:),M2);
    RecieveData3 = qamdemod(RecieveData_FFT(33:48,:),M3);
    RecieveData4 = qamdemod(RecieveData_FFT(49:64,:),M4);
 
    % Number of Bit Errors and Bit Error Rate computation
    [num1 , BER1] = biterr(TxData1, RecieveData1);
    [num2 , BER2] = biterr(TxData2, RecieveData2);
    [num3 , BER3] = biterr(TxData3, RecieveData3);
    [num4 , BER4] = biterr(TxData4, RecieveData4);


    BER_vector1(1,i) = BER1;
    BER_vector2(1,i) = BER2;
    BER_vector3(1,i) = BER3;
    BER_vector4(1,i) = BER4;

    EbNoVec = snr - 10*log10(k); % in terms of energy per bit to noise power spectral density ratio (Eb/No)
    ber_theo(1, i) = berawgn(EbNoVec,'qam',M);

    i = i+1;
end

figure
semilogy(1:21, BER_vector1,'-ok',1:21, BER_vector2,'-ob',1:21, BER_vector3,'-oy',1:21, BER_vector4,'-og', 1:21, ber_theo);
grid;
ylabel('BER');
xlabel('SNR [dB]');
legend('AWGN-simulation', 'AWGN-theoretical');

