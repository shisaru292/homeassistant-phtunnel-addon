# Step 1: Use a glibc system, rather than BUILD_FROM given by docker cli
# ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:bullseye
# FROM ${BUILD_FROM}
FROM ghcr.io/home-assistant/aarch64-base-debian:bullseye

ENV DEBIAN_FRONTEND=noninteractive

# Step 2: Copy your .deb file to the image
# Copy local .deb file to /tmp/ directory in the image
COPY rootfs/ /
COPY run.sh /
RUN chmod +x /run.sh

# Step 3: Install .deb package and its dependencies
# RUN instruction executes commands inside the image

# If you are located in China, you can use aliyun mirror to speed up
RUN \
    mkdir -p /tmp && chmod 1777 /tmp && \
    echo "deb http://mirrors.aliyun.com/debian/ bullseye main" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian/ bullseye-updates main" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/debian-security/ bullseye-security main" >> /etc/apt/sources.list
RUN \
    # Prevent deb installation from performing post-installation operations since this is not a real runtime environment
    echo '#!/bin/sh' > /usr/sbin/policy-rc.d && \
    echo 'exit 101' >> /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d && \
    # First update package list
    apt-get update && \
    # Use apt install to install local .deb file. Compared to dpkg -i, apt automatically handles dependencies
    # DEBIAN_FRONTEND=noninteractive ensures no interactive prompts during installation
    # -y parameter automatically confirms all prompts
    apt-get install -y --no-install-recommends dbus && \
    apt-get install -y --no-install-recommends /tmp/phddns_5.1.0_rapi_aarch64.deb && \
    # (Optional) If the previous step fails due to dependency issues, try to fix
    # apt-get -f install -y && \
    # Task completed, remove temporary policy-rc.d file
    rm /usr/sbin/policy-rc.d && \
    # Cleanup: remove package cache and .deb files to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/*

CMD ["/run.sh"]