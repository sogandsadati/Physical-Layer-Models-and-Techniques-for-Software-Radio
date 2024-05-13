clc
close all
clear all
 
%% Initial parameters
SNR = 5;    % Signal to Noise ratio in dB
Fc = 1;     % carrier frequency
Eb = 2;     % energy per bit
Tb = 1;     % time per bit of message sequence
 
%% Consider two mobile users in the system
mobileUser1 = [1 0 0 1 1 0];    % data transmitted by user 1
 
mobileUser2 = [1 1 0 1 0 0];    % data transmitted by user 2
 
mobileUser3 = [1 1 1 0 0 0];    % data transmitted by user 3
 
mobileUser4 = [0 0 0 1 1 1];    % data transmitted by user 4

length_mobileUser1 = length(mobileUser1);
 
length_mobileUser2 = length(mobileUser2);
 
length_mobileUser3 = length(mobileUser3);
 
length_mobileUser4 = length(mobileUser4);

%% 1.    Convert input bits to bipolar bits. 1 to 1 and 0 to -1 for user1 and user2 and user3 and user4
% Convert data sequence into NRZ format
for i = 1:length_mobileUser1
    if mobileUser1(i) == 0
        mobileUser1(i) = -1;
    end
end
 
for i = 1:length_mobileUser2
    if mobileUser2(i) == 0
        mobileUser2(i) = -1;
    end
end

for i = 1:length_mobileUser3
    if mobileUser3(i) == 0
        mobileUser3(i) = -1;
    end
end

for i = 1:length_mobileUser4
    if mobileUser4(i) == 0
        mobileUser4(i) = -1;
    end
end
%% 2.    Take 100 samples per bit for both user1 and user2 and then plot base band signal which is in bipolar NRZ (non-return-to-zero) format.
%CDMA transmitter user1
user1basebandsig1 = []; 
for i = 1:length_mobileUser1
    for j = 0.01:0.01:Tb    % 100 samples per bit
        if mobileUser1(i) == 1
            user1basebandsig1 = [user1basebandsig1 1];
        else
            user1basebandsig1 = [user1basebandsig1 -1];
        end
    end
end

figure(1);
subplot(211)
plot(user1basebandsig1);
axis([0 100*length_mobileUser1 -1.5 1.5]);
title('Original Binary Sequence for  User1 is')
grid on

%CDMA transmitter user2
user2basebandsig2 = [];
for i = 1:length_mobileUser2
    for j = 0.01:0.01:Tb
        if mobileUser2(i) == 1
            user2basebandsig2 = [user2basebandsig2 1];
        else
            user2basebandsig2 = [user2basebandsig2 -1];
        end
    end
end

figure(2);
subplot(211)
plot(user2basebandsig2, 'r');
axis([0 100*length_mobileUser2 -1.5 1.5]);
title('Original Binary Sequence for User2 is')
grid on

%CDMA transmitter user3
user3basebandsig3 = [];
for i = 1:length_mobileUser3
    for j = 0.01:0.01:Tb
        if mobileUser3(i) == 1
            user3basebandsig3 = [user3basebandsig3 1];
        else
            user3basebandsig3 = [user3basebandsig3 -1];
        end
    end
end

figure(3);
subplot(211)
plot(user3basebandsig3, 'r');
axis([0 100*length_mobileUser3 -1.5 1.5]);
title('Original Binary Sequence for User3 is')
grid on

%CDMA transmitter user4
user4basebandsig4 = [];
for i = 1:length_mobileUser4
    for j = 0.01:0.01:Tb
        if mobileUser4(i) == 1
            user4basebandsig4 = [user4basebandsig4 1];
        else
            user4basebandsig4 = [user4basebandsig4 -1];
        end
    end
end

figure(4);
subplot(211)
plot(user4basebandsig4, 'r');
axis([0 100*length_mobileUser4 -1.5 1.5]);
title('Original Binary Sequence for User4 is')
grid on

%% 3.    Then BPSK modulate the signal. Take care that sampling rate of sinusoidal carrier matches the sampling rate per bit. Here it is 100 samples per carrier and then plot the BPSK signal.
% BPSK MODULATION FOR USER 1
user1bpskmod1 = [];
for i = 1:length_mobileUser1
    for j = 0.01:0.01:Tb    % 100 samples per bit
        user1bpskmod1 = [user1bpskmod1 sqrt(2*Eb)*mobileUser1(i)*cos(2*pi*Fc*j)];
    end
end

%Plot of BPSK MODULATION FOR USER 2 
figure(1);
subplot(212)
plot(user1bpskmod1);
title(' BPSK Signal for  User 1 is');
grid on

% BPSK MODULATION FOR USER 2 
user2bpskmod2 = [];
for i = 1:length_mobileUser2
    for j = 0.01:0.01:Tb
        user2bpskmod2 = [user2bpskmod2 sqrt(2*Eb)*mobileUser2(i)*cos(2*pi*Fc*j)];
    end
end

%Plot of BPSK MODULATION FOR USER 2 
figure(2);
subplot(212)
plot(user2bpskmod2, 'r');
title(' BPSK Signal for User 2 is');
grid on

% BPSK MODULATION FOR USER 3 
user3bpskmod3 = [];
for i = 1:length_mobileUser3
    for j = 0.01:0.01:Tb
        user3bpskmod3 = [user3bpskmod3 sqrt(2*Eb)*mobileUser3(i)*cos(2*pi*Fc*j)];
    end
end

%Plot of BPSK MODULATION FOR USER 3 
figure(3);
subplot(212)
plot(user3bpskmod3, 'r');
title(' BPSK Signal for User 3 is');
grid on

% BPSK MODULATION FOR USER 4 
user4bpskmod4 = [];
for i = 1:length_mobileUser4
    for j = 0.01:0.01:Tb
        user4bpskmod4 = [user4bpskmod4 sqrt(2*Eb)*mobileUser4(i)*cos(2*pi*Fc*j)];
    end
end

%Plot of BPSK MODULATION FOR USER 4 
figure(4);
subplot(212)
plot(user4bpskmod4, 'r');
title(' BPSK Signal for User 4 is');
grid on

%% 4.    perform the function of exclusive or gate and shift registers.
% PN generator for user1

% let initial seed for user1 is 1010
seed1 = [1 -1 1 -1];  
pn1_user_1 = [];
 
% let initial seed for user2 is 0101
seed2 = [-1 1 -1 1];  
pn2_user_2 = [];

% let initial seed for user3 is 0000
seed3 = [-1 -1 -1 -1]; 
pn3_user_3 = [];
 
% let initial seed for user4 is 1111
seed4 = [1 1 1 1];  
pn4_user_4 = [];


% The following for loop performs the function of exclusive or gate and shift registers (with respect to the CDMA standard). 
%User1
for i = 1:length_mobileUser1
    for j = 1:10 %chip rate is 10 times the bit rate
        pn1_user_1 = [pn1_user_1 seed1(4)];
        if seed1(4) == seed1(3) 
            temp = -1;
        else
            temp = 1;
        end
        seed1(4) = seed1(3);
        seed1(3) = seed1(2);
        seed1(2) = seed1(1);
        seed1(1) = temp;
    end
end

%User2
for i = 1:length_mobileUser2
    for j = 1:10 %chip rate is 10 times the bit rate
        pn2_user_2 = [pn2_user_2 seed2(4)];
        if seed2(4) == seed2(3) 
            temp = -1;
        else
            temp = 1;
        end
        seed2(4) = seed2(3);
        seed2(3) = seed2(2);
        seed2(2) = seed2(1);
        seed2(1) = temp;
    end
end

%User3
for i = 1:length_mobileUser3
    for j = 1:10 %chip rate is 10 times the bit rate
        pn3_user_3 = [pn3_user_3 seed3(4)];
        if seed3(4) == seed3(3) 
            temp = -1;
        else
            temp = 1;
        end
        seed3(4) = seed3(3);
        seed3(3) = seed3(2);
        seed3(2) = seed3(1);
        seed3(1) = temp;
    end
end

%User4
for i = 1:length_mobileUser4
    for j = 1:10 %chip rate is 10 times the bit rate
        pn4_user_4 = [pn4_user_4 seed4(4)];
        if seed4(4) == seed4(3) 
            temp = -1;
        else
            temp = 1;
        end
        seed4(4) = seed4(3);
        seed4(3) = seed4(2);
        seed4(2) = seed4(1);
        seed4(1) = temp;
    end
end

%% 5.    Multiply the BPSK modulated signal with the PN code. Here again the care should be taken to match the sampling rate. i.e no. of chip per bit* no of samples per chip = no of samples per bit of BPSK modulated signal.
%User 1
pnupsampled1_User_1 = [];
len_pn1_user_1 = length(pn1_user_1);
for i = 1:len_pn1_user_1
    for j = 0.1:0.1:Tb
        if pn1_user_1(i) == 1
            pnupsampled1_User_1 = [pnupsampled1_User_1 1];
        else
            pnupsampled1_User_1 = [pnupsampled1_User_1 -1];
        end
    end
end
 
sigtx1_User_1 = user1bpskmod1.*pnupsampled1_User_1;

figure(1)
subplot(311)
stem(pn1_user_1);
axis([0,length(pn1_user_1),-1.2,1.2])
title('PN sequence for user1')
subplot(312)
stem(pnupsampled1_User_1);
axis([0,length(pnupsampled1_User_1),-1.2,1.2])
title('PN sequence for user1 upsampled');
subplot(313)
plot(sigtx1_User_1);
axis([0 100*length_mobileUser1 -2 2]);
title('spread spectrum signal transmitted for user 1 is');
grid on

%User 2
pnupsampled2_User_2 = [];
len_pn2_user_2 = length(pn2_user_2);
for i = 1:len_pn2_user_2
    for j = 0.1:0.1:Tb
        if pn2_user_2(i) == 1
            pnupsampled2_User_2 = [pnupsampled2_User_2 1];
        else
            pnupsampled2_User_2  = [pnupsampled2_User_2  -1];
        end
    end
end
 
length_pnupsampled2_User_2 = length(pnupsampled2_User_2);
 
sigtx2_User_2 = user2bpskmod2.*pnupsampled2_User_2;
 
figure(2)
subplot(311)
stem(pn2_user_2, 'r');
axis([0,length(pn2_user_2),-1.2,1.2])
title('PN sequence for user2')
subplot(312)
stem(pnupsampled2_User_2, 'r');
axis([0,length_pnupsampled2_User_2,-1.2,1.2])
title('PN sequence for user2 upsampled');
subplot(313)
plot(sigtx2_User_2, 'r');
axis([0 100*length_mobileUser2 -2 2]);
title('spread spectrum signal transmitted for user 2 is');
grid on


%User 3
pnupsampled3_User_3 = [];
len_pn3_user_3 = length(pn3_user_3);
for i = 1:len_pn3_user_3
    for j = 0.1:0.1:Tb
        if pn3_user_3(i) == 1
            pnupsampled3_User_3 = [pnupsampled3_User_3 1];
        else
            pnupsampled3_User_3 = [pnupsampled3_User_3 -1];
        end
    end
end
 
sigtx3_User_3 = user3bpskmod3.*pnupsampled3_User_3;

figure(3)
subplot(311)
stem(pn3_user_3);
axis([0,length(pn3_user_3),-1.2,1.2])
title('PN sequence for user3')
subplot(312)
stem(pnupsampled3_User_3);
axis([0,length(pnupsampled3_User_3),-1.2,1.2])
title('PN sequence for user3 upsampled');
subplot(313)
plot(sigtx3_User_3);
axis([0 100*length_mobileUser3 -2 2]);
title('spread spectrum signal transmitted for user 3 is');
grid on

%User 1
pnupsampled4_User_4 = [];
len_pn4_user_4 = length(pn4_user_4);
for i = 1:len_pn4_user_4
    for j = 0.1:0.1:Tb
        if pn4_user_4(i) == 1
            pnupsampled4_User_4 = [pnupsampled4_User_4 1];
        else
            pnupsampled4_User_4 = [pnupsampled4_User_4 -1];
        end
    end
end
 
sigtx4_User_4 = user4bpskmod4.*pnupsampled4_User_4;

figure(4)
subplot(311)
stem(pn4_user_4);
axis([0,length(pn4_user_4),-1.2,1.2])
title('PN sequence for user4')
subplot(312)
stem(pnupsampled4_User_4);
axis([0,length(pnupsampled4_User_4),-1.2,1.2])
title('PN sequence for user4 upsampled');
subplot(313)
plot(sigtx4_User_4);
axis([0 100*length_mobileUser4 -2 2]);
title('spread spectrum signal transmitted for user 4 is');
grid on


%% PLOTING TRANSMISTTED SIGNALS 
figure(5)
subplot(2,4,1);
plot(sigtx1_User_1);
grid on 
title('spread spectrum signal txd for user 1');

subplot(2,4,2);
plot(sigtx2_User_2, 'r');
grid on 
title('spread spectrum signal txd for user 2');

subplot(2,4,3);
plot(sigtx3_User_3);
grid on 
title('spread spectrum signal txd for user 3');

subplot(2,4,4);
plot(sigtx4_User_4);
grid on 
title('spread spectrum signal txd for user 4');


subplot(2,4,5);
plot(real(fft(sigtx1_User_1)));
grid on 
title('FFT of spreaded signal tx by user 1');

subplot(2,4,6);
plot(real(fft(sigtx2_User_2)), 'r');
title('FFT of spreaded signal tx by user 2');
grid on

subplot(2,4,7);
plot(real(fft(sigtx3_User_3)));
grid on 
title('FFT of spreaded signal tx by user 3');

subplot(2,4,8);
plot(real(fft(sigtx4_User_4)));
grid on 
title('FFT of spreaded signal tx by user4');
%% 7.    The channel is AWGN channel with SNR 5 dB. In channel the signal from user1 is added to signal from user2 and to white Gaussian noise. 
trasnmitted_signal = sigtx1_User_1 + sigtx2_User_2 + sigtx3_User_3 + sigtx4_User_4;
 
composite_signal = awgn(trasnmitted_signal,SNR);
 
figure(6)
subplot(211)
plot(trasnmitted_signal);
title('Composite signal sigtx1+sigtx2');
grid on 
subplot(212)
plot(composite_signal);
title(sprintf('Composite signal + noise\n SNR=%ddb',SNR));
grid on 

%% 8.    At receiver end, first received signal is multiplied with PN then BPSK demodulated by multiplying with the carrier.
% DMODULATION USER 1 
rx1 = composite_signal.*pnupsampled1_User_1; 

% BPSK DEMODULATION FOR USER 1
demodcar1 = [];
for i = 1:length_mobileUser1
    for j = 0.01:0.01:Tb
        demodcar1 = [demodcar1 sqrt(2*Eb)*cos(2*pi*Fc*j)];
    end
end
 
bpskdemod1 = rx1.*demodcar1;
 
len_dmod1 = length(bpskdemod1);
sum = zeros(1,len_dmod1/100);
for i = 1:len_dmod1/100
    for j = (i-1)*100+1:i*100
        sum(i) = sum(i)+bpskdemod1(j);
    end
end
sum;

% DMODULATION USER 2 
rx2 = composite_signal.*pnupsampled2_User_2; 

% BPSK DEMODULATION FOR USER 2
demodcar2 = [];
for i = 1:length_mobileUser2
    for j = 0.01:0.01:Tb
        demodcar2 = [demodcar2 sqrt(2*Eb)*cos(2*pi*Fc*j)];
    end
end
 
bpskdemod2 = rx2.*demodcar2;
 
len_dmod2 = length(bpskdemod2);
sum = zeros(1,len_dmod1/100);
for i = 1:len_dmod2/100
    for j = (i-1)*100+1:i*100
        sum(i) = sum(i)+bpskdemod2(j);
    end
end
sum;

% DMODULATION USER 3 
rx3 = composite_signal.*pnupsampled3_User_3; 

% BPSK DEMODULATION FOR USER 3
demodcar3 = [];
for i = 1:length_mobileUser3
    for j = 0.01:0.01:Tb
        demodcar3 = [demodcar3 sqrt(2*Eb)*cos(2*pi*Fc*j)];
    end
end
 
bpskdemod3 = rx3.*demodcar3;
 
len_dmod3 = length(bpskdemod3);
sum = zeros(1,len_dmod3/100);
for i = 1:len_dmod3/100
    for j = (i-1)*100+1:i*100
        sum(i) = sum(i)+bpskdemod3(j);
    end
end
sum;

% DMODULATION USER 4 
rx4 = composite_signal.*pnupsampled4_User_4; 

% BPSK DEMODULATION FOR USER 4
demodcar4 = [];
for i = 1:length_mobileUser4
    for j = 0.01:0.01:Tb
        demodcar4 = [demodcar4 sqrt(2*Eb)*cos(2*pi*Fc*j)];
    end
end
 
bpskdemod4 = rx4.*demodcar4;
 
len_dmod4 = length(bpskdemod4);
sum = zeros(1,len_dmod4/100);
for i = 1:len_dmod4/100
    for j = (i-1)*100+1:i*100
        sum(i) = sum(i)+bpskdemod4(j);
    end
end
sum;

%% 9.    then the samples over 1 bit interval is summed. And if the sum is greater than 0 then the received bit is 1 else rxbit is 0. Summation is used in place of integration because it is a discrete time system.
%User 1
rxbits1 = [];
for i = 1:length_mobileUser1
    if sum(i)>0
        rxbits1 = [rxbits1 1];
    else
        rxbits1 = [rxbits1 0];
    end
end
 
rxbits1=rectpulse(rxbits1,100); 

%User 2
rxbits2 = [];
for i = 1:length_mobileUser2
    if sum(i)>0
        rxbits2 = [rxbits2 1];
    else
        rxbits2 = [rxbits2 0];
    end
end
rxbits2=rectpulse(rxbits2,100); 

%User 3
rxbits3 = [];
for i = 1:length_mobileUser3
    if sum(i)>0
        rxbits3 = [rxbits3 1];
    else
        rxbits3 = [rxbits3 0];
    end
end
 
rxbits3=rectpulse(rxbits3,100); 

%User 4
rxbits4 = [];
for i = 1:length_mobileUser4
    if sum(i)>0
        rxbits4 = [rxbits4 1];
    else
        rxbits4 = [rxbits4 0];
    end
end
 
rxbits4=rectpulse(rxbits4,100); 

figure(7)
subplot(211)
plot(user1basebandsig1)
title('Transmitted bits of user1 data')
grid on
subplot(212)
plot(rxbits1)
axis([0 600 -0.2 1.2]);
title('Received bits of user1 data')
grid on


figure(8)
subplot(211)
plot(user2basebandsig2)
title('Transmitted bits of user2 data')
grid on
subplot(212)
plot(rxbits2)
axis([0 600 -0.2 1.2]);
title('Received bits of user2 data')
grid on
 
figure(9)
subplot(211)
plot(user3basebandsig3)
title('Transmitted bits of user3 data')
grid on
subplot(212)
plot(rxbits3)
axis([0 600 -0.2 1.2]);
title('Received bits of user3 data')
grid on
 
figure(10)
subplot(211)
plot(user4basebandsig4)
title('Transmitted bits of user4 data')
grid on
subplot(212)
plot(rxbits4)
axis([0 600 -0.2 1.2]);
title('Received bits of user4 data')
grid on
 


