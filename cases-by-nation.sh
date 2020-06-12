#!/bin/bash

COUNTRY="${1:-Italy}"

function filtrami() {
    grep -v Indiana |   # c'e' una svizzera in indiana.. :)
        grep --color "2020-0[45678]-..........." 
}

function commas_to_tabs() {
            sed 's/ /_/g' |
            sed 's/_..:..:..//g' | # remove time from date
            sed 's/,/   /g'
#        grep --color "2020-0.-..........." |
#        sed -e 's/46.8182,8.2275/SWISS_GEO/g' |
#        sed -e 's/41.87194,12.56738/ITALY_GEO/g'
}

function show_headers() {
    #echo -en "Headers vecchio stile: "
    #head -1 COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-20-2020.csv
    #echo -en "Headers nuovo stile:   "
    head -1 COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/04-01-2020.csv
}


#echo "+ ArchivedData/Archived Daily reports ($COUNTRY)"
#grep --no-filename "$COUNTRY" COVID-19/archived_data/archived_daily_case_updates/*csv | filtrami

echo "# CSSE/Daily reports: $COUNTRY"
show_headers | commas_to_tabs
grep --no-filename -i "$COUNTRY" COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*csv | filtrami | commas_to_tabs


#grep -i "$COUNTRY" 02-2*-2020.csv | filtrami
#grep -i "$COUNTRY" ./03-*-2020.csv  
#grep -i "$COUNTRY" csse_covid_19_data/csse_covid_19_daily_reports/02-2*-2020.csv | grep --color "2020-0.-..........."
#grep -i "$COUNTRY" csse_covid_19_data/csse_covid_19_daily_reports/03-*-2020.csv
