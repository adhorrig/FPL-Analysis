import sys
import csv

reader = csv.reader(open(sys.argv[1]),
dialect='excel')
for row in reader:
    try:
        print row[4]+':'+row[5]
    except IndexError:
        continue
