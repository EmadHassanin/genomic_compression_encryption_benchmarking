#!/usr/bin/python

import os,sys
infile=open(sys.argv[1], "r")
for a in infile:
    a=a.rstrip().split("\t")
    if not a[9] == "PI_HAT":
	if 0.44 > float(a[9]) > 0.25:
	    print a[1], a[2], a[6], a[7], a[8], a[9], "2nd Degree"
	elif 0.7 >= float(a[9]) >= 0.4:
	    if 0.75 < float(a[7]):
		if 0.1 > float(a[8]):
		    if 0.1 > float(a[6]):
			print a[1], a[3], a[6], a[7], a[8], a[9], "Parent"
	    else:
		print a[1], a[3], a[6], a[7], a[8], a[9], "siblings"
	elif 0.2 >= float(a[9]) >= 0.12:
	    print a[1], a[3], a[6], a[7], a[8], a[9], "3rd Degree"
        elif float(a[9]) >= 0.9:
	    print a[1], a[3], a[6], a[7], a[8], a[9], "Twins/Duplicates"
	else:
	    print a[1], a[3], a[6], a[7], a[8], a[9], "unrelated"
