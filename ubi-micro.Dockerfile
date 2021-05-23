FROM registry.access.redhat.com/ubi8/ubi:latest AS micro-build

RUN \
  mkdir -p /rootfs && \
  dnf install -y \
    --installroot /rootfs --releasever 8 \
    --setopt install_weak_deps=false --nodocs \
    coreutils-single \
    glibc-minimal-langpack \
    setup \
    openssl \
    tang \
    socat \
  && \
  dnf clean all && \
  rm -rf /rootfs/var/cache/*

COPY entrypoint.sh /rootfs/usr/local/bin/

RUN \
  mkdir -v /rootfs/var/cache/tang && \
  chmod -c u+w /rootfs/var/{db,cache}/tang && \
  chmod u+x /rootfs/usr/local/bin/entrypoint.sh


FROM scratch AS tang-micro
LABEL maintainer="Alexandre Chanu <alexandre.chanu@gmail.com>"

COPY --from=micro-build /rootfs/ /

RUN \
  chown tang /usr/local/bin/entrypoint.sh

USER tang

ENV PORT 7050

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD /bin/socat tcp-l:${PORT},reuseaddr,fork exec:"/usr/libexec/tangd /var/db/tang"

VOLUME /var/db/tang
EXPOSE 7050/tcp
