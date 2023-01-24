ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# RUN rpm-ostree override remove opensc
# RUN rpm-ostree initramfs --enable --arg=--force-add --arg=fido2 

RUN rpm-ostree install \
    dconf-editor \
    fido2-tools \
    firewall-config \
    fzf \
    gnome-tweaks \
    gparted \
    igt-gpu-tools \
    langpacks-en \
    mozilla-openh264 \
    pam-u2f \
    tilix \
    tilix-nautilus \
    tmux \
    zsh \
    libva-utils \
    gstreamer1-plugin-openh264 \
    intel-media-driver \
    rpmfusion-free-release \
    rpmfusion-nonfree-release \
    chromium-libs-media-freeworld \
    ffmpeg \
    ffmpeg-libs
    # google-chrome-stable

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer

COPY etc /etc

RUN ostree container commit
