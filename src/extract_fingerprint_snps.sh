#!/bin/bash -l
#Script used to extract snps from a vcf file
#Needs tabix installed
vcf=$1
bed=$2

if [[ $vcf == *.gz ]]; then
	tabix -hfB $vcf $bed >$vcf.fingerprint.vcf
else
	echo "Not gzipped, compressing now"
	cat $vcf | bgzip -c >$vcf.gz 
	tabix -fp vcf $vcf.gz
	tabix -hfB $vcf.gz $bed >$vcf.gz.fingerprint.vcf
fi
