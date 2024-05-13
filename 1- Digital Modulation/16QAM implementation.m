%Generating the SRC
n = 6000;
x3 = randi([0 1], n, 1);

%Number of constellations due to the Modulation Technique
M3 = 16;

%Number of bits per constellations:
m3 = log2(M3);

%16-QAM Modulation
QAM16 = qammod(x3, M3,'InputType','bit');

%Plot Transmitted Signal
scatterplot(QAM16);
title('16-QAM Transmitted');


%Add white Gaussian Noise to the signal:
snr = 0;
r3 = awgn(QAM16,snr);

%Plot Received Signal
scatterplot(r3);
title('16-QAM Received');

%Demodulate Received signal
demod_QAM16 = qamdemod(r3, M3, 'OutputType', 'bit');


%Err Check in the bit stream
err_bit3 = 0;
for i=1:n
    if demod_QAM16(i) == x3(i)
        err_bit3 = err_bit3;
    else
        err_bit3 = err_bit3 +1;
    end
end