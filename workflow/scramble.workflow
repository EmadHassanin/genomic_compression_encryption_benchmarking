include:
       "../rules/Compression/compress_scramble.rule"

include:
       "../rules/Decompression/decompress_scramble.rule"

rule scramble:
    input:
       #expand(("%s/{sample}.{thread}.scr" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       #expand(("%s/bz2-{sample}.{thread}.scr" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       #expand(("%s/scramble/{sample}.{thread}.bam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
       expand("Compression/output/{sample}.{thread}.scr", thread = config["threads"], sample = config["samples"]),
       expand("Compression/output/bz2-{sample}.{thread}.scr", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/checksums/{sample}.{thread}-scr.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/scramble/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}-scramble.done", thread = config["threads"], sample = config["samples"]),
       expand("Compression/summary/{sample}.{thread}_scramble.summary.tsv", thread = config["threads"], sample = config["samples"]),
    output:
       "Compression/checkpoints/scramble.done"
    shell: 
       """touch {output}"""
