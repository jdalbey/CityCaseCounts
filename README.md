## Positive Case Counts by City over time

A graphic display of coronavirus case counts for San Luis Obispo County. 

Each line is a city.

Horizontal axis is date, vertical axis is number of persons.

Each day an automated process grabs the postive case details page: https://www.emergencyslo.org/en/positive-case-details.aspx.

The script 'aggregate.sh' then extracts that days data and saves it locally. 

It is then committed to the repo where it is read and charted when the web page loads.

Live Site: [https://jdalbey.github.io/CityCaseCounts/](https://jdalbey.github.io/CityCaseCounts/)

