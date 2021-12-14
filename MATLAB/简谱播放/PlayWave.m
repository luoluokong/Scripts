function  PlayWave(list,tone)
    out = [];i = 1;
    while i <= length(list)        
        % tone = 0.5;    
        if (list(i) == 0)
            tone = 2 * tone;
            i = i + 1;
        end    
    out = [out, Wave(list(i), tone)];
    i = i + 1;
    end
    sound(out);
end

