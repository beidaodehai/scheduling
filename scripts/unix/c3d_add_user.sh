#!/bin/sh

echo
echo --- C3D ---------------------------------------------

workingDir=`dirname $0`
. $workingDir/env.sh

export XMLDESCRIPTOR=$workingDir/../../descriptors/C3D_User.xml
$JAVACMD -Dsun.rmi.server.exceptionTrace=true org.objectweb.proactive.examples.c3d.C3DUser $XMLDESCRIPTOR



echo
echo ---------------------------------------------------------
