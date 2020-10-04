rule sort_tmp_bam:
    input:
        "Compression/tmp/{tool}/{sample}.bam",
        #"Compression/checkpoints/{tool}.done"
    output:
        temp('Compression/tmp/{tool}/{sample}.sorted.bam'),
    params:
        tmp = config['tmp'],
    shell:
        """
        echo "Sorting file"
        picard SortSam -Xmx6000000000 INPUT={input} OUTPUT={output} SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=TRUE TMP_DIR={params.tmp}
        touch {input}
        echo "Done sorting"
        """ 

rule mark_duplicates:
    input:
        'Compression/tmp/{tool}/{sample}.sorted.bam',
    output:
        temp('Compression/tmp/{tool}/{sample}.marked.bam'),
    params:
        tmp = config['tmp'],
    shell:
        """
        echo "Marking duplicates"
        picard MarkDuplicates INPUT={input} OUTPUT={output} METRICS_FILE=metrics REMOVE_DUPLICATES=true CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=TRUE TMP_DIR={params.tmp}
        echo "Finally marked duplicates"
        """

rule add_read_group_info:
    input:
        'Compression/tmp/{tool}/{sample}.marked.bam',
    output:
        temp('Compression/tmp/{tool}/{sample}.addrg_reads.bam'),
    params:
        tmp = config['tmp'],
    shell:
        """
        echo "Adding read group info"
        picard AddOrReplaceReadGroups INPUT={input} OUTPUT={output} RGID={wildcards.sample} RGLB={wildcards.sample} RGPL=illumina RGPU={wildcards.sample} RGSM={wildcards.sample} CREATE_INDEX=true TMP_DIR={params.tmp}
        """


#rule add_read_group_info_build_bam_index:
#    input:
#        'Compression/tmp/{tool}/{sample}.addrg_reads.bam',
#    output:
#        temp('Compression/tmp/{tool}/{sample}.addrg_reads.bai'),
#    shell:
#        """
#        picard BuildBamIndex INPUT={input} 1>> {output}
#        echo "Done adding read group info"
#        """

rule BQSR_table:
    input:
        'Compression/tmp/{tool}/{sample}.addrg_reads.bam',
    output:
        temp('Compression/tmp/{tool}/{sample}.realigned.bam.table'),
    params:
        ref = config['ref'],
        g1000 = config['G1000'],
        mills = config['MILLS'],
        dbsnp = config['DB_SNP'],
    shell:
        """
        echo "Analyzing covariation"
        gatk --java-options "-Xmx20G -XX:+UseParallelGC -XX:ParallelGCThreads=4" BaseRecalibrator -R {params.ref} -I {input} --known-sites {params.g1000} --known-sites {params.mills} --known-sites {params.dbsnp} -O {output}
        echo "BQSR done"
        """

rule print_reads:
    input:
        'Compression/tmp/{tool}/{sample}.addrg_reads.bam',
        'Compression/tmp/{tool}/{sample}.realigned.bam.table',
    output:
        temp('Compression/tmp/{tool}/{sample}.recall.bam'),
    params:
        ref = config['ref'],
    shell:
        """
        echo "Writing recalibrated BAM"
        gatk --java-options "-Xmx4G -XX:+UseParallelGC -XX:ParallelGCThreads=4" ApplyBQSR -R {params.ref} -I {input[0]}  -bqsr {input[1]} -O {output}
        echo "BQSR done"
        """
rule haplotype_caller:
    input:
        'Compression/tmp/{tool}/{sample}.recall.bam',
    output:
        vcf = temp("Compression/tmp/{tool}/{sample}.final.vcf"),
        l = temp("Compression/tmp/{tool}/{sample}.final.vcf.list"),
        #gvcf = temp("Compression/tmp/{tool}/{sample}.chr{}.g.vcf"),
    params:
        ref = config['ref'],
        chrm = config['CHRNUMBER'],
        cpu = config['cpu'],
        tmp = config['tmp'],
    shell:
        """
        echo "Making gVCF files"
        ADD_CPU=`expr {params.cpu}`
        echo "Running with {params.cpu}"
	
        cat {params.chrm} | parallel -j $ADD_CPU "gatk HaplotypeCaller -R {params.ref} -I {input} -pairHMM FASTEST_AVAILABLE --native-pair-hmm-threads 8 -O Compression/tmp/{wildcards.tool}/{wildcards.sample}.chr{{}}.g.vcf -L {{}} -ERC GVCF -A DepthPerAlleleBySample -A DepthPerSampleHC --tmp-dir={params.tmp}"

	cat {params.chrm} | parallel -j $ADD_CPU "gatk GenotypeGVCFs -R {params.ref} -V Compression/tmp/{wildcards.tool}/{wildcards.sample}.chr{{}}.g.vcf -O Compression/tmp/{wildcards.tool}/{wildcards.sample}.chr{{}}.final.vcf --max-alternate-alleles 16 --tmp-dir={params.tmp}"

	rm -rf Compression/tmp/{wildcards.tool}/{wildcards.sample}.final.vcf.list && for a in $(cat {params.chrm}); do ls Compression/tmp/{wildcards.tool}/{wildcards.sample}.chr$a.final.vcf >> {output.l}; done

	gatk GatherVcfs -I {output.l} -O {output.vcf}
        rm -rf Compression/tmp/{wildcards.tool}/*.idx*
        rm -rf Compression/tmp/{wildcards.tool}/*.g.vcf*
	cat {output.l} | parallel "rm -rf {{}}" 
        """

rule variant_filtering:
    input:
        vcf = "Compression/tmp/{tool}/{sample}.final.vcf",
    params:
        script = "Data/gatk/variant_filtering.sh"
    output:
        filtered_vcf  = "Compression/tmp/{tool}/{sample}.final.vcf.FORMATTED.AB_FILTERED_SNP_INDEL.NONVARIANTFILTERED.vcf.gz",
    shell:
        """
        echo " filtering Indels and SNPs"
	bash {params.script} {input.vcf} all 
        touch {output.filtered_vcf} 
        echo "Done!"
        """

rule concordance:
    input:
        vcf  = "Compression/tmp/{tool}/{sample}.final.vcf.FORMATTED.AB_FILTERED_SNP_INDEL.NONVARIANTFILTERED.vcf.gz",
        #vcf = "Compression/tmp/{tool}/{sample}.final.vcf",
    params:
        ref = config['ref'],
        goldenVcf = config['golden_vcf'],
    output:
        summary = "Compression/summary/{sample}_{tool}.summary.tsv",
    shell:
        """
        echo "Evaluating concordance between vcf files"
	gatk Concordance -R {params.ref} -eval {input.vcf} --truth {params.goldenVcf} --summary {output.summary}
        echo "Done!"
        """
