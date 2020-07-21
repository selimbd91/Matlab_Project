function s = filter_tx (z, oversampling_factor, switch_graph, switch_off)

    if switch_off==1
    t = linspace(-4,4,161); % define t with 161 values
    LPF = sinc(t); % ideal LPF
  
    z_oversampled=[];
    for i=1:length(z)
        x1=[z(i),zeros(1,oversampling_factor-1)];% taking one value from z and putting 19 zeros to sample
        z_oversampled= [z_oversampled,x1]; % putting values to a row matrix upto 1100800  
    end
    
    F_out1 = conv(LPF,z_oversampled);

    F_out2=F_out1/sqrt(sum(abs(F_out1.^2))/length(F_out1));
    F_out= F_out2((length(LPF)+1)/2:end-(length(LPF)-1)/2);
    [m,n]=size(F_out);
    s=reshape(F_out,n,1); % make a column matrix

    if switch_graph==1
      [H,W] = freqz(F_out,1,1024);
       figure('name','Transmitter filter output in normalize frequency domain');
       plot(W/pi,20*log10(abs(H)));
       xlabel('\omega/pi');
       ylabel('H in DB');
       title('Transmit filter output in normalize frequency domain');

       figure('name','Transmitter filter output');
       subplot(2,1,1)
       plot(real(s),'c');
       xlabel('Time')
       ylabel('Real Part')
       title('Transmit filter output in Time domain');
       grid on
       hold on
       subplot(2,1,2)
       plot(imag(s),'r');
       grid on
       xlabel('Time')
       ylabel('Imaginary Part')
       title('Transmit filter output in Time domain');
    end
     
    else
        s=z;
    end
end
