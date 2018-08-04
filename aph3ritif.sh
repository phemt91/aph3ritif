#sistemare curl in background
#aggiungere barra caricamente scan
#aggiungere funzione fuzzing
#aggiungere searchsploit


#!/bin/bash

TARGET=$1
RED="\e[0;31m"
LGREEN="\e[1;32m"
Z="\e[0m" #escape colori


# funzione Scan del target
# usare variabile locale per assegnazione piu' snella

function NMAP1 {
local DATE=`date '+%Y-%m-%d %H:%M:%S'`

	echo -e  " -% ${DATE} %- \n" >> "${FILELOCATION}${TARGET}".txt
	nmap -sS -sV ${TARGET} >> "${FILELOCATION}${TARGET}".txt
	echo -e "\n Scan conclusa \n ------------------ \n" >> "${FILELOCATION}${TARGET}".txt
#	cat "${FILELOCATION}${TARGET}".txt
	chmod 777 "${FILELOCATION}${TARGET}".txt
}


#funzione di ping per ora disabilitata, problemi su host reali
function PING {


	ping ${TARGET} -c 1 > /dev/null
	if [ $? -ne "0" ]
	then
		echo "L'host selezionato non e' raggiungibile"
		exit 1

	fi

}

#funzione show PORT
function SHOWPORT {
	local CHECK="${FILELOCATION}${TARGET}".txt
	local FS_NUM
	grep open ${CHECK} | while read PORT STATE SERVICE VERSION
	do
		echo "-----------------------------"
		echo "${FS_NUM} : porta    --> ${PORT}"
		echo "${FS_NUM} : stato    --> ${STATE}"
		echo "${FS_NUM} : servizio --> ${SERVICE}"
		echo "${FS_NUM} : versione --> ${VERSION}"
		echo "-----------------------------"
			if [ ${SERVICE}="*http" ]
			then
				HTTPCHECK="SI"
			elif [ ${SERVICE}="*ssl*" ]
			then
				HTTPSCHECK="SI"
			fi
	done
}

#funzione homepage



function HOMEPAGE {

		if [ $HTTPCHECK="SI" ]
		then
			curl -IL http://${TARGET} >> "${FILELOCATION}${TARGET}".txt
			wget https://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
		elif [[ $HTTPSCHECK="SI" ]]
	 		then
				curl -IL https://${TARGET} >> "${FILELOCATION}${TARGET}".txt
				wget http://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
				echo ${HOMEPAGE} >> "${FILELOCATION}${TARGET}.render".html
		else
				echo -e "\n NO HTTP SERVICE FOUND \n"
		fi
}


#funzione hompage 2.0
function HOMEPAGE {

		if [ $HTTPCHECK="SI" ]
		then
			curl -IL https://${TARGET} >> "${FILELOCATION}${TARGET}".txt
			wget http://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
			echo ${HOMEPAGE} >> "${FILELOCATION}${TARGET}.render".html
				elif [ $? != 0 ]
				then
					curl -IL http://${TARGET} >> "${FILELOCATION}${TARGET}".txt
					wget https://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
		else
				echo -e "\n NO HTTP SERVICE FOUND \n"
		fi
}




#funzione searchinginthehomepage
function CRAWLINGHOME {
	local CHECK="${FILELOCATION}${TARGET}.render".html
	local FS_NUM
	grep 'apache\|wp\|wordpress' ${CHECK} | while read LINE
		do
		echo "-----------------------------"
		echo -e "${FS_NUM} : $RED Trovato indizio $Z   --> $LGREEN ${LINE} $Z"
		echo "-----------------------------"
		done
}





#funzione di inserimento location file.txt
function STORETXT {
	read -p "Dove salvare il file? (indicare Directory) " FILELOCATION
	FILELOCATION=${FILELOCATION}/
	if [ -d $FILELOCATION ]
	then
		echo "Il file verra' salvato nella cartella ${FILELOCATION} "
	else
		$FILELOCATION=""
		echo "Impossibile determinare cartella di destinazione"
		exit 1
	fi
}



#funzione che controlla l'esistenza del file
function CHECKFILE {
local CHECK="${FILELOCATION}${TARGET}".txt
	echo " ${CHECK} "
	if [ -f  ${CHECK}  ]
	then
		read -p "Il file esiste sovrascrivere?" FILECHECK
		case "$FILECHECK" in
			[sS]|[yY])
				rm "${FILELOCATION}${TARGET}".txt
				echo "Sovrascrittura in corso"
			;;
			*)
				echo -e  "\n\n Scan conclusa \n\n"
				exit 2
			;;
		esac
	fi
}

############################################################################
##  RICHIAMO ESECUZIONE ##

#Testa l'host target non funzionante
#PING

#Indica dove salvare il file
STORETXT

#Controlla se nella posizione scelta esista gia' un file per quel determinato target
CHECKFILE

#Esegue una scansione nmap -sS -sV e salva il file
NMAP1

#Mostra le porte aperte
SHOWPORT

#HomePage in caso di HTTPYES
HOMEPAGE

#Ispeziona la home in cerca di indizi su cms/server
CRAWLINGHOME
