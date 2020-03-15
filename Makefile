

install: COVID-19

refresh: install
	@echo Force refresh of repo
	cd COVID-19 ; git pull

calculate-switzerland: install
	./calculate.sh Switzerland
calculate-italy: install
	./calculate.sh Italy

# download latest repo
COVID-19:
	git clone https://github.com/CSSEGISandData/COVID-19