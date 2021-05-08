FROM quay.io/centos/centos:stream
LABEL maintainer="Alexandre Chanu <alexandre.chanu@gmail.com>"

COPY entrypoint.sh /usr/local/bin/

RUN \
  dnf update -y && \
  dnf install -y \
    --disableplugin subscription-manager \
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
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["socat", "tcp-l:7050,reuseaddr,fork", "exec:\"/usr/libexec/tangd /var/db/tang\""]

VOLUME /var/db/tang
EXPOSE 7050/tcp
