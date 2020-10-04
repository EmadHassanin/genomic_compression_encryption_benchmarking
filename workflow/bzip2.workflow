include:
       "../rules/Compression/compress_bzip2.rule"

include:
       "../rules/Decompression/decompress_bzip2.rule"

rule bzip2:
    input:
       expand(("%s/{sample}.bzip2" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       #expand("Compression/output/{sample}.bzip2", tool = config["tools"], sample = config["samples"]),
       expand("Compression/checksums/{sample}.bzip2.md5sum", tool = config["tools"], sample = config["samples"]),
       expand("Compression/tmp/bzip2/{sample}.bam", tool = config["tools"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.bzip2.done", tool = config["tools"], sample = config["samples"]),
       #expand("Compression/tmp/bzip2/{sample}.summary.tsv", tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/bzip2.done"
    shell: 
       """touch {output}"""
