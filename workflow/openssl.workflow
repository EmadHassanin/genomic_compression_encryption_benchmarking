include:
       "../rules/encryption/encrypt_openssl.rule"

include:
       "../rules/decryption/decrypt_openssl.rule"

rule openssl:
    input:
       expand(("%s/{sample}.dat" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       #expand("Compression/output/{sample}.dat", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}-openssl.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/openssl/{sample}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}-dat.done", thread = config["threads"], sample = config["samples"]),
       #expand("Compression/tmp/openssl/{sample}.summary.tsv", tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/dat.done"
    shell: 
       """touch {output}"""
