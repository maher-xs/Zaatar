FROM ghcr.io/ublue-os/bluefin:stable

COPY build_files/build.sh /tmp/build.sh
COPY assets/ /tmp/zaatar-assets/
RUN bash /tmp/build.sh