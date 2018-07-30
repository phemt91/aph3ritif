#!/bin/bash

TARGET=$1
FILELOCATION=/home/phemt/Documenti/

# funzione Scan del target

function NMAP1 {
local DATE=`date '+%Y-%m-%d %H:%M:%S'`

	echo -e  " -% ${DATE} %- \n" >> ${LOCATION}+${TARGET}.txt
	nmap -sS -sV ${TARGET} >> ${LOCATION}+${TARGET}.txt
	echo -e "\n Scan conclusa \n ------------ \n" >> ${LOCATION}+${TARGET}.txt
	cat ${LOCATION}+${TARGET}.txt
	chmod 777 ${LOCATION}+${TARGET}.txt
}

#funzione che controlla l'esistenza del file
function CHECKFILE {
local CHECK=/home/phemt/Documenti/${TARGET}.txt
	echo " ${CHECK} "
	if [ -f  ${CHECK}  ]
	then	
		read -p "Il file esiste sovrascrivere?" FILECHECK
		case "$FILECHECK" in
			y,Y)
				rm ${LOCATION}+${TARGET}
				exit 0
			;;
			*)
				echo -e  "\n\nScan conclusa\n\n"
				exit 2
			;;
		esac
	fi
}


CHECKFILE
NMAP1
