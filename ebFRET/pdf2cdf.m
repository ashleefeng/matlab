function oneminuscdf = pdf2cdf(pdf_in)

len = size(pdf_in, 2);

oneminuscdf = zeros(1, len);

for i = 1: len
    
    if i == 1
    
        oneminuscdf(i) = 1 - pdf_in(i);
        
    else
        
        oneminuscdf(i) = oneminuscdf(i-1) - pdf_in(i);
    
    end
end

end