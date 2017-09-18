BASE=$[GROUND_BASE]/$[SAMPLE_NAME]

R=$[GROUND_BASE]/input/$[SAMPLE_NAME]

R1=$[R]/$[SAMPLE_NAME]_$[VIRUS]_R1.fastq.gz
R2=$[R]/$[SAMPLE_NAME]_$[VIRUS]_R2.fastq.gz

VAL1=$[R]/trimed/$[SAMPLE_NAME]_$[VIRUS]_R1_val_1.fq.gz
VAL2=$[R]/trimed/$[SAMPLE_NAME]_$[VIRUS]_R2_val_2.fq.gz

REFfile=$[REF]/$[SAMPLE_NAME]_$[VIRUS]_con.fasta


;triming pear output PEAR-doesn't need pre processig can use trim galore after
;https://groups.google.com/forum/#!msg/pear-users/l5orQlGEZoU/pB6yewmXYwQJ
;currently pear is not used should be used when there is a denovo. 

;%pear <-
;      mkdir $[R]/peared
;      pear-0.9.6-bin-64 -f $[R1] -r $[R2] -o $[R]/peared

%trim <- %pear ;Input is the base reads dependency on trim is only procedural
      mkdir $[R]/trimed
      trim_galore --paired --length 50 -q 20 -o $[R]/trimed $[R1] $[R2]

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

variants<-mpileup
	java -jar $RUN/varscan/VarScan.v2.4.3.jar mpileup2cns $INPUT \
	--min-coverage 15 --min-reads2 5 --min-var-freq 0.02 \
	--p-value 0.01 --min-avg-qual 20 --min-freq-for-hom 0.60 --output-vcf > $OUTPUT

incstats<-mpileup
	java -jar $RUN/genome/genome/target/genome-0.1.1-SNAPSHOT-standalone.jar \
	$INPUT $[GROUND_BASE]/incanted_files/$[SAMPLE_NAME].inc \
	$[REFSET] $[GFF3] > $[OUTPUT]
	sed -i '1i$[SAMPLE_NAME]' $[OUTPUT]