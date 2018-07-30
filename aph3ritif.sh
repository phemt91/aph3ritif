#!/bin/bash

TARGET=$1

# funzione Scan del target
function NMAP1 {
	touch /${TARGET}.txt
	nmap -sS -sV ${TARGET} > /${TARGET}.txt
}



NMAP1
