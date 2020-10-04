include:
       "../rules/Compression/compress_pprotect.rule"

include:
       "../rules/Decompression/decompress_pprotect.rule"

rule pprotect:
    input:
       expand("Compression/output/{sample}.{thread}.pgbam_p", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/pprotect/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/size/{sample}.{thread}.pprotect.size", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}.pprotect.done", thread = config["threads"], sample = config["samples"]),
    output:
       "Compression/checkpoints/pprotect.done"
    shell: 
       """touch {output}"""
