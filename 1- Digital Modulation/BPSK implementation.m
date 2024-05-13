%Generating the SRC
n = 6000;
x = randi([0 1], n, 1);
%Number of constellations due to the Modulation Technique
M1 = 2;
%Number of bits per constellations:
m1 = log2(M1);
% Y = pskmod(X,M) 
%outputs the complex envelope of the modulation of the message signal X, using the phase shift keying (PSK) modulation.
%The message signal X must consist of integers between 0 and M-1
%M is the alphabet size and must be an integer greater than 1.

%BPSK Modulation
BPSK = pskmod(x, M1);

%Plot Transmitted signal
scatterplot(BPSK);
title('BPSK Transmitted');
%BPSK = pskmod(x, M1, 'PlotConstellation', true);


%Add white Gaussian Noise to the signal:
snr = -10;
r1 = awgn(BPSK,snr);

%Plot Received Signal
scatterplot(r1);
title('BPSK Received');

%Demodulate Received signal
demod_BPSK = pskdemod(r1, M1);

%Err Check in the bit stream
err_bit1 = 0;
for i=1:n
    if demod_BPSK(i) == x(i)
        err_bit1 = err_bit1;
    else
        err_bit1 = err_bit1 +1;
    end
end


% By changing the SNR value, the received signal changes. the higher the SNR
% the better the received BPSK would be more similar to
% transmitted BPSK.

