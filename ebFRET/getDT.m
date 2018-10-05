function [dtA, dtB] = getDT(viterbi_series, i)

vi = viterbi_series(i).state;

if size(vi) == 0
    
    dtA = [];
    dtB = [];
    return
    
end

len_vi = size(vi, 1);

dtA = [];
dtB = [];

prev_state = vi(1);
count = 1;

for i = 2: len_vi
    
    curr_state = vi(i);
    
    if curr_state ~= prev_state
        
        if prev_state == 1
            
            dtA = [dtA count];
            
        else
            
            dtB = [dtB count];
            
        end
        
        count = 1;
        prev_state = curr_state;
        
    else
        
        count = count + 1;
        
    end
end

if prev_state == 1
    
    dtA = [dtA count];
    
else
    
    dtB = [dtB count];
    
end


end