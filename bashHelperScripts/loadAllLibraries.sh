#!/usr/bin/env bash


# loads all the needed libraries, from the current directory.

#the lib with all the logging levels functions (edebug, ewarn, einfo, enotify, eerror, ecrit, etc. )
source $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/loggingLibrary.sh
#the lib with the postional arguments error handling (requires the above logging library).
source $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/positionalArguments_errorHandling.sh
#functions for passing vars internal to the scripts between function calls
source $( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/parseArgs.sh

