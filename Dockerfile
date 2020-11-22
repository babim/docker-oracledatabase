FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

ARG release=18
ARG update=5

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# install
RUN wget --no-check-certificate -O - https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20OracleDatabase%20install/client/18_install.sh | bash

ENV PATH=$PATH:/usr/lib/oracle/${release}.${update}/client64/bin
ENTRYPOINT ["/option.sh"]
CMD ["sqlplus", "-v"]
