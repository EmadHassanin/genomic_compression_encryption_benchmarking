include:
       "../rules/encryption/encrypt_cryfa.rule"

include:
       "../rules/decryption/decrypt_cryfa.rule"

rule cryfa:
    input:
       expand(("%s/{sample}.{thread}.cryfa" % (config["finaldir"])), thread = config["threads"], sample = config["samples"]),
      # expand("Compression/output/{sample}.{thread}.cryfa", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}.{thread}-cryfa.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/cryfa/{sample}.{thread}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}.{thread}-cryfa.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/cryfa/{sample}.{thread}.summary.tsv", thread = config["threads"], tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/cryfa.done"
    shell: 
       """touch {output}"""

