FROM quay.io/centos/centos:stream AS micro-build

RUN \
  mkdir -p /rootfs && \
  dnf install -y \
    --disableplugin subscription-manager --installroot /rootfs \
    --releasever 8 --setopt install_weak_deps=false --nodocs \
    coreutils-single \
    glibc-minimal-langpack \
    tang \
    socat \
  && \
  cp -v /etc/yum.repos.d/*.repo /rootfs/etc/yum.repos.d/ && \
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
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["socat", "tcp-l:7050,reuseaddr,fork", "exec:\"/usr/libexec/tangd /var/db/tang\""]

VOLUME /var/db/tang
EXPOSE 7050/tcp
