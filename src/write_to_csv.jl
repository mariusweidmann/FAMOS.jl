function write_df_to_csv(df,motif_ids, proteins, motifs, output_name = "results.csv")
    n_hits = Threads.Atomic{Int}(0)
    Threads.@threads for i in 3:size(df)[2]
        n_hits_collumn = 0
        for j in 1:size(df)[1]
            n_hits_collumn += length(df[j,i].locations)
        end
        Threads.atomic_add!(n_hits, n_hits_collumn)
    end
    p_values = Array{Float32}(undef, n_hits.value)
    locations = Array{UInt32}(undef, n_hits.value)
    sequece_numbers = Array{UInt32}(undef, n_hits.value)
    motif_numbers = Array{UInt32}(undef, n_hits.value)
    l = 1
    sequece_names = df[:,1]
    sequece_names = chop.(sequece_names, head = 1,tail = 0)
    for i in 3:size(df)[2]
        for j in 1:size(df)[1]
            n = length(df[j,i].locations)
            if n != 0
                p_values[l:l+n-1] = df[j,i].p_values
                locations[l:l+n-1] = df[j,i].locations
                sequece_numbers[l:l+n-1] .= j
                motif_numbers[l:l+n-1] .= i-2
                l += n
            end
        end
    end

    permutation = Array{Int64}(undef, n_hits.value)
    p_values
    sortperm!(permutation, p_values)
    p_values = p_values[permutation]
    locations = locations[permutation]
    motif_numbers = motif_numbers[permutation]
    sequece_numbers = sequece_numbers[permutation]

    csvfile = open(output_name,"w")
    write(csvfile,"motif_id\tsequence_name\tptotein_name\tstart\tstop\tp_value\n")

    motif_lengths = [size(motif)[2] for motif in motifs]
    for i in 1:length(locations)
        motif_number = motif_numbers[i]
        #motif_id
        motif_id = motif_ids[motif_number]
        write(csvfile, motif_id, "\t")
        #sequence name
        sequece_number = sequece_numbers[i]
        write(csvfile, sequece_names[sequece_number], "\t")
        #protein name 
        write(csvfile, proteins[motif_number], "\t")
        #start
        location = locations[i]
        write(csvfile, string(location), "\t")
        #stop
        motif_length = motif_lengths[motif_number]
        write(csvfile, string(location+ motif_length-1), "\t")
        #p value
        write(csvfile, string(p_values[i]), "\n")
    end  
end
