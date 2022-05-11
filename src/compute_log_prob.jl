using StaticArrays
function_mapping = Dict()
for n in 1:25
    prog = "
        function generate_log_prob_$(n)(int_sequence, motif)

            motif = SMatrix{4,$n}(motif)
            motif_length = $n
            log_prob = zeros(Float32, length(int_sequence)- motif_length +1 )
            for i in 1:length(log_prob)
                for j in 1:motif_length
                    base = int_sequence[i+j-1]
                    log_prob[i] +=  motif[base,j]
                    # log_prob[i] += base & 0b1 * motif[1,j]
                    #             + base >>> 1 & 0b01 * motif[2,j]
                    #             + base >>> 2 & 0b01 * motif[3,j]
                    #             + base >>> 3 & 0b01 * motif[4,j]
                end
            end
            return log_prob
        end"
    ex = Meta.parse(prog)
    eval(ex)
    prog = "f = generate_log_prob_$(n)"
    ex = Meta.parse(prog)
    eval(ex)
    function_mapping[n] = f
end