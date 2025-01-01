#!/usr/bin/env bash

# This script is the full reactorcide entry point. It will source all the
# things, make use of several assumption sets on files existing, and be
# very focused on not handling everything, but instead hand env vars to
# user written scripts to do the bulk of the work, but with helper functions
# for common CI/CD functions in bash.

# If you are used to a Makefile, this is where you do the work instead
set -e

THISSCRIPT=$(basename $0)

SCRIPT_ROOT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

REACTORCIDE_JOB_VARS="${1}"

# Config defaults, this section assumes the env you're running in can have
# overrides, but will have defaults where possible. Non-default required items
# are at the top. They are not checked until after sourcing overrides from
# the ${REACTORCIDE_RUNNERENVFILE} var
# This should also be from the repo root, so path/to/script.ext and NOT start with /
REACTORCIDE_JOB_ENTRYPOINT="NOTSET"

# Defaulted vals below
REACTORCIDE_ROOT="${REACTORCIDE_ROOT:-/reactorcide}"
# note the lack of the trailing slash
REACTORCIDE_REPONAME="${REACTORCIDE_REPONAME:-jobrepo}"
REACTORCIDE_REPOROOT="SET_LATER"

# colors
TERMCOLOR_RED=$'\e[0;31m'
TERMCOLOR_GREEN=$'\e[0;32m'
TERMCOLOR_ORANGE=$'\e[0;33m'
TERMCOLOR_YELLOW=$'\e[1;33m'
TERMCOLOR_BLUE=$'\e[1;33m'
TERMCOLOR_CYAN=$'\e[0;36m'
TERMCOLOR_NONE=$'\e[0m'

# script internal vars
MISSING_DEPS="false"

log_status() {
  echo "${TERMCOLOR_GREEN}---------------------------------  ${1}  ---------------------------------${TERMCOLOR_NONE}"
}

# Modify for the help message
usage() {
    log_status "Usage"
    echo "${THISSCRIPT} command"
    echo ""
    echo "Commands:"
    echo ""
    echo "  run        (default) run the job with base assumptions"
    echo ""
    exit 0
}

internal_run(){
    set -a
    source ${REACTORCIDE_JOB_VARS}
    set +a
    # The repo name is configurable, workspace is not, so we can use it for more than the repo, like scratch space
    REACTORCIDE_REPOROOT="/workspace/${REACTORCIDE_REPONAME}"

    if [ "${REACTORCIDE_JOB_ENTRYPOINT}" == "NOTSET" ]; then
        echo "No REACTORCIDE_JOB_ENTRYPOINT set, exiting."
        exit 1
    fi

    if [ ! -f "${REACTORCIDE_JOB_ENTRYPOINT}" ]; then
        echo "${REACTORCIDE_JOB_ENTRYPOINT} is unavailable"
        exit 1
    fi

    # Everything in theory is working, so now just run the job

    ${REACTORCIDE_REPOROOT}/${REACTORCIDE_JOB_ENTRYPOINT}
}

# This should be last in the script, all other functions are named beforehand.
case "$1" in
    "usage" | "-h" | "--help")
        shift
        usage "$@"
        ;;
    *)
        internal_run
        ;;
esac

exit 0
