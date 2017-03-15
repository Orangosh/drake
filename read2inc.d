BASE=$[GROUND_BASE]/$[SAMPLE_NAME]/$[SAMPLE_NAME]_$[REF]

R=$[GROUND_BASE]/input/$[SAMPLE_NAME]/$[SAMPLE_NAME]
R1=$[R]_CMV_R1.fastq.gz
R2=$[R]_CMV_R2.fastq.gz
PEAR_FWD=$[R].unassembled.forward.fastq
PEAR_BKW=$[R].unassembled.reverse.fastq
VAL1=$[BASE]/trimed/$[SAMPLE_NAME].unassembled.forward_val_1.fq
VAL2=$[BASE]/trimed/$[SAMPLE_NAME].unassembled.reverse_val_2.fq

REFw=$[GROUND_BASE]/$[REF]/$[SAMPLE_NAME]_CMV_con.fasta

%pear <-
      pear-0.9.6-bin-64 -f $[R1] -r $[R2] -o $[R]
      
%trim <- %pear
      mkdir $[BASE]/trimed
      trim_galore --paired --length 50 -o $[BASE]/trimed $[PEAR_FWD] $[PEAR_BKW]

bbmap_output.sam <- %trim
	 bbmap.sh ref=$REFw in=$[VAL1] in2=$[VAL2] out=$OUTPUT sam=1.3 nodisk	

sam2.bam<-bbmap_output.sam
	samtools view $INPUT -S -b -q 10 -T $REFw -o $OUTPUT

sorted.bam<-sam2.bam
	samtools sort $INPUT -o $OUTPUT 
	samtools index $OUTPUT

duplicates_removed.bam, metrics_picard<-sorted.bam 
	java -jar $RUN/picard/picard.jar MarkDuplicates I=$INPUT  O=$OUTPUT0 \
	REMOVE_DUPLICATES=true m=$OUTPUT1

mpileup<-duplicates_removed.bam
	samtools mpileup -Q 20 -f $REFw $INPUT0 -o $OUTPUT 

;report.shorah<-duplicates_removed.bam
;	source activate python2
;	python /home/BCRICWH.LAN/ogoshen/software/shorah/shorah.py -b /mnt/data/datafiles/505-Pa/505-Pa_concensus/sorted.bam -f /mnt/data/datafiles/concensus/505-Pa_CMV_con.fasta -w 120 

variants<-mpileup
	java -jar $RUN/varscan/VarScan.v2.4.3.jar mpileup2cns $INPUT \
	--min-coverage 15 --min-reads2 1 --min-var-freq 0 \
	--p-value 99e-02 --min-avg-qual 20 --min-freq-for-hom 0.60 > $OUTPUT

incstats<-mpileup
	java -jar $RUN/genome/genome/target/genome-0.1.1-SNAPSHOT-standalone.jar $INPUT /mnt/data/datafiles/incanted_files/$[SAMPLE_NAME].inc > $[OUTPUT]