#!/usr/bin/env nextflow
nextflow.enable.dsl = 2
include { filtlong; porechop; flye; racon; racon_sec; medaka_consensus; homopolish; publish } from './modules.nf'


long_reads = file(params.long_reads)
read_source = params.long_read_source
sketches = file(params.sketches)

workflow {
  long_reads = channel.fromPath(long_reads)
  qc_reads = filtlong(long_reads)
  trim_reads = porechop(qc_reads)
  draft_asm = flye(trim_reads, read_source, params.is_meta)
  racon_first = racon(trim_reads, draft_asm)
  racon_second = racon_sec(trim_reads, racon_first)
  consensus_fasta = medaka_consensus(trim_reads, racon_second)
  homopolish_out = homopolish(consensus_fasta, sketches)
  publish(homopolish_out, params.out_dir)

}
