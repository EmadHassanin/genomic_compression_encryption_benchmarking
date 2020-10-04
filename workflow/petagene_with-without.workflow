include:
       "../rules/petagene/rule"

rule PGBAM_with_without:
    input:
       expand(("%s/{sample}.{thread}.pgbam" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
      #expand("Compression/output/{sample}.{thread}.pgbam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}.{thread}-md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/petagene/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}.done", thread = config["threads"], sample = config["samples"])
    output:
       "Compression/checkpoints/petagene_all.done"
    shell: 
        """touch {output}"""
