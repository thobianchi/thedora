ARG FEDORA_MAJOR_VERSION=37

FROM quay.io/fedora-ostree-desktops/silverblue:${FEDORA_MAJOR_VERSION}

RUN rpm-ostree install \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm && \
    rpm-ostree ex apply-live
RUN  rpm-ostree update \
        --uninstall rpmfusion-free-release-$(rpm -E %fedora) \
        --uninstall rpmfusion-nonfree-release-$(rpm -E %fedora) \
        --install rpmfusion-free-release \
        --install rpmfusion-nonfree-release
RUN rpm-ostree override remove opensc && \
    rpm-ostree initramfs --enable --arg=--force-add --arg=fido2 && \
    rpm-ostree install \
    dconf-editor \
    fido2-tools \
    firewall-config \
    fzf \
    gnome-tweaks \
    google-chrome-stable \
    gparted \
    igt-gpu-tools \
    langpacks-en \
    mozilla-openh264 \
    pam-u2f \
    tilix \
    tilix-nautilus \
    tmux \
    zsh \
    libva-utils
    ffmpeg \
    ffmpeg-libs \
    gstreamer1-plugin-openh264 \
    intel-media-driver \
    rpmfusion-free-release \
    rpmfusion-nonfree-release \
    chromium-libs-media-freeworld 

RUN sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    ostree container commit

# sudo rpm-ostree update \
#   --uninstall rpmfusion-free-release \
#   --uninstall rpmfusion-nonfree-release \
#   --install rpmfusion-free-release \
#   --install rpmfusion-nonfree-release