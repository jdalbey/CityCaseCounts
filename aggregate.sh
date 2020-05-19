#!/bin/bash
# Fetch the daily cases page.  Save in csv format in a file named with today's date.
# Aggregate the daily data into a single cumulative csv file.
# This script is run by NAS task scheduler once a day.
# N.B. For some reason the NAS won't overwrite the output files
# if the content hasn't changed.  At least that's what it seems like.
# This shouldn't be a problem in the normal workflow, but during
# testing gave confusing results.

# Require a parameter
if [ "$#" -ne 1 ] 
then
  echo please provide path to Docs folder.
  echo "Either /home/jdalbey/Docs (for desktop) or /volume1/homes/jdalbey/Drive (for NAS)"
  exit 1
fi

# Fetch the daily data page and parse it.
wget -q -O - https://e.infogram.com/f6d9f731-5772-4da5-b149-5e42cc1c3b89 | sed -n '/Cases by City/p' | sed 's/<script>window.infographicData=//g' | sed 's#</script>##' | sed 's/\["City/\n\"City/g'  | sed 's/,"custom/\n/'| sed '1,2d' | sed '$d' | sed 's/\],\[/\n/g' |  sed 's/\]\]\]//' | sed 's/"$//g' | sed 's/","/",/g'  > "$1/Computer/Projects/CityCaseCounts/dailydata/`date +%Y-%m%d`.csv"

echo "wget of today's data completed to $1/Computer/Projects/CityCaseCounts/dailydata/`date +%Y-%m%d`.csv"

# Create a work directory
kWork="/tmp/Citydata"
if [ -d $kWork ]; then
    rm -r $kWork/*
else 
    mkdir $kWork
fi

# For each daily data file
#    Extract the data lines and sort them and save just the numbers
cd $1/Computer/Projects/CityCaseCounts/dailydata
for f in *.csv ; do tail -n+2 $f | sort | cut -d"," -f2   > $kWork/$f ; done

# Create a file of just city names sorted alphabetically
tail -n+2 2020-0425.csv | sort | cut -d"," -f1  > $kWork/cities.txt

# Create a file of city names ordered by count (descending) from today's data
sort -k2 -t, -nr "$1/Computer/Projects/CityCaseCounts/dailydata/`date +%Y-%m%d`.csv" | cut -d, -f1 > $1/Computer/Projects/CityCaseCounts/CityCaseCounts.git/trunk/sortedCityNames.txt

# Get all the filenames (dates) into a single file
ls -1 *.csv | cut -d "." -f 1  | cut -d "-" -f 2 | paste -d, -s > $1/Computer/Projects/CityCaseCounts/CityCaseCounts.git/trunk/days.txt

# Merge the city names and the aggregate daily data
paste -d, $kWork/cities.txt $kWork/2*.csv > $1/Computer/Projects/CityCaseCounts/CityCaseCounts.git/trunk/cumulative.csv

echo "Cumulative file created at `date`."

