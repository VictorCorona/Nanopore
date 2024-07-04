%Nanopore Data Reader
%filename = '/Users/victor/Documents/CSULBPhys/KlotzLab/Nanopore/NanoporeIV18nm/2023_04_25_0000.abf;'
filename='/Volumes/T7/NanoporeIV18nm/2023_04_25_0000.abf';
[d s] = abfload(filename); %d is data, s is microsec per sample

r = 1/(s*10^-6); %sample rate per sec
t = size(d(:,1,1),1)/r;

N=size(d(1,1,:));
N=N(3);

for i=1:N
    x = linspace(0,t,size(d(:,1,i),1));
    %x=mean(x);
    y = d(:,1,i);
    y = transpose(y);
    c(i)=mean(y(i));
end

mv=[-200,-150,-100,-50,0,50,100,150,200];
%mv=[-100,-80,-60,-40,-20,0,20,40,60,80,100];
%mv=[-100,-80,-60,-50,-40,-20,0,20,40,60,80,100];
%plot(mv,c)
%figure(2)
%plot(mv,c)

%VCPore5M8 IV Curve
file='/Users/victor/Documents/CSULBPhys/KlotzLab/Nanopore Data/IVCurve/T082_VCPore5M8_Measurement_IV.csv';
D=csvread(file,1,0);
I=D(:,2).*1e-9;
v=D(:,1);

mv=mv./1000;
c =[-6.1304,-4.7181,-3.2870,-1.7339,-0.1446,1.4793,3.1188,4.6134,5.6848];
c=c.*1e-8;

pfe= polyfit(c,mv,1);
pff=polyfit(I,v,1);

Ge=1/pfe(1);
Gf=1/pff(1);
s=17;
l=12e-9;

dex=(Ge/(2*s))*(1+sqrt(1+(16*s*l/(pi*Ge)))) 
dfab=(Gf/(2*s))*(1+sqrt(1+(16*s*l/(pi*Gf)))) 

plot(I,v,'-ok','LineWidth',2)
hold on
plot(c,mv,'.r','MarkerSize',17)
hold off
xlabel('I (pA)')
ylabel('V')
legend('Fabrication','Equipment')
title('IV Curve for 19nm Pore')
