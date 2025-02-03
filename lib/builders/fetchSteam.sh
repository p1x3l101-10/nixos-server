#!/bin/bash
# shellcheck source=/dev/null
if [ -e .attrs.sh ]; then source .attrs.sh; fi
source "${stdenv:?}/setup"

# Hack to prevent DepotDownloader from crashing trying to write to
# ~/.local/share/
export HOME
HOME=$(mktemp -d)

args=(-app "${appId:?}")

if [[ -n "${workshopId}" ]] && [[ -z "${depotId}" ]] && [[ -z "${manifestId}" ]]; then
    # Set args for workshop
    args+=(-pubfile "${workshopId:?}")
elif [[ -z "${workshopId}" ]] && [[ -n "${depotId}" ]] && [[ -n "${manifestId}" ]]; then
    # Set args for application
    args+=(-depot "${depotId:?}")
    args+=(-manifest "${manifestId:?}")
else
    echo "You need to set only one of 'workshopId' OR 'depotId' AND 'manifestId'"
    exit 1
fi

if [ -n "$branch" ]; then
	args+=(-beta "$branch")
fi

if [ -n "$debug" ]; then
	args+=(-debug)
fi

if [ -n "$filelist" ]; then
	args+=(-filelist "$filelist")
fi

DepotDownloader \
	"${args[@]}" \
	-dir "${out:?}"
rm -rf "${out:?}/.DepotDownloader"