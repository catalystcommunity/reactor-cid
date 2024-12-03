#!/usr/bin/env bash

# This is the starting point of all includes for reactorcide.
#
# It should basically only contain functons and maybe run some checks to
# validate env switches (sed flags for mac versions or something) if 
# it does any actual logic. Otherwise, this is just a library
# of bash commands to aid in scripts for a simple CI/CD system.

# Everything should start with "reactorcide_" unless intended to be internal
# in which case "__reactorcide" should be used.

# The only global var, with an assumption defaulted since we probably run
# in a docker container with this mounted as such
REACTORCIDE_ROOT="${REACTORCIDE_ROOT:-/reactorcide}"

# We only have an example for the moment
source ${REACTORCIDE_ROOT}/src/example.sh

