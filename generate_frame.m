function b = generate_frame(frame_size, switch_graph)

b 	= randi([0 1],frame_size,1);  %get randomly 1 and 0 with the matrix size of par_no and 1 in a column matrix

if switch_graph ==1
    figure('name','Digital Source');
    stem(b);
    xlabel({'Data','(in Bits)'})
    ylabel('Amplitude')
    title('Digital Source')
    
end