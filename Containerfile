FROM ghcr.io/ublue-os/bluefin:stable

COPY build_files/build.sh /tmp/build.sh
RUN bash /tmp/build.sh