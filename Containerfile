# Fedora Silverblue الرسمي (بدون Universal Blue كوسيط)
FROM ghcr.io/fedora-ostree-desktops/silverblue:42

COPY build_files/build.sh /tmp/build.sh
COPY assets/ /tmp/zaatar-assets/
RUN --mount=type=cache,target=/var/cache/libdnf5 \
    --mount=type=cache,target=/var/cache/rpm-ostree \
    bash /tmp/build.sh