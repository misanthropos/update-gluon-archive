#!/bin/bash

if [[ -z $1 ]]; then
    GLUONARCHIVE=hellfire
    WORKDIR="$(dirname "${BASH_SOURCE[0]}")"
else
    GLUONARCHIVE="${1}"
    WORKDIR="${2}"
fi

MAXRETRIES=3
ARCHSITE="http://freifunk.madhacker.biz:6666/gluon"
SHAFILE=${GLUONARCHIVE}.sha256sum
cd "${WORKDIR}"

if  ! (diff -N -q <(wget -q -O -  "${ARCHSITE}/${SHAFILE}")  "${SHAFILE}") ; then
    wget "${ARCHSITE}/${SHAFILE}" -O ${SHAFILE}
else
    echo "No new Archive! Testing local archive."
    if (sha256sum -c ${SHAFILE}); then
        exit
    fi
fi
    
ARCHFILE=$(cut -d " " -f 3 ${SHAFILE})
wget -c "${ARCHSITE}/${ARCHFILE}"

## checksum archive and retrie if check fails
idx=0
until sha256sum --status -c ${SHAFILE} ; do
    wget -c "${ARCHSITE}/${ARCHFILE}"
    ((idx++))
    if [ $idx == ${MAXRETRIES} ]; then
        echo "Failed to download archive ${ARCHFILE}" >&2
        exit 1
    fi
done



     
