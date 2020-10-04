#!/usr/bin/bash

bcftools concat -f /work/megeno/projects/Access/data/genetic/vcf/adni/vcf_files.tsv >/work/megeno/projects/Access/data/genetic/vcf/adni/adni.wgs.integragen.vcf

cat /work/megeno/projects/Access/data/genetic/vcf/adni/adni.wgs.integragen.vcf | bcftools query -l >/work/megeno/projects/Access/data/genetic/vcf/adni/adni.wgs.samples.tsv

cat /work/megeno/projects/Access/data/genetic/vcf/adni/adni.wgs.samples.tsv | parallel "cat /work/megeno/projects/Access/data/genetic/vcf/adni/adni.wgs.integragen.vcf | bcftools view -s {} | bgzip -c >/work/megeno/projects/Access/data/genetic/vcf/adni/per_sample/adni.wgs.integragen.{}.vcf.gz && tabix -fp vcf /work/megeno/projects/Access/data/genetic/vcf/adni/per_sample/adni.wgs.integragen.{}.vcf.gz"
