#!/bin/bash

useyear=2005
restyear=2005
usemonth=11

curdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle-DP/'
srcdir='/glade/work/nanr/cesm_tags/CASE_tools/cesm2-smyle/'
compset='BSMYLE'
usecompset='BSMYLE_climoOcnAtmIC'
resoln='f09_g17'
tagdir='/glade/work/nanr/cesm_tags/cesm2.1.4-SMYLE/'
caseroot='/glade/campaign/cesm/development/espwg/SMYLE-CASES/CESM2-SMYLE-DP/cases/'

main_case_root='b.e21.'$usecompset'.'$resoln'.'${useyear}'-'${usemonth}'.001'

for mbr in $(seq -f "%03g" 11 30)
do

echo "setting up member ${mbr}"

runname=b.e21.$usecompset.$resoln.$useyear-$usemonth.$mbr
casedir=$caseroot/$runname
rundir=/glade/derecho/scratch/nanr/SMYLE-DP-climoIC/${main_case_root}/run.${mbr}/

echo $rundir

cd $tagdir/cime/scripts

./create_newcase --case $casedir --res $resoln --compset $compset --run-unsupported
#./create_newcase --case $casedir --res $resoln --compset $compset 

cd $casedir

# ./xmlchange --append --file env_build.xml --id CAM_CONFIG_OPTS --val="-co2_cycle"
./xmlchange --append --file env_build.xml --id CAM_CONFIG_OPTS --val="-cosp "

./xmlchange JOB_WALLCLOCK_TIME=12:00:00 --subgroup case.run
./xmlchange RUN_TYPE=hybrid
./xmlchange GET_REFCASE=FALSE
./xmlchange RUN_REFCASE=b.e21.SMYLE_climoIC.f09_g17.${useyear}-${usemonth}.01
./xmlchange RUN_REFDATE=${useyear}-${usemonth}-01
./xmlchange RUN_STARTDATE=${useyear}-${usemonth}-01
./xmlchange DOUT_S_ROOT=/glade/derecho/scratch/nanr/SMYLE-DP-climoIC/archive/$runname/
./xmlchange CIME_OUTPUT_ROOT=/glade/derecho/scratch/nanr/SMYLE-DP-climoIC
./xmlchange RUNDIR=$rundir
./xmlchange OCN_TRACER_MODULES="iage cfc ecosys"
./xmlchange OCN_CHL_TYPE="diagnostic"
./xmlchange CCSM_BGC="CO2A"
./xmlchange JOB_PRIORITY=economy
 
./xmlchange PROJECT=CESM0020
./xmlchange STOP_N=24
./xmlchange REST_N=24
./xmlchange STOP_OPTION=nmonths
./xmlchange RESUBMIT=3

#./xmlchange NTASKS=-3
./xmlchange NTASKS_WAV=1

./case.setup
./preview_namelists

./xmlchange EXEROOT='/glade/derecho/scratch/nanr/SMYLE-DP/exerootdir/bld'
./xmlchange BUILD_COMPLETE=TRUE

# 
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.cam/* ./SourceMods/src.cam/
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.clm/* ./SourceMods/src.clm/
cp $srcdir/user_mods/cesm2smyle.base/SourceMods/src.pop/* ./SourceMods/src.pop/
cp $srcdir/user_mods/cesm2smyle.base/climoIC/user_nl_* .

mkdir -p $rundir

echo "made it this far"

  # Lastly - copy Initial conditions
    echo "Here is the RUNDIR ${rundir}"
    camic="b.e21.SMYLE_climoIC.f09_g17.${useyear}-${usemonth}.01.cam.i.${useyear}-${usemonth}-01-00000.nc"
    pertcamic="b.e21.SMYLE_climoIC.pert.f09_g17.cam.i.${useyear}-${usemonth}-01-00000.nc"
    ics="/glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/b.e21.SMYLE_climoIC.f09_g17.${useyear}-${usemonth}.01/"

    ls ${rundir}

    # pre-stage climoICs for climoIC for Ocn
    cp ${ics}/${useyear}-${usemonth}-01/rpointer.* ${rundir}/
    ln -s ${ics}/${useyear}-${usemonth}-01/b.e21.SMYLE_climoIC.f09_g17.2005-11.01.cam.i.2005-11-01-00000.nc ${rundir}/
    ln -s ${ics}/${useyear}-${usemonth}-01/b.e21.SMYLE_climoIC.f09_g17.2005-11.01.pop* ${rundir}/
    ln -s ${ics}/${useyear}-${usemonth}-01/b.e21.SMYLE_climoIC.f09_g17.2005-11.01.mosart* ${rundir}/
    ln -s ${ics}/${useyear}-${usemonth}-01/b.e21.SMYLE_climoIC.f09_g17.2005-11.01.cpl* ${rundir}/

    # pre-stage specific year ICs for Land/Ice
    fyear=1990
    stripped_number=$(echo "$mbr" | sed 's/^0*//')
    specyear=$((fyear + $stripped_number))
    if($specyear < 2020) then
         specics=/glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/b.e21.SMYLE_IC.f09_g17.${specyear}-${usemonth}.01/
         lnd_in=b.e21.SMYLE_IC.f09_g17.${specyear}-11.01.clm2.r.${specyear}-11-01-00000.nc
         ice_in=b.e21.SMYLE_IC.f09_g17.${specyear}-11.01.cice.r.${specyear}-11-01-00000.nc
    else
         specics=/glade/campaign/cesm/development/espwg/SMYLE/inputdata/cesm2_init/b.e21.SMYLE_IC.XT.f09_g17.${specyear}-${usemonth}.01/
         lnd_in=b.e21.SMYLE_IC.XT.f09_g17.${specyear}-11.01.clm2.r.${specyear}-11-01-00000.nc
         ice_in=b.e21.SMYLE_IC.XT.f09_g17.${specyear}-11.01.cice.r.${specyear}-11-01-00000.nc
    endif
    echo $specyear
    echo $specics

    lnd_out=b.e21.SMYLE_climoIC.f09_g17.${useyear}-11.01.clm2.r.${useyear}-11-01-00000.nc
    ln -s ${specics}/${specyear}-${usemonth}-01/$lnd_in ${rundir}/$lnd_out
    ice_out=b.e21.SMYLE_climoIC.f09_g17.${useyear}-11.01.cice.r.${useyear}-11-01-00000.nc
    ln -s ${specics}/${specyear}-${usemonth}-01/$ice_in ${rundir}/$ice_out


    # perturb the atmosphere IC
    # if [[ ${mbr} -ne "001" ]]
    if [[ ${mbr} != "001" ]]
    then
       shortmbr=${mbr:1:3}
       echo $shortmbr
       rm ${rundir}/${camic}
       echo ${ics}/pert.${shortmbr}/${pertcamic} ${rundir}/${camic}
       ln -s ${ics}/pert.${shortmbr}/${pertcamic} ${rundir}/${camic}
    fi

    cd $casedir

    ./case.submit

done
