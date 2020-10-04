include:
       "../rules/encryption/encrypt_zip.rule"

include:
       "../rules/decryption/decrypt_zip.rule"

rule zip:
    input:
       expand(("%s/{sample}.zip" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       #expand("Compression/output/{sample}.zip", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}-zip.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/zip/{sample}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}-zip.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/zip/{sample}.summary.tsv", thread = config["threads"], sample = config["samples"]),
    output:
       "Compression/checkpoints/zip.done"
    shell: 
       """touch {output}"""
