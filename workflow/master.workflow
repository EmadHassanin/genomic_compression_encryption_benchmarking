import subprocess

workdir: "/home/Archive"

include:
       "cram.workflow"

include:
       "petagene.workflow"

include:
       "quip.workflow"

include:
       "deez.workflow"

include:
       "scramble.workflow"

include: 
      "gzip.workflow"

#include: 
#      "pigz.workflow"

include: 
      "bzip2.workflow"

include: 
      "lz4.workflow"

#include: 
#      "pbzip2.workflow"

include: 
      "cryfa.workflow"

include: 
      "crypt4gh.workflow"

include: 
      "zip.workflow"

include: 
      "ccrypt.workflow"

include: 
      "openssl.workflow"

include: 
      "gnupg.workflow"

include: 
      "pprotect.workflow"

#include:
#      "gatk_no_threads.workflow"
#include:
#      "md5sum_size.workflow"


rule ALL:
    input:
        expand("Compression/checkpoints/{tool}.done", tool = config["tools"]),
    output:
        "Compression/checkpoints/all.done"
    shell: 
        """touch {output}"""
