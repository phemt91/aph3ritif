#mettere inbackgruond il ping
#ping messo in commento da rivedere o cancellare
#aggiungere barra caricamente scan
#aggiungere funzione fuzzing

#aggiungere estrapolazione dati da .txt

#!/bin/bash

TARGET=$1


# funzione Scan del target
# usare variabile locale per assegnazione piu' snella

function NMAP1 {
local DATE=`date '+%Y-%m-%d %H:%M:%S'`

	echo -e  " -% ${DATE} %- \n" >> "${FILELOCATION}${TARGET}".txt
	nmap -sS -sV ${TARGET} >> "${FILELOCATION}${TARGET}".txt
	echo -e "\n Scan conclusa \n ------------ \n" >> "${FILELOCATION}${TARGET}".txt
	cat "${FILELOCATION}${TARGET}".txt
	chmod 777 "${FILELOCATION}${TARGET}".txt
}

function PING {


	ping ${TARGET} -c 2 -i 3 
	if [ $? -ne "0" ]
	then
		echo "L'host selezionato non e' raggiungibile"
		exit 1

	fi

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

#Testa l'host target
#PING

#Indica dove salvare il file
STORETXT

#Controlla se nella posizione scelta esista gia' un file per quel determinato target
CHECKFILE

#Esegue una scansione nmap -sS -sV e salva il file
NMAP1

