#sistemare curl in background
#aggiungere funzione fuzzing
#aggiungere searchsploit


#!/bin/bash

TARGET=$1

#Colori
	RED="\e[0;31m"
	LGREEN="\e[1;32m"
	Z="\e[0m" #escape colori

#check programmi necessari al funzionamento
function CHECKTOOL {
	function CHECKNMAP {
		local RISP

		dpkg-query -l nmap > /dev/null
		case $? in
		   0)
			 echo -e "-------------------------\n"
			 echo -e "nmap installato\n"
			 echo -e "-------------------------\n"
			 ;;
		   1)
			 read -p "Installare pacchetto mancante?" RISP
			  	case "$RISP" in
						[sS]|[yY])
						sudo apt-get install nmap
						;;
						*)
						echo -e  "\n\n Programma obbligatorio \n\n"
						exit 2
						;;
					esac
			 ;;
		esac
	}
	function CHECKCURL {
		local RISP

		dpkg-query -l curl > /dev/null
		case $? in
		   0)
			 echo -e "-------------------------\n"
			 echo -e "curl installato\n"
			 echo -e "-------------------------\n"
			 ;;
		   1)
			 read -p "Installare pacchetto mancante?" RISP
			  	case "$RISP" in
						[sS]|[yY])
						sudo apt-get install curl
						;;
						*)
						echo -e  "\n\n Programma obbligatorio \n\n"
						exit 2
						;;
					esac
			 ;;
		esac
	}
	function CHECKSEARCHEXP {
		local RISP
#La funzione search deve migliorare fixare
		dpkg-query -l searchsploit > /dev/null
		case $? in
			 0)
			 echo -e "-------------------------\n"
			 echo -e "searchsploit installato\n"
			 echo -e "-------------------------\n"
			 ;;
			 1)
			 read -p "Installare pacchetto mancante?" RISP
					case "$RISP" in
						[sS]|[yY])
						sudo apt-get install searchsploit
						;;
						*)
						echo -e  "\n\n Programma obbligatorio \n\n"
						exit 2
						;;
					esac
			 ;;
		esac
	}
	CHECKNMAP
	CHECKCURL
#	CHECKSEARCHEXP
}
#funzione Scan del target 
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
			SEARCHEXP=${VERSION}
			SEARCHSPLOIT
			echo -e "############################################\n"
			echo -e "\n"

	done
}
function SEARCHSPLOIT {
	searchsploit ${SEARCHEXP}

	}
#Funzione di download pagina target
function HOMEPAGE {

		if [ $HTTPCHECK="SI" ]
		then
			curl -IL http://${TARGET} >> "${FILELOCATION}${TARGET}".txt
			wget http://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
		elif [[ $HTTPSCHECK="SI" ]]
	 		then
				curl -IL https://${TARGET} >> "${FILELOCATION}${TARGET}".txt
				wget https://${TARGET} -O "${FILELOCATION}${TARGET}.render".html
				echo ${HOMEPAGE} >> "${FILELOCATION}${TARGET}.render".html
		else
				echo -e "\n NO HTTP SERVICE FOUND \n"
		fi
}
#funzione ricerca indizi su pagina target
function CRAWLINGHOME {
	local CHECK="${FILELOCATION}${TARGET}.render".html
	local FS_NUM
	grep 'apache\|wp\|wordpress\|joomla' ${CHECK} | while read LINE
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
#funzione che controlla esistenza del file
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
#funzione esecuzione programma
function ESECUZIONE {
	CHECKTOOL
	STORETXT
	CHECKFILE
	NMAP1
	SHOWPORT
	HOMEPAGE
	CRAWLINGHOME

}

############################################################################
##  RICHIAMO ESECUZIONE ##
ESECUZIONE
