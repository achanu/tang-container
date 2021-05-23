FROM registry.access.redhat.com/ubi8/ubi:latest
LABEL maintainer="Alexandre Chanu <alexandre.chanu@gmail.com>"

COPY entrypoint.sh /usr/local/bin/

RUN \
  dnf update -y && \
  dnf install -y \
    --setopt install_weak_deps=false --nodocs \
    tang \
    socat \
  && \
  rm -rf /var/cache/dnf && \
  rm -rf /var/log/*.log && \
  chmod -c u+w /var/db/tang && \
  chown tang /usr/local/bin/entrypoint.sh && \
  chmod u+x /usr/local/bin/entrypoint.sh

USER tang

ENV PORT 7050

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD /bin/socat tcp-l:${PORT},reuseaddr,fork exec:"/usr/libexec/tangd /var/db/tang"

VOLUME /var/db/tang
EXPOSE 7050/tcp
