function D = insert_pilots (d,fft_size,N_blocks, switch_graph, pilot_symbols)

    D2=reshape(d,fft_size,N_blocks);

    D=[pilot_symbols,D2]; 
    if switch_graph==1
        figure('name','Pilot Insertion');
        plot(D,'r*');
    end
end