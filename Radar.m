clear all;
clc;
%Task 1
power=1.5*10^6;               % peak power of the transmitted wave
fs=60e6;                      % sampling frequency
t=0:1/fs:0.000024;            % time of the transmitted wave 
A=sqrt(power);                %signal amplitude
d=0:1/(2*10^5):0.000024;      % pulse repetition frequency
x=rectpuls(t,18/(fs));        % pulse width=18/fs
puTrain = pulstran(t,d,x,fs); % Train of pulses
y=A*puTrain;                  % signal transmitted from the radar

figure(1);
plot(t,y);                    %plotting signal transmitted versus time 
xlabel('Time (s)');
ylabel ('Signal Amplitude');
title('Signal transmitted from the radar');

%Task2
%Radar parameters
puWidth=18/fs; 
PRI=5*10^-6;
pt=1.5*10^6;                               %peak power of the transmitted signal
[dt, Pav, Ep, prf, Ru] = pulse_train(puWidth,PRI,pt);   
G=10;                                      % antenna gain
Ae=0.5;                                    % antenna effective aperture.
segma=0.1;                                 % radar cross section
pr=0.3*10^(-3);                            %total power received
Range=sqrt(1/(4*pi)*sqrt(pt*G*segma*Ae/pr));  %range of certain object 
deltaRmin=(puWidth)*physconst('LightSpeed')/2;    

%Task 3

recA=sqrt(pr);                          % Amplitude of recevied signal               
delay=2*Range/physconst('LightSpeed');  % delta t
tdelay=delay:1/(fs):0.000024+delay;      % time of recieved signal
received=puTrain*recA;                  % Received signal withous noise                   
RecievedN=awgn(received,40);            
figure(2)
subplot(2,1,1);plot(t,y);                    %plotting transmitted signal
xlabel('Time (s)');
ylabel ('Transmitted signal Amplitude');
title('Signal transmitted from the radar');

subplot(2,1,2);plot(tdelay,RecievedN ,'r');  %plotting recived signal
xlabel('Time (s)');
ylabel ('Received signal Amplitude');
title('Signal Received from the radar');

%Task 4
figure(3)
t2=-0.000024:1/fs:0.000024;      
rectPulse=rectpuls(t2,18/(fs));          
x2=A*rectPulse;                    %transmitted pulse
subplot(2,2,1); plot(t2,x2);
xlabel('Time (s)');
ylabel ('Transmitted Pulse Amplitude');
title('Pulse transmitted');

t2delay=-0.000024+delay:1/fs:0.000024+delay;
rec2=awgn(recA*rectPulse,40);       %received pulse
subplot(2,2,2); plot(t2delay,rec2);
xlabel('Time (s)');
ylabel ('Received Pulse Amplitude');
title('Pulse Received');

pulseConv=conv(x2,rec2);
t2conv=-0.000048+delay:1/fs:0.000024+delay+0.000024;
subplot(2,2,[3 4]);plot(t2conv,pulseConv ,'r');
xlabel('Time (s)');
ylabel ('Output of convolution');
title('Convolution between Transmitted and recieved pulse');

%Task 5
figure(4)
subplot(3,2,1); plot(t,y);
xlabel('Time (s)');
ylabel ('Signal Amplitude');
title('Signal transmitted from the radar');
subplot(3,2,2); plot(tdelay,RecievedN,'r');
xlabel('Time (s)');
ylabel ('Received signal Amplitude');
title('Signal Received from the radar');
w=conv(y,RecievedN );               %correlation between transmitted and received signal
tconv=0+delay:1/fs:0.000024+delay+0.000024;
subplot(3,2,[3 4]);plot(tconv,w,'K');
xlabel('Time (s)');
ylabel ('Convolution output');
title('Convolution of transmitted and received signal');
%////////////////////////////////////////////////Average Calculation
period=5*10^-6;
convolution=conv(y,RecievedN )./fs;
t2=-3*10^-6:1/fs:2*10^-6;
peak_Samples=period*fs;
peak1=convolution(1:301);
peak2=convolution(301:601);
peak3=convolution(601:901);
peak4=convolution(901:1201);
peak5=convolution(1201:1501);
Average=(peak1+peak2+peak3+peak4+peak5)./5;
subplot(3,2,5);
plot(t2,Average);
xlabel('Time (s)');
ylabel ('Powet');
title('The average correlation graph');

%%%%%%%%%%%%%%Fnction used (pulse_train)
function [dt, Pav, Ep, prf, Ru] = pulse_train(pWidth,PRI,p_peak) 
dt=pWidth/PRI;    % duty cycle
Pav=dt*p_peak;    % average power
Ep=Pav*PRI;       % energy of pulse
prf=1/PRI;        % pulse repetiton frequency
Ru=physconst('LightSpeed')*PRI/2;      % unambiguous range
end