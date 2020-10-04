include:
       "../rules/Compression/compress_gzip.rule"

include:
       "../rules/Decompression/decompress_gzip.rule"

rule gzip:
    input:
       #expand(("%s/{sample}.gzip" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       expand("Compression/output/{sample}.gzip", tool = config["tools"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.gzip.md5sum", tool = config["tools"], sample = config["samples"]),
       #expand(("%s/gzip/{sample}.bam" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       expand("Compression/tmp/gzip/{sample}.bam", tool = config["tools"], sample = config["samples"]),
       #expand(("%s/{sample}.gzip.bam" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       expand("Compression/size/{sample}.gzip.size", tool = config["tools"], sample = config["samples"]),
       #expand("Compression/checkpoints/{sample}.gzip.moving.done", tool = config["tools"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.gzip.done", tool = config["tools"], sample = config["samples"]),
       expand("Compression/summary/{sample}_gzip.summary.tsv", tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/gzip.done"
    shell: 
       """touch {output}"""
