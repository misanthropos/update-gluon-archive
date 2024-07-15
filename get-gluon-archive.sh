#!/bin/bash

if [[ -z $1 ]]; then
    GLUONARCHIVE=hellfire
    WORKDIR="$(pwd -P)"
    ARCHSITE="http://freifunk.madhacker.biz:6666/gluon"
else
    if [ $# != 3 ]; then
        echo "usage  : $(basename $0) distname destinationname url"
        echo "example: $(basename $0) hellfire /usr/local/archive http://hell.com/gluon"
        exit
    fi
    GLUONARCHIVE="${1}"
    WORKDIR="${2}"
    ARCHSITE="${3}"
fi

MAXRETRIES=3
SHAFILE=${GLUONARCHIVE}.sha256sum
cd "${WORKDIR}"

if  ! (diff -N -q <(wget -q -O -  "${ARCHSITE}/${SHAFILE}")  "${SHAFILE}") ; then
    wget -q "${ARCHSITE}/${SHAFILE}" -O ${SHAFILE} && cat ${SHAFILE}
else
    #echo "No new Archive! Testing local archive."
    if (sha256sum --status -c ${SHAFILE}); then
        exit
    fi
fi
    
ARCHFILE=$(cut -d " " -f 3 ${SHAFILE})
wget -q -c "${ARCHSITE}/${ARCHFILE}"

## checksum archive and retrie if check fails
idx=0
until sha256sum --status -c ${SHAFILE} ; do
    wget -q -c "${ARCHSITE}/${ARCHFILE}"
    ((idx++))
    if [ $idx == ${MAXRETRIES} ]; then
        echo "Failed to download archive ${ARCHFILE}" >&2
        exit 1
    fi
done



     
