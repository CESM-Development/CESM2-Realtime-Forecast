#!/bin/csh
#
set disk = /glade/derecho/scratch/sglanvil/SMYLE-DP/archive/
set disk = /glade/derecho/scratch/nanr/SMYLE-DP-climoIC/archive/
set arcd = /glade/campaign/cesm/development/espwg/CESM2-DP/restarts/
set startyear = 2005
set restyear = 2005
@ restyear  = $startyear + 11
#set syr = 1975
#@ syr = $startyear + 6
##@ syr = $startyear + 8
echo $startyear
echo $restyear

foreach mbr (001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 030)
    set case = "b.e21.BSMYLE_climoOcnAtmIC.f09_g17.2005-11.${mbr}"
    echo ${disk}/${case}/rest 
    cd ${disk}/${case}/rest
    #if ! ( -d ${arcd}/${case} ) then
	    #mkdir -p ${arcd}/${case}
	    #endif
    echo "=1======="
      	if ! ( -f ${arcd}/${case}.rest.${restyear}.tar ) then
       		tar -cf ${arcd}/${case}.rest.${restyear}.tar ${restyear}-01-*
      	else
         		echo ${arcd}"/"${case}".rest."${restyear}".tar exists."
      	endif
end
exit



