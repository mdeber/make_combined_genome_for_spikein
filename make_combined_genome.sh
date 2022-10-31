#!/usr/bin/env bash
# 
# This script will build a fasta file and a bowtie2 index for
# a combined genome containing experimental and spike-in chromosomes. 
# 
# The purpose of this is to do a competitive alignment, where the aligner
# decides which reads came from the experimental material, which came from 
# the spike-in genome, and which are ambiguous.
# 
# The chromosomes from the spike-in genome are renamed with a prefix 
# that makes them simple to identify for finding reads mapping to the 
# spike-in, and for removing them for downstream analyses.
# 
# Would it have been simpler to use no variables at all? Maybe
# 

EXP_FASTA="~/genomes/fasta/hg38.analysisSet.fa";
SPIKE_FASTA="~/genomes/fasta/dm6.fa";
SPIKE_PREFIX="dm6_";
OUT_BASENAME="hg38_dm6_combined";
FASTA_OUTDIR="~/genomes/fasta";
BT2_OUTDIR="~/genomes/bowtie2";
NTHREADS=64;

# make combined fasta with altered spike-in chromosome names
cat ${EXP_FASTA} <(cat ${SPIKE_FASTA} | sed 's/^>/>'"$SPIKE_PREFIX"'/') > ${FASTA_OUTDIR}/${OUT_BASENAME}.fa;

# building a bowtie2 index
mkdir ${BT2_OUTDIR}/${OUT_BASENAME}_bt2;

bowtie2-build \
--threads ${NTHREADS} \
${FASTA_OUTDIR}/${OUT_BASENAME}.fa \
${BT2_OUTDIR}/${OUT_BASENAME}_bt2/${OUT_BASENAME};

exit 0;