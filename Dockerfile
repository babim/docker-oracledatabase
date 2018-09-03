FROM oraclelinux:7-slim

# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

# Environment variables required for this build (do NOT change)
# -------------------------------------------------------------
ENV ORACLE_BASE=/u01/app/oracle \
    ORACLE_HOME=/u01/app/oracle/product/11.2.0/xe \
    ORACLE_SID=XE \
    INSTALL_FILE_1="oracle-xe-11.2.0-1.0.x86_64.rpm.zip" \
    INSTALL_DIR="$HOME/install" \
    CONFIG_RSP="xe.rsp" \
    RUN_FILE="runOracle.sh" \
    PWD_FILE="setPassword.sh" \
    CHECK_DB_FILE="checkDBStatus.sh"

# Use second ENV so that variable get substituted
ENV PATH=$ORACLE_HOME/bin:$PATH

# Copy binaries
# -------------
COPY $CONFIG_RSP $RUN_FILE $PWD_FILE $CHECK_DB_FILE $INSTALL_DIR/

# Install Oracle Express Edition
# ------------------------------

RUN mkdir -p $INSTALL_DIR/ && cd $INSTALL_DIR/ && \
    wget http://media.matmagoc.com/oracle/$INSTALL_FILE_1 && \
    yum -y install unzip libaio bc initscripts net-tools openssl && \
    yum clean all && \
    cd $INSTALL_DIR && \
    unzip $INSTALL_FILE_1 && \
    rm $INSTALL_FILE_1 &&    \
    cat() { declare -A PROC=(["/proc/sys/kernel/shmmax"]=4294967295 ["/proc/sys/kernel/shmmni"]=4096 ["/proc/sys/kernel/shmall"]=2097152 ["/proc/sys/fs/file-max"]=6815744); [[ ${PROC[$1]} == "" ]] && /usr/bin/cat $* || echo ${PROC[$1]}; } && \
    free() { echo "Swap: 2048 0 2048"; } && \
    export -f cat free && \
    rpm -i Disk1/*.rpm &&    \
    unset -f cat free && \
    mkdir -p $ORACLE_BASE/scripts/setup && \
    mkdir $ORACLE_BASE/scripts/startup && \
    ln -s $ORACLE_BASE/scripts /docker-entrypoint-initdb.d && \
    mkdir $ORACLE_BASE/oradata && \
    chown -R oracle:dba $ORACLE_BASE && \
    mv $INSTALL_DIR/$CONFIG_RSP $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$RUN_FILE $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$PWD_FILE $ORACLE_BASE/ && \
    mv $INSTALL_DIR/$CHECK_DB_FILE $ORACLE_BASE/ && \
    ln -s $ORACLE_BASE/$PWD_FILE / && \
    cd $HOME && \
    rm -rf $INSTALL_DIR && \
    chmod ug+x $ORACLE_BASE/*.sh

VOLUME ["$ORACLE_BASE/oradata"]
EXPOSE 1521 8080
HEALTHCHECK --interval=1m --start-period=5m \
   CMD "$ORACLE_BASE/$CHECK_DB_FILE" >/dev/null || exit 1

CMD exec $ORACLE_BASE/$RUN_FILE
