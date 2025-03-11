#!/bin/bash

useyear=2005
usemonth=11

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle-DP/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle-DP/'
compset='BSMYLE'
usecompset='BSMYLE_climoOcnAtmIC'
resoln='f09_g17'
tagdir='/glade/work/nanr/cesm_tags/cesm2.1.4-SMYLE/'
caseroot='/glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-DP/cases/'

main_case_root='b.e21.'$usecompset'.'$resoln'.'${useyear}'-'${usemonth}'.001'

for mbr in $(seq -f "%03g" 2 30)
do

echo "resubmitting member ${mbr}"

runname=b.e21.$usecompset.$resoln.$useyear-$usemonth.$mbr
casedir=$caseroot/$runname

cd $casedir

./case.submit

done
