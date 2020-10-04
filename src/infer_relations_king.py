#!/usr/bin/python

import sys,os
# >0.354, [0.177, 0.354], [0.0884, 0.177] and [0.0442, 0.0884] corresponds to duplicate/MZ twin, 1st-degree, 2nd-degree, and 3rd-degree relationships respectively
infile=open(sys.argv[1], "r")
print "ID1","ID2","Kinship_coeff", "Inferred_relation"
for a in infile:
	if not "ID" in a:
		a=a.rstrip().split()
		if float(a[-1])>0.354:
			print a[0],a[2],a[-1], "Twins/Duplicates"
		elif 0.354 >= float(a[14]) >0.177:
			print a[0],a[2],a[-1], "1st-degree"
		elif 0.177 >= float(a[-1]) > 0.0884:
			print a[0],a[2],a[-1], "2nd-degree"
		elif 0.0884 >= float(a[-1]) > 0.0442:
			print a[0],a[2],a[-1], "3rd-degree"
		elif 0.0442 > float(a[-1]):
			print a[0],a[2],a[-1], "Unrelated"

