include:
       "../rules/encryption/encrypt_gnupg.rule"

include:
       "../rules/decryption/decrypt_gnupg.rule"

rule gnupg:
    input:
       expand(("%s/{sample}.gpg" % (config["finaldir"])), tool = config["tools"], sample = config["samples"]),
      # expand("Compression/output/{sample}.gpg", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checksums/{sample}-gnupg.md5sum", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/gnupg/{sample}.bam", thread = config["threads"], sample = config["samples"]),
       expand("Compression/checkpoints/{sample}-gnupg.done", thread = config["threads"], sample = config["samples"]),
       expand("Compression/tmp/gnupg/{sample}.summary.tsv", tool = config["tools"], sample = config["samples"]),
    output:
       "Compression/checkpoints/gpg.done"
    shell: 
       """touch {output}"""
