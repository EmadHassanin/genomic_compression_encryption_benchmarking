#!/usr/bin/bash
#Need to install King software for relationship comparison
#Install vcftools
#Install plink2

#Merge WGS vcf and genotype vcf

wgs=$1
genotype=$2
bcftools merge $wgs $genotype | bgzip -c >$wgs.$genotype.vcf.gz && tabix -fp vcf $wgs.$genotype.vcf.gz 

#Convert merged vcf to bed file
plink2 --file $wgs.$genotype.vcf.gz --make-bed $wgs.$genotype

#Relationship detection using plink

plink2 --bfile $wgs.$genotype --genome --out $wgs.$genotype

#Relationship detection using king

king -b $wgs.$genotype.bed --kinship --ibs --related --degree 3 --prefix $wgs.$genotype

#edit plink file

python edit_plink_file.py $wgs.$genotype.genome

#infer relationships plink
python infer_relations.py $wgs.$genotype.genome >$wgs.$genotype.plink.relationships.tsv

#infer relationships king
python infer_relations_king.py $wgs.$genotype.ibs0 >$wgs.$genotype.king.relationships.tsv
