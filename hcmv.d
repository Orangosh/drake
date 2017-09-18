GROUND_BASE=/mnt/data/hcmv
RUN=/home/BCRICWH.LAN/ogoshen/software
REF=$[GROUND_BASE]/consensus

VIRUS=CMV
GFF3=$[REF]/merlin.gff3 
REFSET=$[REF]/hcmv_refset.inc

;needs to be less redundent!

SAMPLE_NAME=505-M
%call read2inc.d

SAMPLE_NAME=505-Pa
%call read2inc.d

SAMPLE_NAME=519-Pa
%call read2inc.d

SAMPLE_NAME=519-Pb
%call read2inc.d

SAMPLE_NAME=519-Pc
%call read2inc.d

SAMPLE_NAME=519-Pd
%call read2inc.d

SAMPLE_NAME=519-S1a
%call read2inc.d

SAMPLE_NAME=520-Pa
%call read2inc.d

SAMPLE_NAME=520-Pb
%call read2inc.d

SAMPLE_NAME=520-Pc
%call read2inc.d

SAMPLE_NAME=520-S1a
%call read2inc.d

SAMPLE_NAME=520-S1b
%call read2inc.d

SAMPLE_NAME=579-M
%call read2inc.d

SAMPLE_NAME=579-Pa
%call read2inc.d

SAMPLE_NAME=579-Pb
%call read2inc.d

SAMPLE_NAME=579-S1a
%call read2inc.d

SAMPLE_NAME=579-S1b
%call read2inc.d

