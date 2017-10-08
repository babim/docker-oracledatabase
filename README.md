Oracle Enterprise Edition 11g Release 2
============================

Oracle Enterprise Edition 11g Release 2 on Oracle Linux

#Error: Create database stop at 76%

### Installation

    docker pull babim/oracledatabase:11.2.0.4

Run with 8080 and 1521 ports opened:

    docker run -d -p 8080:8080 -p 1521:1521 babim/oracledatabase:11.2.0.4

Run with data on host and reuse it:

    docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle babim/oracledatabase:11.2.0.4

Run with Custom DBCA_TOTAL_MEMORY (in Mb):

    docker run -d -p 8080:8080 -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -e DBCA_TOTAL_MEMORY=1024 babim/oracledatabase:11.2.0.4

Connect database with following setting:

    hostname: localhost
    port: 1521
    sid: EE
    service name: EE.oracle.docker
    username: system
    password: oracle

To connect using sqlplus:

<pre>
sqlplus system/oracle@//localhost:1521/EE.oracle.docker
</pre>

Password for SYS & SYSTEM:

    oracle

Apex install up to v 5.*

    docker run -it --rm --volumes-from ${DB_CONTAINER_NAME} --link ${DB_CONTAINER_NAME}:oracle-database -e PASS=YourSYSPASS sath89/apex install
Details could be found here: https://github.com/MaksymBilenko/docker-oracle-apex

Connect to Oracle Enterprise Management console with following settings:

    http://localhost:8080/em
    user: sys
    password: oracle
    connect as sysdba: true

By Default web management console is enabled. To disable add env variable:

    docker run -d -e WEB_CONSOLE=false -p 1521:1521 -v /my/oracle/data:/u01/app/oracle babim/oracledatabase:11.2.0.4
    #You can Enable/Disable it on any time

Start with additional init scripts or dumps:

    docker run -d -p 1521:1521 -v /my/oracle/data:/u01/app/oracle -v /my/oracle/init/SCRIPTSorSQL:docker-entrypoint-initdb.d babim/oracledatabase:11.2.0.1
By default Import from `docker-entrypoint-initdb.d` enabled only if you are initializing database(1st run). If you need to run import at any case - add `-e IMPORT_FROM_VOLUME=true`
**In case of using DMP imports dump file should be named like ${IMPORT_SCHEME_NAME}.dmp**
**User credentials for imports are  ${IMPORT_SCHEME_NAME}/${IMPORT_SCHEME_NAME}**

If you have an issue with database init like DBCA operation failed, please reffer to this [issue](https://github.com/MaksymBilenko/docker-oracle-11g/issues/16)



**TODO LIST**
* Web management console HTTPS port
* Add functionality to run custom scripts on startup, for example User creation
* Add Parameter that would setup processes amount for database (Currently by default processes=300)
* Spike with clustering support
* Spike with DB migration from 11g

**In case of any issues please post it [here](https://github.com/MaksymBilenko/docker-oracle-11g/issues).**


