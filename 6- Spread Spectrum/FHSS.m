
clc
clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____TX___%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Generating Bit pattern - Generate 25 bits
s = round(rand(1,25));
%%
%Generate Signal & Carrier
signal = [];
carrier =[];
T = 120;
t= [0 : 2*pi/(T-1) : 2*pi];
for k=1:25
    if s(1,k) == 0
        sig = -ones(1,T);
    else
        sig = ones(1,T);
    end
    c = cos(t);
    carrier = [carrier c];
    signal = [signal sig];
end
%%
%plot generated bit seq
figure(1);
plot(signal);
axis([-100 3000 -1.5 1.5]);
title('original bit seq');
%%
%BPSK Mod
bpsk_sig = signal .* carrier;
%%
%plot BPSK modulated signal
figure(2);
plot(bpsk_sig);
axis([-100 3000 -1.5 1.5]);
title('BPSK Modulated Signal');
%%
%different carrier feq
t1= [0 : 2*pi/9 : 2*pi];
t2= [0 : 2*pi/19 : 2*pi];
t3= [0 : 2*pi/29 : 2*pi];
t4= [0 : 2*pi/39 : 2*pi];
t5= [0 : 2*pi/59 : 2*pi];
t6= [0 : 2*pi/119 : 2*pi];

c1= cos(t1);
c1= [c1 c1 c1 c1 c1 c1 c1 c1 c1 c1 c1 c1 ];
c2= cos(t2);
c2= [c2 c2 c2 c2 c2 c2];
c3= cos(t3);
c3= [c3 c3 c3 c3];
c4= cos(t4);
c4= [c4 c4 c4];
c5= cos(t5);
c5= [c5 c5];
c6= cos(t6);
%%
%random freq hops to form a spread signal
spread_signal =[];
% for n=1:25
%     c = 6;
%     spread_signal = [spread_signal c6] 
% end

for n=1:25
    c= randi([1 6],1,1);

    switch(c)
        case (1)
            spread_signal = [spread_signal c1];
        case (2)
            spread_signal = [spread_signal c2];
        case (3)
            spread_signal = [spread_signal c3];
        case (4)
            spread_signal = [spread_signal c4];
        case (5)
            spread_signal = [spread_signal c5];
        case (6)
            spread_signal = [spread_signal c6];
    end
end

%%
figure(3);
plot(spread_signal);
axis ([-100 3000 -1.5 1.5]);
title('Spreaded Signal');
%%
%Spreading of the BPSK signal into wider band, to obtain the freq_hopped_signal
freq_hopped_sig = bpsk_sig.*spread_signal;
%%
figure(4);
plot(freq_hopped_sig);
axis ([-100 3000 -1.5 1.5]);
title('Freq. Hopped Signal');
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____RX___%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Demodulating   
demod_psk = freq_hopped_sig.*spread_signal;


figure(5);
plot(demod_psk);
axis ([-100 3000 -1.5 1.5]);
title('demodulated Signal');

















