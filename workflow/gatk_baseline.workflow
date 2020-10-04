rule sort_tmp_bam:
    input:
         expand("/home/Archive/{bucket}", bucket = config["bucket"]),
         bam = "%s/{sample}.bam" % config["bucket"],
    output:
        'output/gatk/{sample}.sorted.bam',
    shell:
        """
        echo "Sorting file"
        picard SortSam INPUT={input} OUTPUT={output} SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=TRUE TMP_DIR=%s
        echo "Done sorting"
        """ 

rule mark_duplicates:
    input:
        'output/gatk/{sample}.sorted.bam',
    output:
        'output/gatk/{sample}.marked.bam',
    shell:
        """
        echo "Marking duplicates"
        picard MarkDuplicates INPUT={input} OUTPUT={output} METRICS_FILE=metrics REMOVE_DUPLICATES=true CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=TRUE
        echo "Finally marked duplicates"
        """

rule add_read_group_info:
    input:
        'output/gatk/{sample}.marked.bam',
    output:
        'output/gatk/{sample}.addrg_reads.bam',
    shell:
        """
        echo "Adding read group info"
        picard AddOrReplaceReadGroups INPUT={input} OUTPUT={output} RGID={wildcards.sample} RGLB={wildcards.sample} RGPL=illumina RGPU={wildcards.sample} RGSM={wildcards.sample} CREATE_INDEX=true
        """


rule add_read_group_info_build_bam_index:
    input:
        'output/gatk/{sample}.addrg_reads.bam',
    output:
        'output/gatk/{sample}.addrg_reads.1.bai',
    shell:
        """
        picard BuildBamIndex INPUT={input} 1>> {output}
        echo "Done adding read group info"
        """
