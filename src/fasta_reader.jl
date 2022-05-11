using CodecZlib
using FASTX
using DataFrames


function read_seq(filename)

    @assert (filename[end-7:end-4] == "fast") || (filename[end-4:end-1] == "fast")

    if filename[end-1:end] == "gz"
        if filename[end-7:end-3] == "fasta"
            reader = FASTA.Reader(GzipDecompressorStream(open(filename)))
        else
            reader = FASTQ.Reader(GzipDecompressorStream(open(filename)))
        end
    else
        if filename[end-4:end] == "fasta" 
            reader = FASTA.Reader(open(filename))
        else
            reader = FASTQ.Reader(open(filename))
        end
    end
    return reader
end

function fasta_to_df(filename, n)
    reader = read_seq(filename)
    i=0
    df_sequences = DataFrame(identifier = String[], sequence = Array{Int8}[])
    for record in reader
        i += 1
        if i<=n
            data = record.data
            id, sequence = split(String(data), "\n")
            sequence = convert_to_int_array(sequence)
            new_row = DataFrame(identifier = id, sequence = [sequence])
            append!(df_sequences,new_row)
        end
    end
    return df_sequences
end
