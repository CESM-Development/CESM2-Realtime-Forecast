#!/bin/bash

sourceDir='/glade/p/cesm/espwg/CESM2-SMYLE-EXTEND/cases/'
iyear=1993

#for iyear in {1970..1971}; do
	for imember in {011..020}; do
		case=b.e21.BSMYLE.f09_g17.${iyear}-11.${imember}
		echo ${case}
		cd ${sourceDir}${case}
		./xmlchange STOP_N=2
		./xmlchange REST_N=2
		./xmlchange CONTINUE_RUN=TRUE
	done
#done

