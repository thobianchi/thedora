ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN rpm-ostree override remove opensc && \
    rpm-ostree initramfs --enable --arg=--force-add --arg=fido2 && \
    rpm-ostree install chromium-libs-media-freeworld \
    dconf-editor \
    ffmpeg \
    ffmpeg-libs \
    fido2-tools \
    firewall-config \
    fzf \
    gnome-tweaks \
    google-chrome-stable \
    gparted \
    gstreamer1-plugin-openh264 \
    igt-gpu-tools \
    intel-media-driver \
    langpacks-en \
    libva-utils \
    mozilla-openh264 \
    pam-u2f \
    rpmfusion-free-release \
    rpmfusion-nonfree-release \
    tilix \
    tilix-nautilus \
    tmux \
    zsh 

RUN rpm-ostree install \
    https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
    https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   
RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    ostree container commit

# sudo rpm-ostree update \
#   --uninstall rpmfusion-free-release \
#   --uninstall rpmfusion-nonfree-release \
#   --install rpmfusion-free-release \
#   --install rpmfusion-nonfree-release