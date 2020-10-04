rule threads_sort_tmp_bam:
    input:
        "Compression/tmp/{tool}/{sample}.{thread}.bam",
    output:
        'Compression/tmp/{tool}/{sample}.{thread}.sorted.bam',
    shell:
        """
        echo "Sorting file"
        picard SortSam INPUT={input} OUTPUT={output} SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT CREATE_INDEX=TRUE TMP_DIR=%s
        echo "Done sorting"
        """ 

rule threads_mark_duplicates:
    input:
        'Compression/tmp/{tool}/{sample}.{thread}.sorted.bam',
    output:
        'Compression/tmp/{tool}/{sample}.{thread}.marked.bam',
    shell:
        """
        echo "Marking duplicates"
        picard MarkDuplicates INPUT={input} OUTPUT={output} METRICS_FILE=metrics REMOVE_DUPLICATES=true CREATE_INDEX=true VALIDATION_STRINGENCY=LENIENT ASSUME_SORTED=TRUE
        echo "Finally marked duplicates"
        """

rule threads_add_read_group_info:
    input:
        'Compression/tmp/{tool}/{sample}.{thread}.marked.bam',
    output:
        'Compression/tmp/{tool}/{sample}.{thread}.addrg_reads.bam',
    shell:
        """
        echo "Adding read group info"
        picard AddOrReplaceReadGroups INPUT={input} OUTPUT={output} RGID={wildcards.sample} RGLB={wildcards.sample} RGPL=illumina RGPU={wildcards.sample} RGSM={wildcards.sample} CREATE_INDEX=true
        """

rule threads_add_read_group_info_build_bam_index:
    input:
        'Compression/tmp/{tool}/{sample}.{thread}.addrg_reads.bam',
    output:
        'Compression/tmp/{tool}/{sample}.{thread}.addrg_reads.1.bai',
    shell:
        """
        picard BuildBamIndex INPUT={input} 1>> {output}
        echo "Done adding read group info"
        """
