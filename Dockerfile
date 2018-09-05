FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV VERSION=12.1.0.2 \
    PRODUCT=EE \
    INSTALL_FILE_1="linuxamd64_12102_database_se2_1of2.zip" \
    INSTALL_FILE_2="linuxamd64_12102_database_se2_2of2.zip"

# install
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20OracleDatabase%20install/oracledatabase_install.sh | bash
# remove packages
RUN curl -s https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20OracleDatabase%20install/oracledatabase_clean.sh | bash

USER oracle
WORKDIR /home/oracle

VOLUME ["$ORACLE_BASE/oradata"]
EXPOSE 1521 5500
HEALTHCHECK --interval=1m --start-period=5m \
   CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1
    
# Define default command to start Oracle Database. 
CMD exec $ORACLE_BASE/$RUN_FILE

# Environment variables default
ENV ORACLE_CHARACTERSET AL32UTF8
ENV ORACLE_NCHARACTERSET UTF8