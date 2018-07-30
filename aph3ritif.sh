#!/bin/bash

TARGET=$1


# funzione Scan del target
function NMAP1 {
	nmap -sS -sV ${TARGET} >> /${TARGET}.txt
	cat /${TARGET}.txt
}

NMAP1
