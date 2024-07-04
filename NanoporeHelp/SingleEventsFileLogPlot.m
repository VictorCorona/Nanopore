%Single File .mat events log plot and event finder

function main
filename = '/Users/victor/Documents/CSULBPhys/KlotzLab/04_04_2024/04_04_2024_events.mat';
r=250000;

event_data=importdata(filename);
for i=1:length(event_data(:,1))
    if event_data{i,2}>0
    if event_data{i,1}>0.0001
        event_number(i)=i;
        event_time(i)=event_data{i,1};
        event_current(i)=event_data{i,2};
    end
    end
end
x=event_time';
y=event_current';
z=event_number';

figure(1)
h=plot3(x,y,z,'r.');
set(gca,'xscale','log','yscale','log')
xlabel('Translocation Time (s)')
ylabel('Current Drop (pA)')
view(2)

set([h gcf],'hittest','off')           % turn off hittest 
set(gca,'buttondownfcn',@func)         % assign function to gca
    function func(hobj,~)
        p  = get(gca,'currentpoint');  % get coordinates of click
        d = pdist2(log([x y]),log(p([1 3])));    % find combination of distances
        [~,ix] = min(d);               % find smallest distance
        line(x(ix),y(ix),'linestyle','none','marker','o')

        d=event_data{z(ix),3};
        l=length(d);
        t=1000.*linspace(0,l/r,l);

        figure(2)
        plot(t,d)
        xlabel('Time (ms)')
        ylabel('Current (pA)')
    end
end