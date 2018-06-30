FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

#ADD oracle-instantclient*.rpm /tmp/

RUN  cd /tmp && \
     wget http://media.matmagoc.com/oracle/oracle-instantclient12.2-basic-12.2.0.1.0-1.x86_64.rpm && \
     wget http://media.matmagoc.com/oracle/oracle-instantclient12.2-devel-12.2.0.1.0-1.x86_64.rpm && \
     wget http://media.matmagoc.com/oracle/oracle-instantclient12.2-sqlplus-12.2.0.1.0-1.x86_64.rpm && \
     yum -y install /tmp/oracle-instantclient*.rpm && \
     yum clean all && \
     rm -f /tmp/oracle-instantclient*.rpm && \
     echo /usr/lib/oracle/12.2/client64/lib > /etc/ld.so.conf.d/oracle-instantclient12.2.conf && \
     ldconfig

ENV PATH=$PATH:/usr/lib/oracle/12.2/client64/bin
ENTRYPOINT ["/option.sh"]
CMD ["sqlplus", "-v"]
