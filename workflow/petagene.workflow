include:
       "../rules/Compression/compress_petagene.rule"

include:
       "../rules/Decompression/decompress_petagene.rule"

rule PGBAM:
    input:
       #expand(("%s/{sample}.{thread}.pgbam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       #expand(("%s/{sample}.{thread}.nomd5.pgbam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       #expand("Compression/output/{sample}.{thread}.pgbam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/output/{sample}.{thread}.nomd5.pgbam", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.{thread}.petagene.md5sum", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/petagene/{sample}.{thread}.com-md5_dec-md5.bam", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/petagene/{sample}.{thread}.com-nomd5_dec-md5.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/petagene/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/petagene/{sample}.{thread}.com-md5_dec-nomd5.bam", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/petagene/{sample}.{thread}.com-nomd5_dec-nomd5.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}.petagene.done", thread = config["threads"], sample = config["samples"]),
       expand("Compression/summary/{sample}.{thread}_petagene.summary.tsv", tool = config["tools"], thread = config["threads"],sample = config["samples"]),
    output:
       "Compression/checkpoints/petagene.done"
    shell: 
        """touch {output}"""
