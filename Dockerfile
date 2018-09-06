FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV VERSION=12.2.0.1 \
    PRODUCT=EE \
    INSTALL_FILE_1="linuxx64_12201_database.zip" \
    ORACLE_BASE=/opt/oracle \
    ORACLE_HOME=$ORACLE_BASE/product/$VERSION/dbhome_1 \
    INSTALL_DIR=$ORACLE_BASE/install \
    PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/usr/lib \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

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