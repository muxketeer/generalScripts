#!/bin/bash -l
<<EOF
inspired from https://technotes.adelerhof.eu/bash/logging/

intended to be a sourced script called with 'source'. 

REQUIREMENT:  MUST set variable 'MY_LOGGER_VERBOSITY=6,' or some value, via caller to this script. I.e. not set in this script


EOF


#MY_LOGGER_VERBOSITY=6
#MUST NOT BE SET ^^^ IN THIS FILE BECAUSE IT WILL OVERWRITE IF BEING CALLED FROM MULTIPLE CHAINS OF BASH FILES.

# export LOGDIR=/path/to/logfiles
# export DATE=`date +"%Y%m%d"`
# export DATETIME=`date +"%Y%m%d_%H%M%S"`
# NO_JOB_LOGGING="false"

ScriptName=`basename $0`
# Job=`basename $0 .sh`"_whatever_I_want" # Add _whatever_I_want after basename
Job=`basename $0 .sh`
JobClass=`basename $0 .sh`

colblk='\033[0;30m' # Black - Regular
colred='\033[0;31m' # Red
colgrn='\033[0;32m' # Green
colylw='\033[0;33m' # Yellow
colpur='\033[0;35m' # Purple
colwht='\033[0;97m' # White
colrst='\033[0m'    # Text Reset



### verbosity levels
silent_lvl=0
crt_lvl=1
err_lvl=2
wrn_lvl=3
ntf_lvl=4
inf_lvl=5
dbg_lvl=6

## esilent prints output even in silent mode
function esilent () { verb_lvl=$silent_lvl elog "$@" ;}
function ecrit ()  { verb_lvl=$crt_lvl elog "${colpur}FATAL${colrst} --- $@" ;}
function eerror () { verb_lvl=$err_lvl elog "${colred}ERROR${colrst} --- $@" ;}
function ewarn ()  { verb_lvl=$wrn_lvl elog "${colylw}WARNING${colrst} - $@" ;}
function eok ()    { verb_lvl=$ntf_lvl elog "SUCCESS - $@" ;}
function enotify () { verb_lvl=$ntf_lvl elog "${colwht}NOTIFY${colrst} -- $@" ;}
function einfo ()  { verb_lvl=$inf_lvl elog "${colwht}INFO${colrst} ---- $@" ;}
function edebug () { verb_lvl=$dbg_lvl elog "${colgrn}DEBUG${colrst} --- $@" ;}
function edumpvar () { for var in $@ ; do edebug "$var=${!var}" ; done }
function elog() {
        if [ $MY_LOGGER_VERBOSITY -ge $verb_lvl ]; then
                datestring=`date +"%Y-%m-%d %H:%M:%S"`
                #why have to use [2] for BASH_SOURCE, and [1] for BASH_LINENO in order to have the correct line number is not known. 
                #this is put here so that the calling filename, just the filename...not the full path... and the line number you're calling from is placed in the log message.
                #including name of the function, in the callstack, that this log message was called from
                echo -e "$datestring ${FUNCNAME[2]}() $(basename ${BASH_SOURCE[2]}):${BASH_LINENO[1]} - $@" >&2
        fi
}

function Log_Open() {
        if [ $NO_JOB_LOGGING ] ; then
                einfo "Not logging to a logfile because -Z option specified." #(*)
        else
                [[ -d $LOGDIR/$JobClass ]] || mkdir -p $LOGDIR/$JobClass
                Pipe=${LOGDIR}/$JobClass/${Job}_${DATETIME}.pipe
                mkfifo -m 700 $Pipe
                LOGFILE=${LOGDIR}/$JobClass/${Job}_${DATETIME}.log
                exec 3>&1
                tee ${LOGFILE} <$Pipe >&3 &
                teepid=$!
                exec 1>$Pipe
                PIPE_OPENED=1
                enotify Logging to $LOGFILE  # (*)
                [ $SUDO_USER ] && enotify "Sudo user: $SUDO_USER" #(*)
        fi
}

function Log_Close() {
        if [ ${PIPE_OPENED} ] ; then
                exec 1<&3
                sleep 0.2
                ps --pid $teepid >/dev/null
                if [ $? -eq 0 ] ; then
                        # a wait $teepid whould be better but some
                        # commands leave file descriptors open
                        sleep 1
                        kill  $teepid
                fi
                rm $Pipe
                unset PIPE_OPENED
        fi
}

# Check if the script is being executed directly
if [ "$0" = "$BASH_SOURCE" ]; then
    # This code will only run when the script is executed directly, not when sourced.
    echo "This script is being executed directly."

    MY_LOGGER_VERBOSITY=6
    echo "imagine some code written here"
    edebug "this is a debug message from your code"
    einfo "this is a info message from your code"
    

else
    # This code will run when the script is sourced.
    edebug "This script is being sourced by another script."
fi






