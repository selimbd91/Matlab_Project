function z = modulate_ofdm (D, fft_size, cp_size, switch_graph)

    D_ifft=ifft(D); % inverse fft
    [row,col]=size(D_ifft);
    CP = zeros(cp_size,col); %matrix 256*43
    b = fft_size-cp_size;
    
    for i=1:cp_size            %%%CP=last 256 bits of 1024 lenth frame.this cp is added infront of the frame.
        CP(i,:)=D_ifft(b+i,:); %putting values from D_ifft to from 768 row
    end
    
    A=[CP;D_ifft]; % final frame=256bit CP+1024bit dataframe
    [p,q]=size(A);
    z=reshape(A,1,p*q); % take all data into one column PARALLEL TO SERIAL



    if switch_graph==1
    a=fft_size+cp_size;
    B=z(1:a); %we are taking one FFT block to draw the graph
    
    [H,W] = freqz(z,1,512);
     figure('name','OFDM symbol in time domain');
     plot(real(B));
     title('OFDM symbol in time domain');
     xlabel('OFDM symbol sequence');
     ylabel('Amplitude');
     

     figure('name','OFDM symbol in Frequency domain');
     plot(W,20*log10(abs(H)));
     xlabel('\omega');
     ylabel('H in DB');
     title('OFDM symbol in frequency domain');

    end
end