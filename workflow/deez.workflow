include:
       "../rules/Compression/compress_deez.rule"

include:
       "../rules/Decompression/decompress_deez.rule"

rule deez:
    input:
       #expand(("%s/{sample}.{thread}.dz" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       expand("Compression/output/{sample}.{thread}.dz", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.{thread}-dz.md5sum", thread = config["threads"], sample = config["samples"]),
       #expand(("%s/deez/{sample}.{thread}.bam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/deez/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}-deez.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/summary/{sample}.{thread}_deez.summary.tsv", thread = config["threads"], tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/deez.done"
    shell: 
       """touch {output}"""
