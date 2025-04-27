FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    USERNAME=testuser \
    PASSWORD=Passw0rd!

# -------------------------------------------------
# Base desktop stack + a few demo X11 apps + Audio
# -------------------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        xrdp xorgxrdp                       \
        xfce4 xfce4-goodies dbus-x11        \
        xterm x11-apps                      \
        pulseaudio \
        alsa-utils sound-theme-freedesktop   \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure XRDP for PulseAudio
# RUN xrdp-pulseaudio-installer -- This package/script might not be needed or available

# -------------------------------------------------
# Create test user
# -------------------------------------------------
RUN adduser --disabled-password --gecos "" "${USERNAME}" && \
    echo "${USERNAME}:${PASSWORD}" | chpasswd && \
    # Add user to audio groups for PulseAudio access
    usermod -aG audio,pulse-access "${USERNAME}"

# Ensure XRDP PulseAudio modules are configured to load
RUN echo "load-module module-native-protocol-unix" >> /etc/pulse/default.pa \
    && echo "load-module module-xrdp-sink" >> /etc/pulse/default.pa \
    && echo "load-module module-xrdp-source" >> /etc/pulse/default.pa

# -------------------------------------------------
# Start XFCE in every RDP session
# -------------------------------------------------
COPY --chown="${USERNAME}:${USERNAME}" config/.xsession /home/${USERNAME}/.xsession
RUN chmod +x /home/${USERNAME}/.xsession

# Create Desktop directory and shortcuts for audio testing
RUN mkdir /home/${USERNAME}/Desktop && chown "${USERNAME}:${USERNAME}" /home/${USERNAME}/Desktop
COPY --chown="${USERNAME}:${USERNAME}" config/TestSound_paplay.desktop /home/${USERNAME}/Desktop/TestSound_paplay.desktop
COPY --chown="${USERNAME}:${USERNAME}" config/TestSound_aplay.desktop /home/${USERNAME}/Desktop/TestSound_aplay.desktop
RUN chmod +x /home/${USERNAME}/Desktop/*.desktop

# -------------------------------------------------
# Expose RDP port and launch XRDP
# -------------------------------------------------
EXPOSE 3389
CMD ["/bin/sh", "-c", "/usr/sbin/xrdp-sesman && exec /usr/sbin/xrdp -nodaemon"]
