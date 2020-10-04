include:
       "../rules/Compression/compress_petagene_nomd5sum.rule"

include:
       "../rules/Decompression/decompress_petagene_nomd5sum.rule"

rule PGBAM:
    input:
       expand("Compression/output/{sample}.{thread}.pgbam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}.{thread}-petagene.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/petagene/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}-petagene.done", thread = config["threads"], sample = config["samples"])
    output:
       "Compression/checkpoints/petagene.done"
    shell: 
        """touch {output}"""
