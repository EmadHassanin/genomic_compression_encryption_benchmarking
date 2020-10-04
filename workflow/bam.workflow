import subprocess

TMPDIR = os.environ.get("TMPDIR", "/tmp")
OUTDIR = os.environ.get("OUTDIR", ".")
VCF = os.environ.get("VCF") 
BAM = os.environ.get("BAM") 
DESTINATION = os.environ.get("DESTINATION") # This should be replaced with the cloud storage
PORT = os.environ.get("PORT", "22") # Replace if necessary

workdir: 
    OUTDIR

report: "report/transfer.rst"

include:
       "../rules/Transfer/transfer_bam.rule"

include:
       "../rules/Transfer/transfer_vcf.rule"

include:
       "../rules/Transfer/run_checksum.rule"

include:
       "../rules/Transfer/transfer_checksum.rule"

rule MASTER:
    input:
        "checksum/bam_checksum.txt", 
        "checksum/vcf_checksum.txt",
        "checkpoint/checksum_transfer.complete",
        "checkpoint/vcf_transfer.complete",
        "checkpoint/bam_transfer.complete"
    output:
        "checkpoint/transfer.done"
    shell: 
        """touch {output}"""
