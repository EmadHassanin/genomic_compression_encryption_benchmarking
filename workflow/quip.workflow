include:
       "../rules/Compression/compress_quip.rule"

include:
       "../rules/Decompression/decompress_quip.rule"

rule quip:
    input:
       #expand(("%s/{sample}.qp" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       expand("Compression/output/{sample}.qp", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.qp.md5sum", thread = config["threads"], sample = config["samples"]),
       #expand(("%s/quip/{sample}.bam" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       expand("Compression/tmp/quip/{sample}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.quip.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/quip/{sample}.summary.tsv", thread = config["threads"], sample = config["samples"]),
    output:
       "Compression/checkpoints/quip.done"
    shell:
       """touch {output}"""
