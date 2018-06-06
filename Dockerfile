FROM centos:7

LABEL maintainer="Adrian Lucrèce Céleste <adrianlucrececeleste@airmail.cc>"

RUN RUN yum -y update && yum install tang && yum clean all

VOLUME [ "/var/db/tang", "/var/cache/tang" ]

ENTRYPOINT [ "/usr/libexec/tangd", "/var/cache/tang" ]