#!/bin/bash

COUNTRY="${1:-Italy}"

function filtrami() {
    grep -v Indiana |   # c'e' una svizzera in indiana.. :)
        grep --color "2020-03-..........." 
}

function show_headers() {
    echo -en "Headers vecchio stile: "
    head -1 COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-20-2020.csv
    echo -en "Headers nuovo stile:   "
    head -1 COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-25-2020.csv
}

show_headers

echo "+ ArchivedData/Archived Daily reports ($COUNTRY)"
grep --no-filename "$COUNTRY" COVID-19/archived_data/archived_daily_case_updates/*csv | filtrami

echo "+ CSSE/Daily reports: $COUNTRY"
grep --no-filename -i "$COUNTRY" COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*csv | filtrami


#grep -i "$COUNTRY" 02-2*-2020.csv | filtrami
#grep -i "$COUNTRY" ./03-*-2020.csv  
#grep -i "$COUNTRY" csse_covid_19_data/csse_covid_19_daily_reports/02-2*-2020.csv | grep --color "2020-0.-..........."
#grep -i "$COUNTRY" csse_covid_19_data/csse_covid_19_daily_reports/03-*-2020.csv
