function b_hat = decode_hamming (c_hat,parity_check_matrix, n_zero_padded_bits,switch_off, switch_graph, len_snr)
    
    persistent ctrt;

    if switch_off==1
    b_hat=[]; 
        a=0;
        b=0;
        c=0;
        e=0;
        d=0;
        f=0;
        g=0;
     for i=1:7:length(c_hat) 
         c_temp = c_hat(i:i+6); % c_temp is equal to 7 elements column vector
        syndrome = parity_check_matrix*c_temp; % doing syndrome by multiplying with c_temp so we get a column matrix with 3 elements
        syndrome = mod(syndrome,2); % find the modulus of the elements 

        if(max(syndrome) > 0)
            for j = 1:length(parity_check_matrix)
              if(parity_check_matrix(:,j) == syndrome)  % if the jth column in the par_H matrix equal to synfrome     
                c_temp(j) = not(c_temp(j)); % correcting the error
                if (j==1)
                    a=a+1;
                elseif(j==2)
                    b=b+1;
                elseif(j==3)
                    c=c+1;
                elseif(j==4)
                    d=d+1;  
                elseif(j==5)
                    e=e+1;    
                elseif(j==6)
                    f=f+1;    
                elseif(j==7)
                    g=g+1;        
                end
              end
            end

            Decoder=[0 0 1 0 0 0 0;0 0 0 0 1 0 0;0 0 0 0 0 1 0;0 0 0 0 0 0 1];
            c_temp = Decoder*c_temp;
            b_hat = [b_hat; c_temp];
        else
            Decoder=[0 0 1 0 0 0 0;0 0 0 0 1 0 0;0 0 0 0 0 1 0;0 0 0 0 0 0 1];
            c_temp = Decoder*c_temp;
            b_hat = [b_hat; c_temp];
        end
     end

    end

    ctrt =[ctrt;[a b c d e f g]];
     ctr = ctrt;
    
    if len_snr >= 40
         if switch_graph == 1

            figure('name','Exemplary code word indicating corrected errors for diff SNRs');
            subplot(2,2,1)
            stem((1:1:7),ctr(10,:));
            xlabel('Bit location');
            ylabel('No of corrections');
            legend('SNR=5');
            subplot(2,2,2)
            stem((1:1:7),ctr(20,:));
            xlabel('Bit location');
            ylabel('No of corrections');
            legend('SNR=10');
            subplot(2,2,3)
            stem((1:1:7),ctr(30,:));
            xlabel('Bit location');
            ylabel('No of corrections');
            legend('SNR=15');
            subplot(2,2,4)
            stem((1:1:7),ctr(40,:));
            xlabel('Bit location');
            ylabel('No of corrections');
            legend('SNR=20');

         end
    end

end