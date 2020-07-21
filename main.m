% Name: Selim Hossain
% Matriculation No:320220
% Name: Md Riad Hossain Bhuiyan
% Matriculation No: 320209


clc;
close all;
clear all;



parity_generator = [1,1,0,1;1,0,1,1;1,0,0,0;0,1,1,1;0,1,0,0;0,0,1,0;0,0,0,1]; %Generator
parity_check_matrix = [1 0 1 0 1 0 1;0 1 1 0 0 1 1;0 0 0 1 1 1 1]; %Parity Checking Matrix


% ---------------------- TRANSMITTER ---------------------------

% --------------------- Digital source -------------------------
switch_graph = 1;
frame_size = 512*2*4*6;% 1024*48 this is selected according to the OFDM parameters
b = generate_frame (frame_size, switch_graph);



% ------------------- Channel coding ---------------------------

switch_off = 1;
n_zero_padded_bits = 0;
c = encode_hamming (b, parity_generator, n_zero_padded_bits, switch_off);


% ------------------- Modulation -------------------------------
constellation_order = 2; %2-4QAM, 4-16QAM else 64QAM
d = map2symbols (c, constellation_order, switch_graph);


% ----------------- Pilot insertion -----------------------------

fft_size = 1024;  % FFT points according to script
N_blocks = length(d)/fft_size;

if constellation_order == 2
    QAM_point=[-1-1i;1-1i;-1+1i;1+1i];
    p = randi([1 4],fft_size,1);
    for i=1:length(p)
        pilot_symbols(i,1)=QAM_point(p(i),1);
    end
    pilot_symbols = pilot_symbols/sqrt(2);
    D = insert_pilots (d, fft_size, N_blocks, switch_graph, pilot_symbols);
elseif constellation_order == 4
    QAM_point=[-3-3i;-3-1i;-3+3i;-3+1i;-1-3i;-1-1i;-1+3i;-1+1i;3-3i;3-1i;3+3i;3+1i;1-3i;1-1i;1+3i;1+1i];
    p = randi([1 16],fft_size,1);
    for i=1:length(p)
        pilot_symbols(i,1)=QAM_point(p(i),1);
    end
    pilot_symbols = pilot_symbols/sqrt(10);
    D = insert_pilots (d, fft_size, N_blocks, switch_graph, pilot_symbols);
else
    QAM_point=[-7+7i;-7 + 5i;-7 + 1i;-7 + 3i;-7-7i;-7-5i;-7-1i;-7-3i;-5+7i;-5+5i;-5+1i;-5+3i;-5-7i;-5-5i;-5-1i;-5-3i;-1+7i;-1+5i;-1+1i;-1+3i;-1-7i;-1-5i;-1-1i;-1-3i;-3+7i;-3+5i;-3+1i;-3+3i;-3-7i;-3-5i;-3-1i;-3-3i;5+7i;5+5i;5+1i;5+3i;5-7i;5-5i;5-1i;5-3i;7+7i;7+5i;7+1i;7+3i;7-7i;7-5i;7-1i;7-3i;3+7i;3+5i;3+1i;3+3i;3-7i;3-5i;3-1i;3-3i;1+7i;1+5i;1+1i;1+3i;1-7i;1-5i;1-1i;1-3i];
    p = randi([1 64],fft_size,1);
    for i=1:length(p)
        pilot_symbols(i,1)=QAM_point(p(i),1);
    end
    pilot_symbols = pilot_symbols/sqrt(42);
    D = insert_pilots (d, fft_size, N_blocks, switch_graph, pilot_symbols);
end


% --------------------- OFDM Tx ---------------------------------

cp_size = 256;  % by convolving 1 with channel 200 sample delay is observed
z = modulate_ofdm (D, fft_size, cp_size, switch_graph);


% ------------------ Tx Filter ---------------------------------

switch_off = 1;
oversampling_factor = 20;
s = filter_tx (z, oversampling_factor, switch_graph, switch_off);


% --------------- Non-Linear Hardware --------------------------

clipping_threshold = 1;
x = impair_tx_hardware(s, clipping_threshold, switch_graph);



SNR = 1: 1: 3;
BitErr = zeros(1,length(SNR));


for i = 1 : length(SNR)
    %for j = 1:4
    
    
    y = simulate_channel(x, SNR(i), 'FSBF');
    
    if i == length(SNR) %&&  j == 4
        switch_graph = 1;
        
    else
        switch_graph = 0;
    end
    
    % ------------------ Reciever-----------------------------------
    
    % ---------------- Non-Linear Hardware--------------------------
    
    clipping_threshold = 1;
    s_tilde = impair_rx_hardware(y, clipping_threshold, switch_graph);
    
    
    % ------------------- RX-Filter --------------------------------
    
    switch_off=1;
    downsampling_factor = 20;
    z_tilde = filter_rx(s_tilde, downsampling_factor, switch_graph, switch_off);
    
    
    % ----------------- OFDM-Demodulation --------------------------
    
    D_tilde = demodulate_ofdm(z_tilde, fft_size, cp_size, switch_graph);
    
    
    %----------------- Equalizer ----------------------------------
    
    d_bar = equalizer (D_tilde, pilot_symbols, switch_graph);
    
    
    %---------------- Demodulation --------------------------------
    
    c_hat = detect_symbols (d_bar, constellation_order, switch_graph);
    
    
    % ----------------- Channel Decoding ----------------------------
    
    switch_off=1;
    len_snr = length(SNR);
    b_hat = decode_hamming (c_hat, parity_check_matrix,n_zero_padded_bits, switch_off, switch_graph, len_snr);
    
    %----------------- Digital Sink ----------------------------
    
    BER = digital_sink(b, b_hat, switch_graph);
    BitErr(1,i) = BER;
    
    if i ==length(SNR)
        figure('name','BER vs SNR ')
        plot(SNR, BitErr,'k*-','linewidth',2);
        hold on
        xlabel('SNR(DB)');
        ylabel('BER');
    end
    
    
    
    
    
    %end
end


k=length(x)/(fft_size+cp_size);
l=k/oversampling_factor;
y=x(1:oversampling_factor:end);
ss=reshape(y,(fft_size+cp_size),l);
S=ss(1+cp_size:(fft_size+cp_size),:);

users=1:1:fft_size;
peak=zeros(1,fft_size);
Avg=zeros(1,fft_size);
PAPR=zeros(1,fft_size);
energy=zeros(l,1);
f=0;
for i=1:fft_size
    
    peakpower1 = S(i,:);
    
    for j=1:length(peakpower1)
        energy(j,1)=(peakpower1(1,j)*conj(peakpower1(1,j)));
    end
    
    f=f+1;
    peak(1,f) =max(energy);
    Average=mean(energy);
    Avg(1,f)=Average;
    PAPR(1,f)= peak(1,f)/Avg(1,f);
end
figure('name','Users vs PAPR');
plot(users,10*log10(PAPR),'m*-','linewidth',2);
ylabel('Amplitude')

