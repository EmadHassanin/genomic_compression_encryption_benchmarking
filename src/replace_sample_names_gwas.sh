#!/usr/bin/bash

vcf=$1
dirname=$(dirname $vcf)
sample=$(echo $(basename $vcf) | sed 's/ADNI_GO_2_Forward_Bin.integragen.vcf.gz.//g' | cut -d "_" -f2- | sed 's/.vcf.gz//g')

zcat $vcf | bcftools reheader -s <(echo $sample) | bgzip -c >$dirname/ADNI_GO_2_Forward_Bin.integragen.vcf.gz.changed.$sample.vcf.gz && tabix -fp vcf $dirname/ADNI_GO_2_Forward_Bin.integragen.vcf.gz.changed.$sample.vcf.gz
