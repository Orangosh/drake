; our base data directory
BASE=/mnt/data/datafiles/testdir
IN := /mnt/data/datafiles/579-Pa/579-Pa_merlin/bbmap_output.sam
REF := /mnt/data/datafiles/genes/merlin.fasta
;OUT := $(shell pwd)/5*/*
RUN := /home/BCRICWH.LAN/ogoshen/software
;#R1 := $(shell pwd)/input/*R1*
;#R2 := $(shell pwd)/input/*R2*
;#BB1 := $(shell echo $(OUT)/*val_1*)
;#BB2 := $(shell echo $(OUT)/*val_2*)

;val_1.fq.gz: $(R1) $(R2)
;	$RUN/trim_galore/./trim_galore --paired --length 50 -o $(OUT) $^

;$(OUT)/bbmap_output.sam: val_1.fq.gz
;	$(RUN)/bbmap/bbmap.sh ref=$(REF) in=$(shell echo $(BB1))\
;	in2=$(shell echo $(BB2)) \
;	out=$@ sam=1.3 nodisk	

sam2.bam<- 
	samtools view $IN -S -b -q 10 -T $REF -o $OUTPUT

sorted.bam<-sam2.bam
	samtools sort $INPUT -o $OUTPUT 
	samtools index $OUTPUT

duplicates_removed.bam, metrics_picard<-sorted.bam 
	java -jar $RUN/picard/picard.jar MarkDuplicates I=$INPUT  O=$OUTPUT0 \
	REMOVE_DUPLICATES=true m=$OUTPUT1

mpileup<-duplicates_removed.bam
	samtools mpileup -B -f $REF $INPUT0 -o $OUTPUT

variants<-mpileup
	java -jar $RUN/varscan/VarScan.v2.4.3.jar mpileup2cns $INPUT \
	--min-coverage 1 --min-reads2 1 --min-var-freq 0 \
	--p-value 99e-02 --min-avg-qual 20 --min-freq-for-hom 0.60 > $OUTPUT

incanted<-mpileup
	java -jar $RUN/home/BCRICWH.LAN/ogoshen/software/genome/genome/target/genome-0.1.1-SNAPSHOT.jar mpileup incanter