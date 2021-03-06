#!/bin/bash

###
# This script does 2 things:
#
# 1. Starts up the X session in a virtual framebuffer.
# 2. Launches the IDV, using the VFB as the display.
#
# This is necessary to do here; if we put the xinit command
# in the Dockerfile, it would not run if we invoke this script
# from the 'docker run' command.  If we put the IDV in .xinitrc,
# then it would cause problems for those downstream images that
# don't want to automatically run the IDV.
#
# Therefore, we must run a command that starts xinit and then
# runs the IDV.  Other images will need to do something similar.
#
# This has the added benefit of killing the image when the IDV exits.
###

xinit -- /usr/bin/Xvfb :1 -screen 0 $SIZEH\x$SIZEW\x$CDEPTH &
sleep 5
export DISPLAY=localhost:1
#bash -c 'sleep 25; wmctrl -r Dashboard -b add,fullscreen; wmctrl -r "Unidata IDV - Map View - One Pane" -b add,fullscreen' &
#sleep 3

if [ "x${USENOVNC}" == "xTRUE" ]; then
    mv /home/idv/self.pem /home/idv/noVNC/utils/
    /home/idv/noVNC/utils/launch.sh --vnc 127.0.0.1:5901 &
fi

/home/idv/IDV/runIDV
