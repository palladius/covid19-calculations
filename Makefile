

install: COVID-19

show-latest-switzerland: refresh calculate-switzerland
	
refresh: install
	@echo Force refresh of repo
	cd COVID-19 ; git pull ; cd ..

calculate-switzerland: install
	./cases-by-nation.sh Switzerland
calculate-italy: install
	./cases-by-nation.sh Italy

# download latest repo
COVID-19:
	git clone https://github.com/CSSEGISandData/COVID-19

query-italy:
	cat query-italy.bq | bq query

gcpconfig: env.sh
env.sh:
	cp env.sh.dist env.sh
	@echo MAke sure to change data in env.sh or it wont work!

load-data-onto-bigquery:  # gcpconfig
	# make refresh # if u want..
	./load-csv-to-bq.sh

visualize-switzerland: install
	./cases-by-nation.sh Switzerland | ./termeter-covid-data.sh
	
