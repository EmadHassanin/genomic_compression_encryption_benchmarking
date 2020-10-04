include:
       "../rules/encryption/encrypt_crypt4gh.rule"

include:
       "../rules/decryption/decrypt_crypt4gh.rule"

rule crypt4gh:
    input:
       expand(("%s/{sample}.c4gh" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
       #expand("Compression/output/{sample}.c4gh", sample = config["samples"]),
       expand("receiver_{sample}.sec", sample = config["samples"]),
       expand("receiver_{sample}.pub", sample = config["samples"]),
       expand("Compression/checksums/{sample}-c4gh.md5sum", sample = config["samples"]),
       expand("Compression/tmp/c4gh/{sample}.bam", sample = config["samples"]),
       expand("Compression/checkpoints/{sample}-c4gh.done", sample = config["samples"]),
       #expand("Compression/tmp/c4gh/{sample}.summary.tsv", sample = config["samples"]),
    output:
       "Compression/checkpoints/c4gh.done"
    shell: 
       """touch {output}"""
