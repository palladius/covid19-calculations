
#!/bin/bash

VERSION="1_1"

if [ ! -f env.sh ]; then
    echo "env.sh not found! Copy env.sh.dist into env.sh and edit away"
    exit 1
fi

source env.sh 

echo "DEB env loaded"

BQ_TABLE="csv_imports_v$VERSION"
LOCATION="europe-west6" # Zurich (BQ and GCe location - they need to be the same)
OUTDIR="out-hashes/"
BQ_URL="https://console.cloud.google.com/bigquery?GK=$PROJECT_ID&redirect_from_classic=true&project=$PROJECT_ID&folder=&organizationId=&p=$PROJECT_ID&d=covid&t=csv_imports_v1_1&page=table"


hash_data_by_csv_header() {
    # not all headers are born equals, these gentlemen are doing everything different!!!
    # Run this to understand: head -1 COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-*csv
    mkdir -p $OUTDIR/
    rm $OUTDIR/*.hashlist
    for FILE in COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/*.csv ; do
        FILE_HEAD=$(head -1 $FILE)
        FILE_HEAD_HASH=$(head -1 $FILE|md5sum| awk '{print $1}')
        #echo "FILE: [HASH: $FILE_HEAD_HASH] $FILE"
        echo "file:$FILE" >> $OUTDIR/$FILE_HEAD_HASH.hashlist
    done
    echo Hashlist created:
    find $OUTDIR/ -name *hashlist
}


# schema: https://cloud.google.com/bigquery/docs/schemas
csse_covid19_daily_reports() {
    DIR="COVID-19/csse_covid_19_data/csse_covid_19_daily_reports"
    #DAILY_REPORTS_SCHEMA="qtr:STRING,sales:FLOAT,year:STRING"
    DAILY_REPORTS_SCHEMA="FIPS:INTEGER,Admin2:STRING,Province_State:STRING,Country_Region:STRING,Last_Update:STRING,Lat:FLOAT,Long_:FLOAT,Confirmed:INT64,Deaths:INT64,Recovered:INT64,Active:INT64,Combined_Keyp:STRING"

    #ls $DIR/*csv | grep 04-04-2020 |      xargs  --max-args=1 echo bq load --format=csv  --autodetect "$BQ_DATASET.$BQ_TABLE" "$SCHEMA"
    FILE=COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/04-04-2020.csv
    head -3 "$FILE"
    tail -3 "$FILE"
    bq load --format=csv --skip_leading_rows=1 "$BQ_DATASET.$BQ_TABLE" "$FILE" "$DAILY_REPORTS_SCHEMA"
}

# TODO(ricc): import ALL CSVs at once into a new BQ dataset which gets deleted and repopulated every day with ONE day more.
# maybe do a TABLE per month?
hash_data_by_csv_header
csse_covid19_daily_reports
echo ci sarebbe altro ma esco per ora
echo "Now open: $BQ_URL"
exit 0

gsutil mb -l "$LOCATION" gs://$MYBUCKET/ # if needed
gsutil cp COVID-19/csse_covid_19_data/csse_covid_19_daily_reports/03-24-2020.csv  gs://$MYBUCKET/all-covid-data.csv

# without autodetect use \    ./covid-schema.json
bq --location="$LOCATION" mk --dataset \
   --description "covid auto stuff from Riccardo" \
    "$BQ_DATASET"

bq --location="$LOCATION" load --autodetect \
    --source_format="CSV" \
    "$BQ_DATASET.$BQ_TABLE" \
    gs://$MYBUCKET/all-covid-data.csv

