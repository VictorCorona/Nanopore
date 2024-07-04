%Event Extraction from .abf File

clear all;

%Inputs
filename = ['/Users/victor/Documents/CSULBPhys/KlotzLab/05_29_2024/2024_05_29_0052.abf'];
%filename = '/Volumes/T7/06_12_2024/2024_06_12_0011.abf';

a=4     %STD filter factor
w=0.0001;   %Lower bound time limit   %0.0001 is good for ssb
Q=1;        %Baseline smoothing factor
N=10;       %Noisy Events Factor

%Load Data
[data_raw s] = abfload(filename); %extract data, s is microsec per sample
r = 1/(s*10^-6);                  %sample rate per sec
%data_raw=data_raw([1:10e6,12.5e6:15e6]);     %choosing good data range if needed

t = size(data_raw,1)/r;
x = linspace(0,t,size(data_raw,1));
y = data_raw(:,1);
%Different ways of smoothing baseline
I=smoothdata(data_raw(:),'movmedian',Q*r);   %median is good for good baseline/slow std with outliers

%I=smoothdata(d,'movmean');         %mean is how the average changes over time
%I=smoothdata(d,'gaussian');        %Gaussian weighted average
%I=smoothdata(d,'rloess');          %Good but takes too long
%I=smoothdata(d,'sgolay');          %Savitzky-Golay filter

I_base=mean(I(:));
sig=std(data_raw);
tr=I-a*sig;
upper_bound=I_base+a*sig;

%Smoothing Zaps
data_smooth=data_raw;
for i=2:length(data_smooth)
    if data_raw(i)>upper_bound
        data_smooth(i)=I(i);
    end
    if data_raw(i)<0
        data_smooth(i)=I(i);
    end
    if data_smooth(i)==0
        data_smooth(i-1:i+500000)=I(i-1:i+500000);
    end
end

%Filtering just events
f=N*r*w;   %Noisy event threshold
B(:,1)=data_smooth(:,1);
B(B>tr)=0;
B(B<0)=0;   %Change if current drops bellow 0 from offset

for i=f+1:length(B)-f-1
    if B(i)==0 && data_smooth(i)<I(i)
    end
    if mean(B(i-f:i-1))>0 && mean(B(i+1:i+f))>0
        B(i)=data_smooth(i);
    end
end

plot(data_raw)
hold on
plot(tr)
hold off

%Detecting Events
p=0;   %number of data points
j=1;   %Event number
for i=1:length(data_raw(:,1))
    if B(i)~=0
        p=p+1;   %counting number of points during translocation   
    end   
    if B(i)==0 && p/r>w && i>p+500 && i<length(data_smooth(:,1))-500
       l(j)=p/r;
       events{j,1}=l(j);                           %dwell time saved
       events{j,3}=data_raw(i-p-500:i+500);        %full event data saved
       event_base(j,1)=mean(I(i-p:i));             %Event Baseline 
       j=j+1;
       p=0;
    end  
end

for j=1:length(events(:,1))
    event_points=events{j,3};
    event_length(j,1)=length(events{j,3})-1000;
    event_time(j,1)=event_length(j,1)/r;
    event_current(j,1)=mean(event_points(500:length(event_points)-500));
    event_pA(j,1)=event_base(j,1)-event_current(j,1);
    events{j,2}=event_pA(j,1);                      %Current Drop saved in Event

end

%Saving Detected Events to .mat File
[path,name,ext]=fileparts(filename);
eventsname=append(path,'/',name,'_events.mat');
save(eventsname,'events');

append(string(length(events(:,1))),' Events Detected')

%Plotting Events
%figure(1)
%semilogx(event_time(:,1),event_pA(:,1),'b.')
%xlabel('Translocation Time (s)')
%ylabel('Current Drop (pA)')
