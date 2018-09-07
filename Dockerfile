FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV VERSION=18c \
    PRODUCT=SE2 \
    INSTALL_FILE_1="LINUX.X64_180000_db_home.zip" \
    ORACLE_BASE="/opt/oracle" \
    INSTALL_RSP="db_inst.rsp" \
    CONFIG_RSP="dbca.rsp.tmpl" \
    PWD_FILE="setPassword.sh" \
    RUN_FILE="runOracle.sh" \
    START_FILE="startDB.sh" \
    CREATE_DB_FILE="createDB.sh" \
    SETUP_LINUX_FILE="setupLinuxEnv.sh" \
    CHECK_SPACE_FILE="checkSpace.sh" \
    CHECK_DB_FILE="checkDBStatus.sh" \
    USER_SCRIPTS_FILE="runUserScripts.sh" \
    INSTALL_DB_BINARIES_FILE="installDBBinaries.sh"

# Use second ENV so that variable get substituted
ENV ORACLE_HOME $ORACLE_BASE/product/$VERSION/dbhome_1
ENV INSTALL_DIR $ORACLE_BASE/install \
ENV PATH=$ORACLE_HOME/bin:$ORACLE_HOME/OPatch/:/usr/sbin:$PATH \
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