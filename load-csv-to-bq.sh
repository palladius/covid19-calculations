
#!/bin/bash

if [ ! -f env.sh ]; then
    @echo "Copy env.sh.dist into env.sh and edit away"
    exit 42
fi

. env.sh 

BQ_DATASET="covid"
BQ_TABLE="csv_imports"
LOCATION="europe-west6" # Zurich

gsutil mb -l "$LOCATION" gs://$MYBUCKET/ # if needed
gsutil cp COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-24-2020.csv  gs://$MYBUCKET/all-covid-data.csv

# TODO(ricc): import ALL CSVs at once into a new BQ dataset which gets deleted and repopulated every day with ONE day more.
# maybe do a TABLE per month?

# without autodetect use \    ./covid-schema.json
bq --location="$LOCATION" mk --dataset \
   --description "covid auto stuff from Riccardo" \
    "$BQ_DATASET"

bq --location="$LOCATION" load --autodetect \
    --source_format="CSV" \
    "$BQ_DATASET.$BQ_TABLE" \
    gs://$MYBUCKET/all-covid-data.csv

