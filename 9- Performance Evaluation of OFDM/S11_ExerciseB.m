
clear
close all
clc

%% -------------------- Setting Parameters----------------------------
Subcarriers = 128; % total number of subcarrier (IFFT length equal to Subcarriers)

Subcarriers1 = 16;
Subcarriers2 = 16;
Subcarriers3 = 16;
Subcarriers4 = 16;

M1 = 16; % number of constellations 16QAM
M2 = 32; % number of constellations 32QAM
M3 = 64; % number of constellations 64QAM
M4 = 256; % number of constellations 256QAM

numOfSym = 21600; % number of OFDM Symbols
numOfSym1 = numOfSym*2;
numOfSym2 = numOfSym*2.5;
numOfSym3 = numOfSym*3;
numOfSym4 = numOfSym*4;

GI = 1/4;  % Guard Interval or Cyclic Prefix, normaly 25 of the entire OFDM symbols
snrV = -20:2:30;   % Signal to noise ratio in dB
ber_awgn = zeros(1, length(snrV));  % vector containing BER values for each SNR
ber_rayleigh = zeros(1, length(snrV));


%% --------------------- TRANSMITER --------------------------------------
% Generate Data to be modulated on the subcarriers
TxData1 = randi([0,M1-1], Subcarriers1, numOfSym1); %Matrix of Subcareer x numOfsym filled with nrandom nums from 1 to M-1(15)                            
TxData2 = randi([0,M2-1], Subcarriers2, numOfSym2);
TxData3 = randi([0,M3-1], Subcarriers3, numOfSym3);
TxData4 = randi([0,M4-1], Subcarriers4, numOfSym4);

% Implement QAM modulation
TxData_Modulated1 = qammod(TxData1,M1);
TxData_Modulated2 = qammod(TxData2,M2);
TxData_Modulated3 = qammod(TxData3,M3);
TxData_Modulated4 = qammod(TxData4,M4);

% % TxData_Modulated = [TxData_Modulated1;TxData_Modulated2;TxData_Modulated3;TxData_Modulated4];

% Perform IFFT
TxData_IFFT1 = ifft(TxData_Modulated1);
TxData_IFFT2 = ifft(TxData_Modulated2);
TxData_IFFT3 = ifft(TxData_Modulated3);
TxData_IFFT4 = ifft(TxData_Modulated4);

% Adding cyclic Prefix
TxData_GI1 = [TxData_IFFT1((1-GI)*Subcarriers+1:end,:);TxData_IFFT1];
TxData_GI2 = [TxData_IFFT2((1-GI)*Subcarriers+1:end,:);TxData_IFFT2];
TxData_GI3 = [TxData_IFFT3((1-GI)*Subcarriers+1:end,:);TxData_IFFT3];
TxData_GI4 = [TxData_IFFT4((1-GI)*Subcarriers+1:end,:);TxData_IFFT4];


snr = 20
%% -------------------------------Channel----------------------------------
fs = 3.84e6; % Hz
pathDelays = [0 200 800 1200 2300 3700]*1e-9; % sec
avgPathGains = [0 -0.9 -4.9 -8 -7.8 -23.9]; % dB
fD = 50; % Hz
rayleighchan = comm.RayleighChannel('SampleRate',fs, ...
        'PathDelays',pathDelays, ...
        'AveragePathGains',avgPathGains, ...
        'MaximumDopplerShift',fD);


tx1 = reshape(TxData_GI1,[],1);
faded_signal1 = rayleighchan(tx1);
faded_signal_plus_noise1 = awgn(faded_signal1, snr, 'measured');
Recieve_Channel1 = reshape(faded_signal_plus_noise1, [], numOfSym/2);  
Receive_Channel_rayleigh1 = Recieve_Channel1;


tx2 = reshape(TxData_GI2,[],1);
faded_signal2 = rayleighchan(tx2);
faded_signal_plus_noise2 = awgn(faded_signal2, snr, 'measured');
Recieve_Channel2 = reshape(faded_signal_plus_noise2, [], numOfSym/2);  
Receive_Channel_rayleigh2 = Recieve_Channel2;

tx3 = reshape(TxData_GI3,[],1);
faded_signal3 = rayleighchan(tx3);
faded_signal_plus_noise3 = awgn(faded_signal3, snr, 'measured');
Recieve_Channel3 = reshape(faded_signal_plus_noise3, [], numOfSym/2);  
Receive_Channel_rayleigh3 = Recieve_Channel3;

tx4 = reshape(TxData_GI4,[],1);
faded_signal4 = rayleighchan(tx4);
faded_signal_plus_noise4 = awgn(faded_signal4, snr, 'measured');
Recieve_Channel4 = reshape(faded_signal_plus_noise4, [], numOfSym/2);  
Receive_Channel_rayleigh4 = Recieve_Channel4;

Receive_Channel_AWGN1 = awgn(TxData_GI1 ,snr,'measured');
Receive_Channel_AWGN1 = reshape(Receive_Channel_AWGN1, [], numOfSym/2);  
Receive_Channel_AWGN2 = awgn(TxData_GI2 ,snr,'measured');
Receive_Channel_AWGN2 = reshape(Receive_Channel_AWGN2, [], numOfSym/2); 
Receive_Channel_AWGN3 = awgn(TxData_GI3 ,snr,'measured');
Receive_Channel_AWGN3 = reshape(Receive_Channel_AWGN3, [], numOfSym/2); 
Receive_Channel_AWGN4 = awgn(TxData_GI4 ,snr,'measured');
Receive_Channel_AWGN4 = reshape(Receive_Channel_AWGN4, [], numOfSym/2); 


%% -------------------------------Receiver--------------------------------
    % Cyclic Prefix  removal
    Recieve_GIremoved_Rayleigh1  =  Receive_Channel_rayleigh1(GI*Subcarriers1+1 : Subcarriers1+GI*Subcarriers1, :); 
    Recieve_GIremoved_Rayleigh2  =  Receive_Channel_rayleigh2(GI*Subcarriers2+1 : Subcarriers2+GI*Subcarriers2, :); 
    Recieve_GIremoved_Rayleigh3  =  Receive_Channel_rayleigh3(GI*Subcarriers3+1 : Subcarriers3+GI*Subcarriers3, :); 
    Recieve_GIremoved_Rayleigh4  =  Receive_Channel_rayleigh4(GI*Subcarriers4+1 : Subcarriers4+GI*Subcarriers4, :); 

    Recieve_GIremoved_AWGN1  =  Receive_Channel_AWGN1(GI*Subcarriers1+1 : Subcarriers1+GI*Subcarriers1, :); 
    Recieve_GIremoved_AWGN2  =  Receive_Channel_AWGN2(GI*Subcarriers2+1 : Subcarriers2+GI*Subcarriers2, :); 
    Recieve_GIremoved_AWGN3  =  Receive_Channel_AWGN3(GI*Subcarriers3+1 : Subcarriers3+GI*Subcarriers3, :); 
    Recieve_GIremoved_AWGN4  =  Receive_Channel_AWGN4(GI*Subcarriers4+1 : Subcarriers4+GI*Subcarriers4, :); 

    % FFT operation
    RecieveData_FFT_Rayleigh1 = fft(Recieve_GIremoved_Rayleigh1);
    RecieveData_FFT_Rayleigh2 = fft(Recieve_GIremoved_Rayleigh3);
    RecieveData_FFT_Rayleigh3 = fft(Recieve_GIremoved_Rayleigh3);
    RecieveData_FFT_Rayleigh4 = fft(Recieve_GIremoved_Rayleigh4);

    RecieveData_FFT_AWGN1 = fft(Recieve_GIremoved_AWGN1);
    RecieveData_FFT_AWGN2 = fft(Recieve_GIremoved_AWGN2);
    RecieveData_FFT_AWGN3 = fft(Recieve_GIremoved_AWGN3);
    RecieveData_FFT_AWGN4 = fft(Recieve_GIremoved_AWGN4);

    % Demodulation
    RecieveData_Rayleigh1 = qamdemod(RecieveData_FFT_Rayleigh1(Subcarriers1,:),M1);
    RecieveData_Rayleigh2 = qamdemod(RecieveData_FFT_Rayleigh2(Subcarriers2,:),M2);
    RecieveData_Rayleigh3 = qamdemod(RecieveData_FFT_Rayleigh3(Subcarriers3,:),M3);
    RecieveData_Rayleigh4 = qamdemod(RecieveData_FFT_Rayleigh4(Subcarriers4,:),M4);

    RecieveData_AWGN1 = qamdemod(RecieveData_FFT_AWGN1(Subcarriers1,:),M1);
    RecieveData_AWGN2 = qamdemod(RecieveData_FFT_AWGN2(Subcarriers2,:),M2);
    RecieveData_AWGN3 = qamdemod(RecieveData_FFT_AWGN3(Subcarriers3,:),M3);
    RecieveData_AWGN4 = qamdemod(RecieveData_FFT_AWGN4(Subcarriers4,:),M4);

    % Number of Bit Errors and Bit Error Rate computation
    [num_Rayleigh1 , BER_Rayleigh1] = biterr(TxData1, RecieveData_Rayleigh1);
    [num_Rayleigh2 , BER_Rayleigh2] = biterr(TxData2, RecieveData_Rayleigh2);
    [num_Rayleigh3 , BER_Rayleigh3] = biterr(TxData3, RecieveData_Rayleigh3);
    [num_Rayleigh4 , BER_Rayleigh4] = biterr(TxData4, RecieveData_Rayleigh4);

    [num_AWGN1 , BER_AWGN1] = biterr(TxData1, RecieveData_AWGN1);
    [num_AWGN2 , BER_AWGN2] = biterr(TxData2, RecieveData_AWGN2);
    [num_AWGN3 , BER_AWGN3] = biterr(TxData3, RecieveData_AWGN3);
    [num_AWGN4 , BER_AWGN4] = biterr(TxData4, RecieveData_AWGN4);