%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____TX___%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generating bit pattern
%each bit is actually 20 samples long
b = round (rand(1,30));
pattern= [];
for k= 1:30
    if b(1,k)==0
        sig = -ones(1,20);
    else 
        sig = ones(1,20);
    end
    pattern = [pattern sig]; 
end

%%
%plot main sig
figure(1);
plot(pattern);
axis ([-1 620 -1.5 1.5]); 
title('\bf\it Original Bit Sequence'); %what is each axis? %what is \bf\?
%% 
%Generating Pseudo Noise random bit pattern
d= round(rand(1,120));
pn_seq = []; 


for k=1:120
    if d(1,k)==0
        sig = -ones(1,5);
    else
        sig = ones(1,5);
    end
    pn_seq = [pn_seq sig];

end

%%
%spreading of seq
spreaded_sig = pattern .* pn_seq;
%%
%plot spreaded sig
figure(2);
plot(spreaded_sig);
axis ([-1 620 -1.5 1.5]);
title('Spreaded Signal');
%%
%BPSK Mod
carrier = [];
t = [0:2*pi/4:2*pi];
for k=1:120
    c = cos(t);
    carrier = [carrier c];
end

bpsk_sig = spreaded_sig .* carrier;
%%
%plot BPSK modulated sig
figure(3);
plot(bpsk_sig);
axis([-1 620 -1.5 1.5]);
title('BPSK Modulated Signal');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%____RX___%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%demodulate received sig
rx_sig = bpsk_sig .* carrier;
demod_sig = [];
for i=1:600
    if rx_sig(i)>=0
        rxs = 1;
    else
        rxs = -1;
    end
    demod_sig = [demod_sig rxs];
end
%%
%plot demodulated sig
figure(4);
plot(demod_sig);
axis([-1 620 -1.5 1.5]);
title('Demodulated signal');
%%
%de spread demodulated received sig
despread_sig = demod_sig .* pn_seq;
%%
%plot de-spreaded signal
figure(5);
plot(despread_sig);
axis([-1 620 -1.5 1.5]);
title('Despreaded data');
%%
