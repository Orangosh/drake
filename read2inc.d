; our base data directory
; BASE=/mnt/data/datafiles

;REF := $BASE/genes/merlin.fasta
;OUT := $(shell pwd)/5*/*
;RUN := /home/BCRICWH.LAN/ogoshen/software/
#R1 := $(shell pwd)/input/*R1*
#R2 := $(shell pwd)/input/*R2*
#BB1 := $(shell echo $(OUT)/*val_1*)
#BB2 := $(shell echo $(OUT)/*val_2*)

;val_1.fq.gz: $(R1) $(R2)
;	$(RUN)/trim_galore/./trim_galore --paired --length 50 -o $(OUT) $^

;$(OUT)/bbmap_output.sam: val_1.fq.gz
;	$(RUN)/bbmap/bbmap.sh ref=$(REF) in=$(shell echo $(BB1)) in2=$(shell echo $(BB2)) \
;	out=$@ sam=1.3 nodisk	

sam2.bam<-/mnt/data/datafiles/579-Pa/579-Pa_merlin/bbmap_output.sam, /mnt/data/datafiles/genes/merlin.fasta 
	samtools view $INPUT0 -S -b -q 10 -T $INPUT1 -o $OUTPUT0

;$(OUT)/sam2.bam: $(OUT)/bbmap_output.sam
;	samtools view $^ -S -b -q 10 -T $(REF) -o $@

;$(OUT)/sorted.bam: $(OUT)/sam2.bam
;	samtools sort $^ -o $@ ; \
;	samtools index $@

;$(OUT)/duplicates_removed.bam: $(OUT)/sorted.bam
;	java -jar $(RUN)/picard/picard.jar MarkDuplicates I=$^  O=$@ \
;	REMOVE_DUPLICATES=true m=%metrics_picard.bam

;$(OUT)/mpileup: $(OUT)/duplicates_removed.bam
;	samtools mpileup -B -f $(REF) $^ -o $@

;$(OUT)/variants: $(OUT)/mpileup
;	java -jar $(RUN)/VarScan/VarScan.v2.4.3.jar mpileup2cns $^ \
;	--min-coverage 1 --min-reads2 1 --min-var-freq 0 \
;	--p-value 99e-02 --min-avg-qual 20 --min-freq-for-hom 0.60 > $@