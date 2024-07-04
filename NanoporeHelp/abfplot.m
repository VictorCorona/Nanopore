filename = ['/Users/victor/Documents/CSULBPhys/KlotzLab/UCR Data kDNA/2023_03_30_0075.abf']
%filename='2023_06_30_0025.abf'
[d s] = abfload(filename); %d is data, s is microsec per sample

r = 1/(s*10^-6); %sample rate per sec
t = size(d,1)/r;

x = linspace(0,t,size(d,1));

y = d(:,1);
y = transpose(y);

figure(2)
plot(x,y,'r');
title('Nanopore Current');
xlabel('Time (s)');
ylabel('I (pA)');

