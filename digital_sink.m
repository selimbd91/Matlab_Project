function BER = digital_sink(b, b_hat, switch_graph)

    e=abs(b - b_hat);
    BER=sum(e)/length(b);
    fprintf('BER = %d \n',BER);

    if switch_graph == 1
        figure('name','Error Positions')
        stem(abs(b - b_hat));
        title('Error Positions')
        %b_length = length(b)
        %b_hat_length = length(b_hat)
        
    end
       

end

