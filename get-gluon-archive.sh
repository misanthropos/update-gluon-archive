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
wget "${ARCHSITE}/${SHAFILE}" -O ${SHAFILE}

ARCHFILE=$(cut -d " " -f 3 ${SHAFILE})

if [ ! -f "${ARCHFILE}" ]; then
    wget -c "${ARCHSITE}/${ARCHFILE}"
fi

## get and checksum archive
idx=0
until sha256sum --status -c ${SHAFILE} ; do
    wget -c "${ARCHSITE}/${ARCHFILE}"
    ((idx++))
    if [ $idx == ${MAXRETRIES} ]; then
        echo "Failed to download archive ${ARCHFILE}" >&2
        exit 1
    fi
done



     
