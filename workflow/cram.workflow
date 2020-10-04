include:
       "../rules/Compression/compress_cram.rule"

include:
       "../rules/Decompression/decompress_cram.rule"


rule CRAM:
    input:
       #expand(("%s/{sample}.{thread}.cram" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       #expand(("%s/cram/{sample}.{thread}.bam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       expand("Compression/output/{sample}.{thread}.cram", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.{thread}-cram.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}-cram.done", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/cram/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/summary/{sample}.{thread}_cram.summary.tsv",thread = config["threads"], tool = config["tools"], sample = config["samples"]),

    output:
       "Compression/checkpoints/cram.done"
    shell: 
      """touch {output}"""
