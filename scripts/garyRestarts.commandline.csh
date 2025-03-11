#!/bin/csh
#
set disk = /glade/derecho/scratch/sglanvil/SMYLE-MDP/archive/
set disk = /glade/derecho/scratch/nanr/SMYLE-MDP/archive/
set arcd = /glade/campaign/cesm/development/espwg/CESM2-MDP/restarts/
set startyear = 2015
set startyear = 2010
set startyear = 2005
set startyear = 2000
set startyear = 1995
set startyear = 1990
set startyear = 1985
set startyear = 1980
set startyear = 1975
set startyear = 1970
set startyear = 1965
set startyear = 1960
set startyear = 2023
#set syr = 1975
@ syr = $startyear + 6
#@ syr = $startyear + 8
echo $syr
echo $startyear

# Create an empty array
set restyrs = ()
set restmon = ( 11 11 11 01 )

# Generate the array elements
set i = 0
while ($i < 4)
    # Add the current number to the array
    set restyrs = ($restyrs $syr)
    echo "restyrs = " $restyrs

    # Increment the number for the next iteration
    if ($i == 2) then
      	@ syr += 3
    else
   	@ syr += 6
    endif

    # Increment the loop counter
    @ i++
end

echo $restyrs

#foreach mbr (001 002 003 004 005 006 007 008 009 010)
foreach mbr (001 001 )
	#set case = "b.e21.BSMYLE.f09_g17.MDP.${startyear}-11.${mbr}"
    set case = "b.e21.BSMYLE-XT-beta.f09_g17.MDP.${startyear}-11.${mbr}"
    echo ${disk}/${case}/rest 
    cd ${disk}/${case}/rest
    if ! ( -d ${arcd}/${case} ) then
   	mkdir -p ${arcd}/${case}
    endif
    set i=1
    foreach rr ($restyrs)
	echo $rr 
	echo 'rest month = '$restmon[$i]
	echo 'i  = '$i
	# Your commands using $mbr variable
  	echo "=1======="
      	if ! ( -f ${arcd}/${case}/${case}.rest.${rr}.tar ) then
       		echo "Processing restarts: "${rr}
  		echo "=3======="
       		tar -cf ${arcd}/${case}/${case}.rest.${rr}.tar ${rr}-$restmon[$i]-*
  		echo "=4======="
       		echo 'here tar -cf '${arcd}'/'${case}'/'${case}'.rest.'${rr}'.tar' ${rr}'-'$restmon[$i]'-*'
       		if ($status == 0) then
       				echo 'tar -cf ${arcd}/${case}/${case}.rest.${rr}.tar ${rr}-$restmon[$i]-*'
       		else
       				echo 'tar -cf failed on ${case} ${rr}-$restmon[$i]-*'
       		endif
      	else
         		echo ${arcd}"/"${case}"/"${case}".rest."${rr}".tar exists."
      	endif
  	     echo "=2======="`pwd`
		#echo "ls $path/b.e21.BSMYLE.f09_g17.MDP.${startyear}-11.${mbr}/rest/${rr}-*"
		#echo "tar -cf ${arcd}/${case}/${case}.rest.${rr}.tar ${rr}-$restmon[$i]-*"
	@ i++
        end
end
exit


#
  echo ${disk}/${case}/rest 
  if ( -d ${disk}/${case}/rest ) then
    set i = 1
    foreach rest ($restyrs)
        echo "HERE I AM"
        echo $rest-$restmon[$i]
        echo "tar -cf ${arcd}/${case}/${case}.rest.${rest}.tar ${rest}-$restmon[$i]-*"
      if ! ( -f ${arcd}/${case}/${case}.rest.${rest}.tar ) then
        echo "Processing restarts: "${rest}
        tar -cf ${arcd}/${case}/${case}.rest.${rest}.tar ${rest}-$restmon[$i]-*
        if ($status == 0) then
          echo 'tar -cf '${arcd}'/'${case}'/'${case}'.rest.'${rest}'.tar '${rest}
        else
           echo 'tar -cf failed on '${case}' '${rest}
        endif
      else
         echo ${arcd}"/"${case}"/"${case}".rest."${rest}".tar exists."
      endif
      @ i++
    end
  endif
end
#
exit

