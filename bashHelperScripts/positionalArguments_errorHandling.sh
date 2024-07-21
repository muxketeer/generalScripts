#!/usr/bin/env bash


<<EOF
PositionArguments_errorHandling

meant to be sourced from external bash script.

requirements:
'bashHelperFunctions/loggingLibrary.sh' needs to have already been sourced by calling chain


EOF




PositionalArguments_errorHandling() {
# handy logging and error handling functions for non-positionalArguments
# now depends on logging library in bashHelperFunctions.
log() { einfo '%s\n' "$*"; }
error() { eerror "ERROR: $*" >&2; }
fatal() { ecrit "$*"; }
usage_fatal() { fatal "$*"; usage >&2; exit 1; }

}