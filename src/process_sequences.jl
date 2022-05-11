using StaticArrays

# MAYBE check if a oneliner would be faster
function log_odds_to_p!(log_ods)
    for i in 1:length(log_ods)
        ods = 2^log_ods[i]
        q = ods/(ods+1)
        log_ods[i] = 1-q
    end
end

function convert_to_int_array(sequence)
    length = 0
    #count number of bases in sequence
    for i in sequence
        if i in @SArray['A', 'C', 'G', 'T']
            length += 1
        end
    end
    
    #initialize array of suitable length
    int_sequence = Array{UInt8}(undef, length)
    j = 1
    for i in sequence
        if i == 'A'
            int_sequence[j] = UInt8(1)
            j += 1
        elseif i == 'C'
            int_sequence[j] = UInt8(2)
            j += 1
        elseif i == 'G'
            int_sequence[j] = UInt8(3)
            j += 1
        elseif i == 'T'
            int_sequence[j] = UInt8(4)
            j += 1
        end
    end
    sequence = nothing
    return int_sequence
end



struct Matches
    locations::Vector{UInt32}
    p_values::Vector{Float32}
end


function search_log(log_prob, threshold)
    n = length(log_prob)
    log_prob = [x>threshold ? Float32(x) : 0.0f0 for x in log_prob]
    non_zero = log_prob .> 0.0
    n_non_zeros = sum(non_zero)
    # p = zeros(Int, n_non_zeros)
    j = 1
    sub_set = Array{Float32}(undef, n_non_zeros)
    locations = Array{UInt32}(undef, n_non_zeros)
    for i in 1:n
        if non_zero[i]
            sub_set[j] = log_prob[i]
            locations[j] = i
            j += 1
        end
    end
    log_prob = nothing
    # p = sortperm!(p, sub_set)
    # locations .= locations[p]
    # sub_set .= sub_set[p]
    log_odds_to_p!(sub_set)
    matches = Matches(locations, sub_set)
    locations = nothing
    sub_set = nothing
    return matches
end
# x = [1,2]
# log_odds_to_p!.(x)
# x


