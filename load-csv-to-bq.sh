
#!/bin/bash

if [ ! -f env.sh ]; then
    @echo "Copy env.sh.dist into env.sh and edit away"
    exit 42
fi

source env.sh 

BQ_DATASET="covid"
BQ_TABLE="csv_imports"
LOCATION="europe-west6" # Zurich (BQ and GCe location - they need to be the same)
OUTDIR="out-hashes/"

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

}

# TODO(ricc): import ALL CSVs at once into a new BQ dataset which gets deleted and repopulated every day with ONE day more.
# maybe do a TABLE per month?
hash_data_by_csv_header
exit 42

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

