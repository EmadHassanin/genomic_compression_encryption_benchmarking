#!/usr/bin/python
# -*- coding: utf-8 -*-
#This script is used to compare genotypes of two vcf files and produce the number of matching snps
import os,sys,gzip,codecs,hashlib
#Integragen files comprising of fingerprinting snps
integragen_file=open("/work/megeno/projects/Access/analysis/dev/integragen.refalt.txt", "r")
integragen_positions=[]
for a in integragen_file:
	a=a.rstrip().split()
	integragen_positions.append(a[0]+"_"+a[1]+"_"+a[3]+"_"+a[4])
#print(integragen_positions)

#These are the possible genotypes from vcf file, assumes the file to be decomposed. Cannot handle multi allelic positions at the moment
possible_genotypes=["0/0", "./.", ".", "0/.", "./0", "0/1", "1/0", "1/1", "./1", "1/.", "1"]

#Read in the vcf file and generate a list of snps. Following checks are performed:
#If the position is the same
#The ref and alt alleles can be swapped (It usually happens in the genotype vcf file) 
#If the genotype is not irregular
#If the sample name is same in both the vcf files

vcf1=[]
vcf2=[]
def generate_list(vcf, dummy_list):
	dummy_list=[]
	if vcf.endswith(".vcf.gz"):
		infile=gzip.open(vcf, "rt")
	elif vcf.endswith(".vcf"):
		infile=codecs.open(vcf, "r")
	for a in infile:
		if not a.startswith("#"):
			if not (a.startswith("X") or a.startswith("Y")):
				a=a.rstrip()
				a=a.replace("1/0", "0/1") #To replace the genotypes of the alleles that were flipped
				a=a.split()
				gt=a[9].split(":")[0]
				forward=a[0]+"_"+a[1]+"_"+a[3]+"_"+a[4]
				rev=a[0]+"_"+a[1]+"_"+a[4]+"_"+a[3]
				if forward or rev in integragen_positions:
					if gt in possible_genotypes:
						dummy_list.append(a[0]+"_"+a[1]+"_"+gt)
					else:
						print("impossible genotype at %s"%(a[0]+"_"+a[1]+"_"+gt))
				else:
					print("Position not in integragen list at %s"%(a[0]+"_"+a[1]+"_"+gt))
		else:
			if a.startswith("#CHROM"):
				a=a.rstrip().split()
				sample=a[9]
	return(dummy_list, sample)

#Comparison of two vcf files
first=generate_list(sys.argv[1], vcf1)[0]
first_sample=generate_list(sys.argv[1], vcf1)[1]

second=generate_list(sys.argv[2], vcf2)[0]
second_sample=generate_list(sys.argv[2], vcf2)[1]
hash_vcf1=[hashlib.sha256(l.encode('utf-8')).hexdigest() for l in first]
hash_vcf2=[hashlib.sha256(l.encode('utf-8')).hexdigest() for l in second]
#if first_sample==second_sample: #Exluded this for now
number_snps_first=str(len(first))
number_snps_second=str(len(second))
number_common_snps=str(len(list(set(first) & set(second))))
number_different_snps=str(len(list(set(first) - set(second))))
concordance=str(int(number_common_snps)/int(number_snps_first))
number_common_hashes=str(len(list(set(hash_vcf1) & set(hash_vcf2))))
number_different_hashes=str(len(list(set(hash_vcf1) - set(hash_vcf2))))
concordance_hashes=str(int(number_common_hashes)/int(number_snps_first))
print("\t".join(["number_snps_first", "number_snps_second", "number_common_snps", "number_different_snps", "number_common_hashes", "number_different_hashes", "Concordance", "Concordance_hashes"]))
print("\t".join([number_snps_first, number_snps_second, number_common_snps, number_different_snps, number_common_hashes, number_different_hashes, concordance, concordance_hashes]))

#print(list(zip(first,hash_vcf1)))
#print("Sample names matched and generating report for %s" %(first_sample))
#print("#")
#print("Number of snps in the first vcf %s" %(len(first)))
#print("No of different snps %s" % (len(list(set(first) - set(second)))))
#print("Different snps %s%s" % ("\n","\n".join(list(set(first) - set(second)))))
#print("Number of snps in the second vcf %s" %(len(second)))
#print("No of common snps %s" % (len(list(set(first) & set(second)))))
#print("Common snps %s%s" % ("\n","\n".join(list(set(first) & set(second)))))
#else: #Excluded this for now
#	print("No of common snps %s" % (len(list(set(first) & set(second)))))
#	print("Sample names are not the same, the first sample is %s and the second sample is %s" %(first_sample, second_sample))


#hash_vcf1=[hashlib.sha256(l.encode('utf-8')).hexdigest() for l in first]
#hash_vcf2=[hashlib.sha256(l.encode('utf-8')).hexdigest() for l in second]

#if first_sample==second_sample:
#	print("Sample names matched and generating report for %s" %(first_sample))
#	print("Number of snps in the first vcf %s" %(len(hash_vcf1)))
#	print("No of different snps %s" % (len(list(set(hash_vcf1) - set(hash_vcf2)))))
#	print("Different snps %s%s" % ("\n","\n".join(list(set(hash_vcf1) - set(hash_vcf2)))))
#	print("Number of snps in the second vcf %s" %(len(hash_vcf2)))
#	print("No of common snps %s" % (len(list(set(hash_vcf1) & set(hash_vcf2)))))
#	print("Common snps %s%s" % ("\n","\n".join(list(set(hash_vcf1) & set(hash_vcf2)))))
#else:
#	print("Sample names are not the same, the first sample is %s and the second sample is %s" %(first_sample, second_sample))
