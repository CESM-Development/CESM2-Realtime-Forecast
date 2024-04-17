#!/bin/bash

tsDir=/glade/campaign/cesm/development/espwg/SMYLE-EXTEND/timeseries/
caseDir=/glade/p/cesm/espwg/CESM2-SMYLE-EXTEND/cases/

year=2013
members=(11 12 13 14 15 16 20)

for imem in ${members[@]}; do
	echo ${year} ${imem}
	cd ${caseDir}b.e21.BSMYLE.f09_g17.${year}-11.0${imem}
	mv postprocess postprocess_old
	cd ${tsDir}
	mv b.e21.BSMYLE.f09_g17.${year}-11.0${imem} old_b.e21.BSMYLE.f09_g17.${year}-11.0${imem}
done

