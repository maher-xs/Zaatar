# Universal Blue Silverblue (silverblue-main هو الاسم الصحيح)
FROM ghcr.io/ublue-os/silverblue-main:stable

COPY build_files/build.sh /tmp/build.sh
COPY assets/ /tmp/zaatar-assets/
RUN --mount=type=cache,target=/var/cache/libdnf5 \
    --mount=type=cache,target=/var/cache/rpm-ostree \
    bash /tmp/build.sh