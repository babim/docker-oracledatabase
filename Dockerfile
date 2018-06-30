FROM oraclelinux:7-slim
# Maintainer
# ----------
MAINTAINER babim <babim@matmagoc.com>

# Download option
RUN yum install -y wget bash && cd / && wget --no-check-certificate https://raw.githubusercontent.com/babim/docker-tag-options/master/z%20SCRIPT%20AUTO/option.sh && \
    chmod 755 /option.sh

RUN groupadd dba && useradd -m -G dba oracle && mkdir /u01 && chown oracle:dba /u01
RUN yum install -y yum install oracle-rdbms-server-11gR2-preinstall glibc-static unzip && yum clean all

#ADD p13390677_112040_Linux-x86-64_1of7.zip /
#ADD p13390677_112040_Linux-x86-64_2of7.zip /
RUN echo 'Downloading linux.x64_11gR2_database_1of2.zip' && \
    wget -q -O /root/p13390677_112040_Linux-x86-64_1of7.zip http://media.matmagoc.com/oracle/p13390677_112040_Linux-x86-64_1of7.zip && \
    echo 'Downloading linux.x64_11gR2_database_2of2.zip' && \
    wget -q -O /root/p13390677_112040_Linux-x86-64_2of7.zip http://media.matmagoc.com/oracle/p13390677_112040_Linux-x86-64_2of7.zip

ADD install /install

ENV DBCA_TOTAL_MEMORY 4096
ENV WEB_CONSOLE true

ENV ORACLE_SID=EE
ENV ORACLE_HOME=/u01/app/oracle/product/11.2.0/EE
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/u01/app/oracle/product/11.2.0/EE/bin

RUN cat /etc/security/limits.conf | grep -v oracle | tee /etc/security/limits.conf && \
    cd /root && echo 'Unzipping' && unzip -q p13390677_112040_Linux-x86-64_1of7.zip && \
    unzip -q p13390677_112040_Linux-x86-64_2of7.zip && rm -f p13390677_112040*.zip && mv database /home/oracle/ && \
    su oracle -c 'cd /home/oracle/database && ./runInstaller -ignorePrereq -ignoreSysPrereqs -silent -responseFile /install/oracle-11g-ee.rsp -waitForCompletion 2>&1' && \
    rm -rf /home/oracle/database && mv /u01/app/oracle/product /u01/app/oracle-product
    
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1521
EXPOSE 8080
VOLUME ["/docker-entrypoint-initdb.d", "/u01/app/oracle"]

ENTRYPOINT ["/entrypoint.sh"]
CMD [""]
