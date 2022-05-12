# FAMOS
FAst Motif Occurence Search  
Example usage of this package:
```julia
using FAMOS

sequence_file_path = "<full path to the folder of your fasta file>/example.fasta.gz"
motif_file_path = "<full path to the folder of your motif file>/example.txt"
output_file_path = "<output folder>/test.csv"
p_value_threshold = 1e-4

FAMOS.do_motif_search(sequence_file_path, motif_file_path,
                      p_value_threshold, output_file_path)
```


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mariusweidmann.github.io/FAMOS.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mariusweidmann.github.io/FAMOS.jl/dev)
<!-- [![Build Status](https://github.com/mariusweidmann/FAMOS.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/mariusweidmann/FAMOS.jl/actions/workflows/CI.yml?query=branch%3Amain) -->
[![Coverage](https://codecov.io/gh/mariusweidmann/FAMOS.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/mariusweidmann/FAMOS.jl)
