include:
       "../rules/encryption/encrypt_ccrypt.rule"

include:
       "../rules/decryption/decrypt_ccrypt.rule"

rule ccrypt:
    input:
       expand(("%s/{sample}.cpt" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       #expand("Compression/output/{sample}.cpt", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}-ccrypt.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/ccrypt/{sample}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}-ccrypt.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/ccrypt/{sample}.summary.tsv", tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/cpt.done"
    shell: 
       """touch {output}"""
