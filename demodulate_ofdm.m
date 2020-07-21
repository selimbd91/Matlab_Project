function D_tilde = demodulate_ofdm (z_tilde, fft_size, cp_size, swich_graph)

    L = length(z_tilde);
    X = reshape(z_tilde, 1, L); %row matrix
    m = fft_size + cp_size;
    n =(L-mod(L,m))/m;%to make length of z_tilde dividable by 'par_N_FFT+par_N_CP'
    A= X(1:m*n);% ignoring the tail and get a row matrix 1*55040
    A1=reshape(A,m,n);%serial to parallel 1280*43
    A2=A1(1+cp_size:m,:);% ignoring the fist 256 rows because ut is the CP 1024*43
    D_tilde=fft(A2); % taking the fft 1024*43

    if swich_graph==1;
        K=reshape(D_tilde,fft_size*n,1);
        scatterplot(K);
        title('Constellation diagram after OFDM demodulation')
    end
end
    
    


