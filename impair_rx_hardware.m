function s_tilde = impair_rx_hardware (y,clipping_threshold,switch_graph)

    R = abs(y); %getting the absolute value
    theta = angle(y); %getting the angle
    R1 = zeros(1,length(R)); %creating  empty row matrix 
    theta1 = zeros(1,length(theta)); %creating  empty row matrix 

    for i=1: length(R) 
        if R(i)>clipping_threshold % Clipping if R(i)>= par thresh(1)
            R1(i)=1; 
        else 
            R1(i)=R(i); %otherwise keep it like as it is
        end
    end

    for i=1: length(theta) 
        if theta(i)>clipping_threshold % Clipping if R(i)>= par thresh(1)
            theta1(i)=1; 
        else 
            theta1(i)=theta(i); %otherwise keep it like as it is
        end
    end

    %Convert back 
    [a,b]=pol2cart(theta,R1'); % R' making it a column vector because theta is a column vector
    s_tilde=a+b*1i;

    if switch_graph==1;
        figure('name','Receive Hardware');
        subplot(2,1,1)
        plot(real(y),'g');
        ylabel('Amlitude')
        xlabel('Time')
        title('input recieved signal(Real)')
        grid on
        subplot(2,1,2)
        plot(real(s_tilde),'r');
        ylabel('Amlitude')
        xlabel('Time')
        grid on
        title('output of receive hardware (Real')
    end
end
