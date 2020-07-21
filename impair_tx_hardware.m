function x = impair_tx_hardware (s,clipping_threshold,switch_graph)

    R = abs(s);
    theta = angle(s);
    R1 = zeros(1,length(R));
    theta1 = zeros(1,length(theta));

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

    [a,b]=pol2cart(theta,R1');
    x=a+b*1i;

    if switch_graph==1;
    %     figure('name','Transmit Hardware');
    %     subplot(2,1,1)
    %     plot(real(s),'g');
    %     title('Non clipped signal')
    %     grid on
    %     subplot(2,1,2)
    %     plot(real(x),'r');
    %     grid on
    %     title('output of tx hardware')

     figure('name','Hard Threshold Output');
     subplot(2,1,1)
     plot(real(x),'b')
     xlim([1 length(x)])
     ylim([-2 2])
     xlabel('Time')
     ylabel('Amplitude')
     grid
     title('Output of tx Clipped Signal(Real)')
     legend('Real')

     subplot(2,1,2)
     plot(imag(x),'g')
     xlabel('Time')
     ylabel('Amplitude')
     title('Output of tx Clipped Signal(Imaginary)')
     xlim([1 length(x)])
     ylim([-2 2])
     grid
     legend('Img')

     figure('name','Before ardware');
     subplot(2,1,1)
     plot(real(s),'b')
     xlabel('Time')
     ylabel('Amplitude')
     xlim([1 length(s)])
     ylim([-2 2])
     grid
     title('Output of tx non linear hardware(Real)')
     legend('Real')

     subplot(2,1,2)
     plot(imag(s),'g')
     xlabel('Time')
     ylabel('Amplitude')
     xlim([1 length(s)])
     ylim([-2 2])
     title('Output of tx non linear hardware(Imaginary)')
     grid
     legend('Img')
    end
end




