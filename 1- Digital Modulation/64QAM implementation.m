%Generating the SRC
n = 6000;
x4 = randi([0 1], n, 1);

%Number of constellations due to the Modulation Technique
M4 = 64;

%Number of bits per constellations:
m4 = log2(M4);

%64-QAM Modulation
QAM64 = qammod(x4, M4,'InputType','bit');

%Plot Transmitted Signal
scatterplot(QAM64);
title('64-QAM Transmitted');


%Add white Gaussian Noise to the signal:
snr = 20;
r4 = awgn(QAM64,snr);

%Plot Received Signal
scatterplot(r4);
title('64-QAM Received');

%Demodulate Received signal
demod_QAM64 = qamdemod(r4, M4, 'OutputType', 'bit');


%Err Check in the bit stream
err_bit4 = 0;
for i=1:n
    if demod_QAM64(i) == x4(i)
        err_bit4 = err_bit4;
    else
        err_bit4 = err_bit4 +1;
    end
end