#!/bin/bash

COUNTRY=${1:-Italy}

echo "+ ArchivedData/Archived Daily reports ($COUNTRY)"
grep "$COUNTRY" COVID-19/archived_data/archived_daily_case_updates/*csv

echo "+ CSSE/Daily reports: $COUNTRY"
grep -i "$COUNTRY" COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*csv