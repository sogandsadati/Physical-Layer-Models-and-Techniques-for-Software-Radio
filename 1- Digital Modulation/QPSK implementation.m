%Generating the SRC
n = 6000;
x2 = randi([0 1], n, 1);

%Number of constellations due to the Modulation Technique
M2 = 4;

%Number of bits per constellations:
m2 = log2(M2);

%4-QAM Modulation
QAM4 = qammod(x2, M2,'InputType','bit');

%Plot Transmitted Signal
scatterplot(QAM4);
title('4-QAM Transmitted');


%Add white Gaussian Noise to the signal:
snr = 40;
r2 = awgn(QAM4,snr);

%Plot Received Signal
scatterplot(r2);
title('4-QAM Received');

%Demodulate Received signal
demod_QAM4 = qamdemod(r2, M2);


%Err Check in the bit stream
err_bit2 = 0;
for i=1:n
    if demod_QAM4(i) == x2(i)
        err_bit2 = err_bit2;
    else
        err_bit2 = err_bit2 +1;
    end
end