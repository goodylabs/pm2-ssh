#!/bin/bash

# PM2 SSH v0.1 2023-12-09

CAT=`which cat`
JQ=`which jq`
RM=`which rm`
SED=`which sed`
SSH=`which ssh`

if [ ${#CAT} -lt 2 ]; then echo >&2 "I require 'cat' but it's not installed."; exit 1; fi;
if [ ${#JQ} -lt 2 ]; then echo >&2 "I require 'jq' but it's not installed."; exit 1; fi;
if [ ${#SED} -lt 2 ]; then echo >&2 "I require 'sed' but it's not installed."; exit 1; fi;
if [ ${#SSH} -lt 2 ]; then echo >&2 "I require 'ssh' but it's not installed."; exit 1; fi;

function show_help {
  echo ""
  echo "Usage: "
  echo "$0 [environment] [server_number] [-r for root login]"
  echo ""
}

if [ "x$1" == "x--help" ] || [ "x$1" == "x-h" ]; then
  show_help
  exit 1
fi

PM2_CONFIG_FILE="ecosystem.config.js"
PM2_CONFIG_JSON_FILE="${PM2_CONFIG_FILE}.json"

${SED} -e s/"module.exports = {"/"{"/g ${PM2_CONFIG_FILE} | \
${SED} -e s/"^\};"/"}"/g | ${SED} '/\/\*/,/\*\//d' | \
${SED} -E 's/([[:alnum:]_]+):[\ ]{1}/"\1": /g' | \
${SED} -E s/"\'"/\"/g > ${PM2_CONFIG_JSON_FILE}

filename=$0

REMOTE_ENV="${filename##*-}"
REMOTE_ENV="${REMOTE_ENV%.*}"

SERVER_NUMBER="$1"

if [ "x${SERVER_NUMBER}" == "x" ]; then
  SERVER_NUMBER="1"
fi

ROOT_LOGIN="$2"

if [ "x${ROOT_LOGIN}" == "x-r" ]; then
  ROOT_LOGIN="1"
fi

SERVER_INDEX=$((${SERVER_NUMBER}-1))

echo "Remote ENV: ${REMOTE_ENV}"
echo "Server index: ${SERVER_INDEX}"

REMOTE_HOST=""
REMOTE_USER=""

REMOTE_HOST=`${JQ} -r ".deploy.${REMOTE_ENV}.host | if type == \"array\" then .[${SERVER_INDEX}] else . end" ${PM2_CONFIG_JSON_FILE}`
echo "Remote host: ${REMOTE_HOST}"
REMOTE_USER=`${JQ} -r ".deploy.${REMOTE_ENV}.user" ${PM2_CONFIG_JSON_FILE}`

if [ "${ROOT_LOGIN}" == "1" ]; then
  REMOTE_USER="root"
fi

echo "Remote user: ${REMOTE_USER}"

${RM} -f ${PM2_CONFIG_JSON_FILE}

if [ "x${REMOTE_HOST}" == "xnull" ] || [ "x${REMOTE_USER}" == "xnull" ]; then echo "Unknown user or host - aborting !!!"; exit 1; fi

${SSH} ${REMOTE_USER}@${REMOTE_HOST} -v