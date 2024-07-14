#!/bin/bash

if [[ -z $1 ]]; then
    GLUONARCHIVE=hellfire
    WORKDIR="$(dirname "${BASH_SOURCE[0]}")"
    ARCHFILE="${GLUONARCHIVE}-$(date +'%Y-%m-%d').tar"
else
    GLUONARCHIVE="${1}"
    WORKDIR="${2}"
    ARCHFILE="${3}-$(date +'%Y-%m-%d').tar"
fi

SHAFILE="${GLUONARCHIVE}".sha256sum
cd "${WORKDIR}"

tar cf "${ARCHFILE}" "${GLUONARCHIVE}"

if [ -f "${ARCHFILE}" ]; then
    sha256sum "${ARCHFILE}" > "${SHAFILE}"
else
    echo "Failure building ${ARCHFILE} from ${GLUONARCHIVE}!"
fi
