#!/bin/sh

# Attempt to start PulseAudio if not running
pulseaudio --check
if [ $? -ne 0 ]; then
    pulseaudio -D --exit-idle-time=-1
fi

unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
exec dbus-run-session -- startxfce4 