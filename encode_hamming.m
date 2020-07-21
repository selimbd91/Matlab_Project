function c = encode_hamming(b, parity_generator, n_zero_padded_bits, switch_off)

    if switch_off==1
    L=length(b);
    N=L/4;
    b_new=reshape(b,4,N);     %Have to reshape b cause we have to multiply it with a 7*4 matrix so we have to reshape b to 4*N matrix.b_new is a matrix of 7*N
    cc=parity_generator*b_new;
    ccc=mod(cc,2);
    [row, col] = size(ccc);

                   
    c_without_zeros=reshape(ccc,row*col,1);   %length of sequence after coding          
    c_add=zeros(n_zero_padded_bits,1);
    c=[c_without_zeros;c_add];
else                       %switch_off=0, no channel coding
    c_add=zeros(n_zero_padded_bits,1);
    c=cat(1,b,c_add);
end
end
