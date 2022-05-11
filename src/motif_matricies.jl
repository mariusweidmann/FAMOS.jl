function extract_motif_matrix(start_line, end_line, lines)
    length = end_line - start_line + 1
    motif = Array{Float32}(undef, (length, 4))
    for i in start_line:end_line
        motif[i-start_line+1, :] = parse.(Float32, split(lines[i],r" |\t")[3:6])
    end
    return transpose(motif)
end

function ppm_to_pwm!(motif_matrix, background_frequencies = repeat([0.25f0],4))
    for i in 1:4
        motif_matrix[i,:] = log2.(motif_matrix[i,:]/background_frequencies[i])
    end
end

function read_motif_file(file_path)
    f = open(file_path, "r")
    lines = readlines(f)
    names = []
    proteins = []
    motifs = []
    j = 1
    for i in 1:length(lines)
        re = r"MOTIF"
        if occursin(re , lines[i])
            name, protein = split(lines[i])[2:3]
            push!(proteins, protein)
            push!(names, name)
            start_line = i+3
            length = parse(Int, match(r"w= [0-9]+", lines[i+2]).match[4:end])
            end_line = start_line + length -1
            push!(motifs, extract_motif_matrix(start_line, end_line, lines))      
            j += 1
        end    
    end 
    return names, proteins, motifs 
end
