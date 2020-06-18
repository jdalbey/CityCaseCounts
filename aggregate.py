import fileinput
# Create the summary file of aggregate city counts
# Invocation:  ls -1 dailydata/*.csv | python pgm.py
fileslist = []
# Read the list of filenames provided as input into a list
# Read from stdin
for line in fileinput.input():
    fileslist.append(line.rstrip())
    fileslist.sort()
#print fileslist, len(fileslist), fileslist[len(fileslist)-1]

todayfilename = fileslist[len(fileslist)-1]
todaycities = []
# read today's csv file
f = open(todayfilename,'r')
for line in f.readlines():
    fields = line.split(',')
    #get the cities and save as a constant
    todaycities.append(fields[0].replace('"',''))

todaycities.remove('City')
#print len(todaycities),len(fileslist)
# Make 2d array of cities&counts
#table = [[0 for i in range(len(todaycities))] for j in range(len(fileslist))]
#make a dictionary with all the cities as keys
citydict = {}
for c in todaycities:
    citydict[c]=[0 for i in range(len(fileslist))]

day = 0
#for each historic csv file
for filenm in fileslist:
    f = open(filenm,'r')
#    for each entry in the csv
    for line in f.readlines():
        fields = line.split(',')
        if (len(fields[1]) > 1):
            # Place the count in the appropriate day for that city
            citydict[fields[0].replace('"','')][day] = fields[1].rstrip()
    day += 1

#output the dictionary in desired format
for k in citydict:
    outline = '"'+k+'"'+","
    for cnt in citydict[k]:
        outline += str(cnt)+","
    print outline[:-1]


