using FAMOS


# Write your tests here.
sequence_file_path = "/home/marius/github/18337/data/pacbio_corrected.fasta.gz"
n_seq_max = Int(1e3)

motif_file_path = "/home/marius/github/18337/data/human_curated_tfs.txt"
n_motifs_max = 10

output_file_path = "/home/marius/test.csv"
p_value_threashold = 1e-4

FAMOS.do_motif_search(sequence_file_path,
motif_file_path, p_value_threashold,
output_file_path)

