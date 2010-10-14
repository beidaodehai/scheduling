# OSProcessBuilder - main launcher script for linux - it is
# responsible for basic environment validation, and for
# starting the next level of the launching, which based on
# what settings were set, can be user_step or bind_step
#
# This script will need the following arguments to work
# 	$1 - path to scripts folder
#	$2 - path to the working dir of the user command (absolute)
# 	$3 - user name (can be empty, as "")
#	$4 - core binding (can be empty, as "")
#	$5... - command to execute (can be several arguments)

# IMPORTANT: On error messages refer to the JavaDoc of OSProcessBuilder

# defining here the 'tokens' used in the java process builder
OSPL_E_PREFIX="_OS_PROCESS_LAUNCH_ERROR_";
OSPL_E_CAUSE="CAUSE";
OSLP_PACKAGE="org.objectweb.proactive.extensions.processbuilder.exception."
#---------------

workdir=$2
if [ "$workdir" == "" ]; then
  # if the user didn't specify a working dir for the command, it is in the current directory
  workdir=`pwd`
fi;

# goto the scripts folder, because we have all the scripts here :)
cd $1;
if [ "$?" != "0" ]; then
  # if not being able to access the scripts folder
  echo "$OSPL_E_PREFIX ${OSLP_PACKAGE}FatalProcessBuilderException $OSPL_E_CAUSE Scripts folder can not be found at: $1!" 1>&2;
  exit 1;
fi;

# user name
usr=$3

# cores
crs=$4

# create temp file for return value passing
tmp=`mktemp`;

if [ "$?" != "0" ]; then
  # if I can not create a tempfile
  echo "$OSPL_E_PREFIX ${OSLP_PACKAGE}FatalProcessBuilderException $OSPL_E_CAUSE Could not create temp file for storing the return value!" 1>&2;
  exit 1;
fi;

# TODO: should access path also be authorized?
# TODO: grant only to the user we are going to change into?
# grant permission for r/w
chmod 666 $tmp

# first jump - core binding
# ATTENTION: not implemented ;) TODO
if [ "$crs" != "" ]; then
  error="$OSPL_E_PREFIX ${OSLP_PACKAGE}CoreBindingException $OSPL_E_CAUSE Core binding is not supported!"
  echo $error 1>&2
  rm $tmp;
  exit 1;
else
  # If the username is not empty we proceed with the user_step
  if [ "$usr" != "" ]; then
    # we get rid of the first 4 parameters
    shift;shift;shift;shift;
    ./user_step.sh $tmp "$workdir" "$usr" "$@"
    if [ "$?" != "0" ]; then
    # return value of the user_step is not 0 only in case the sudo failed, otherwise it is 0
    error="$OSPL_E_PREFIX ${OSLP_PACKAGE}FatalProcessBuilderException $OSPL_E_CAUSE User change script could not execute!"
    echo $error 1>&2
    rm $tmp;
    exit 1;
    fi;

  else
  # If the username is empty, we just execute the command...
  # It is worth mentioning that in case neither the username nor the cores are set, one should just use Runtime.exec, and not these scripts.
    ./command_step.sh $tmp "$workdir" "$@";
    if [ "$?" != "0" ]; then
    # return value of the user_step is not 0 only in case the sudo failed, otherwise it is 0
    error="$OSPL_E_PREFIX ${OSLP_PACKAGE}FatalProcessBuilderException $OSPL_E_CAUSE Command executor script could not execute!"
    echo $error 1>&2
    rm $tmp;
    exit 1;
    fi;
  fi;

  # now, if everything was ok, we should have a return value in the tmp file

  exitv=`cat < $tmp` 2> /dev/null
  # maybe check if it exists etc. - may come in handy if we don't break on the first error coming from the scripts
  rm $tmp; 2> /dev/null
  exit $exitv;
fi;