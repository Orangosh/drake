BASE=$[GROUND_BASE]/$[SAMPLE_NAME]/$[SAMPLE_NAME]_$[REF]

SAVAGE=$[GROUND_BASE]/$[SAMPLE_NAME]/savaged

R=$[GROUND_BASE]/input/$[SAMPLE_NAME]
R1=$[R]/$[SAMPLE_NAME]_CMV_R1.fastq.gz
R2=$[R]/$[SAMPLE_NAME]_CMV_R2.fastq.gz

VAL1=$[R]/trimed/$[SAMPLE_NAME]_CMV_R1_val_1.fq.gz
VAL2=$[R]/trimed/$[SAMPLE_NAME]_CMV_R2_val_2.fq.gz

;PEAR=$[R]/peared/$[SAMPLE_NAME].assembled.fastq ; pear- used for savaged
;PEAR_VAL=$[R]/peared/$[SAMPLE_NAME].assembled_trimmed.fq


REFfile=$[GROUND_BASE]/$[REF]/$[SAMPLE_NAME]_CMV_con.fasta

%pear <-
      mkdir $[R]/peared
      pear-0.9.6-bin-64 -f $[R1] -r $[R2] -o $[R]/peared

%trim <- %pear ;Input is the base reads dependency on trim is only procedural
      mkdir $[R]/trimed
      trim_galore --paired --length 50 -o $[R]/trimed $[R1] $[R2]

;triming pear output PEAR-doesn't need pre processig can use trim galore after
;https://groups.google.com/forum/#!msg/pear-users/l5orQlGEZoU/pB6yewmXYwQJ
;%savaged<-%trim
;	mkdir $[R]/peared
;	trim_galore --length 50 -o  $[R]/peared $[PEAR] 
;	source activate python2
;	savage -s $[PEAR_VAL] -m 200 -t 8 --split 1 

bbmap_output.sam <- %trim
	 bbmap.sh ref=$REFfile in=$[VAL1] in2=$[VAL2] out=$OUTPUT sam=1.3 nodisk

sam2.bam<-bbmap_output.sam
	samtools view $INPUT -S -b -q 10 -T $REFfile -o $OUTPUT

sorted.bam<-sam2.bam
	samtools sort $INPUT -o $OUTPUT 
	samtools index $OUTPUT

duplicates_removed.bam, metrics_picard<-sorted.bam 
	java -jar $RUN/picard/picard.jar MarkDuplicates I=$INPUT  O=$OUTPUT0 \
	REMOVE_DUPLICATES=true m=$OUTPUT1

mpileup<-duplicates_removed.bam
	samtools mpileup -Q 20 -f $REFfile $INPUT0 -o $OUTPUT 

;%shorahed<-duplicates_removed.bam
;	mkdir $[BASE]/shorahed
;	source activate python2
;	python /home/BCRICWH.LAN/ogoshen/software/shorah/shorah.py -b /mnt/data/datafiles/505-Pa/505-Pa_concensus/sorted.bam -f /mnt/data/datafiles/concensus/505-Pa_CMV_con.fasta -w 120 

;%QuasiRecombed<-dulicates_removed.bam
;	mkdir $[BASE]/QuasiRecombed
;	java -jar $RUN/QuasiRecomb/QuasiRecomb.jar -i $INPUT  -o $[BASE]/QuasiRecombed

;%haplocliqued<-duplicates_removed.bam
;	mkdir $[BASE]/haplocliqued
;	haploclique $INPUT $[BASE]/haplocliqued

variants<-mpileup
	java -jar $RUN/varscan/VarScan.v2.4.3.jar mpileup2cns $INPUT \
	--min-coverage 15 --min-reads2 1 --min-var-freq 0 \
	--p-value 99e-02 --min-avg-qual 20 --min-freq-for-hom 0.60 > $OUTPUT

incstats<-mpileup
	java -jar $RUN/genome/genome/target/genome-0.1.1-SNAPSHOT-standalone.jar $INPUT /mnt/data/datafiles/incanted_files/$[SAMPLE_NAME].inc > $[OUTPUT]
	sed -i '1i$[SAMPLE_NAME]' $[OUTPUT] ;adds name 