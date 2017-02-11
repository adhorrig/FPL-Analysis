import sys
import csv
import collections

lines = []
for line in sys.stdin:
    line = line.strip()
    info = line.split(":")

    try: #Ensure no bad data
        points = int(info[1])
        info[1] = points
    except ValueError:
        continue
    lines.append(info)

lines.pop(0) #Remove column headers
counter = collections.Counter()
for data in lines: #Count which countries have most points
    counter[data[0]] += int(data[1])
    print(counter)
