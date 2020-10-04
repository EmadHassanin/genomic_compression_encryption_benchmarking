include:
       "../rules/Compression/compress_lz4.rule"

include:
       "../rules/Decompression/decompress_lz4.rule"

rule lz4:
    input:
       expand("Compression/output/{sample}.{thread}.bam.lz4", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/lz4/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/size/{sample}.{thread}.lz4.size", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}.lz4.done", thread = config["threads"], sample = config["samples"]),
    output:
       "Compression/checkpoints/lz4.done"
    shell: 
       """touch {output}"""
