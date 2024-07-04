%Extracted Events I vs T Plot

%inputdir='/Users/victor/Documents/CSULBPhys/KlotzLab/05_16_2024_dna';
inputdir='/Users/victor/Documents/CSULBPhys/KlotzLab/05_29_2024';
%inputdir = '/Users/victor/Desktop/'

s=fullfile(inputdir,'*.mat');
files = dir(s);
path=files(1,1).folder;

for k = 1:length(files)
    name=files(k,1).name;
    filename=append(path,'/',name);
    event_data=importdata(filename);

for i=1:length(event_data(:,1))
    if event_data{i,2}>100      %current drop filter
    if event_data{i,1}>0.0001   %time filter
    event_points=event_data{i,3};
    event_time(i,1)=event_data{i,1};
    event_current(i,1)=event_data{i,2};   
    end
    end
end

%Plotting Events
figure(1)
loglog(event_time(:,1),event_current(:,1),'r.')
hold on
xlabel('Translocation Time (s)')
ylabel('Current Drop (pA)')
end
hold off