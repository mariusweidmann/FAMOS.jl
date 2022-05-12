module FAMOS
using DataFrames


# Write your package code here.
include("process_sequences.jl")
include("fasta_reader.jl")
include("p_value_calculation.jl")
include("motif_matricies.jl")
include("write_to_csv.jl")
include("compute_log_prob.jl")
# filename = "/home/marius/github/18337/data/pacbio_corrected.fasta.gz"

function do_search_for_one_motif!(df, motif, motif_name, function_mapping, threashold)
    motif_length = size(motif)[2]
    generate_log_prob_func = function_mapping[motif_length]
    n_seq = size(df)[1]
    matches_motif = Array{Matches}(undef, n_seq)
    for i in 1:n_seq
        seq = df[i,2]
        log_prob = generate_log_prob_func(seq, motif)
        match = search_log(log_prob,threashold)
        matches_motif[i] = match
    end
    colname = motif_name
    df[:, colname] = matches_motif
end


function do_motif_search(sequence_file_path,
            motif_file_path, p_value_threashold,
            output_file_path, n_seq_max = Inf, n_motifs_max = Inf)
    println("start loading sequences")
    df = fasta_to_df(sequence_file_path, n_seq_max)
    n_seq = size(df)[1]
    println("start loading motif matricies")
    motif_ids, proteins, motifs = read_motif_file(motif_file_path)
    n_motifs = length(motifs)
    n_motifs = Int(min(n_motifs, n_motifs_max))
    println("finished loading")

    for i in 1:n_motifs
        ppm_to_pwm!(motifs[i])
        colname = motif_ids[i]
        df[!, colname] = Array{Matches}(undef, n_seq)
    end

    println("Starting Motif search")
    threashold = Float32(p_to_log_odds(p_value_threashold))
    @sync for i in 1:n_motifs   
        Threads.@spawn do_search_for_one_motif!(df, motifs[i], motif_ids[i], function_mapping, threashold)
        if mod(i, 10) == 0
            println("motif search", i, " out of ", n_motifs, " done")
        end
    end
    println("Finished search")
    println("Saving resluts at: ", output_file_path)
    write_df_to_csv(df, motif_ids, proteins, motifs, output_file_path)
    println("Results saved.")
    println("Sucessfully performed motif serach for: ", size(df)[1], " sequences and ", size(df)[2] - 2," motifs")
end



end
