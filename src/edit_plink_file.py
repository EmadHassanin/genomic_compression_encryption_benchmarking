#!/usr/bin/env/python

#File used to modify plink output file into a tab separated file. Input file is the plink output file


import sys, os
out=open(sys.argv[1]+".modified", "w")
for a in open(sys.argv[1], "r"):
    out.write('\t'.join(a.split())+"\n")
os.system("mv -f %s %s"%(sys.argv[1]+".modified", sys.argv[1]))
