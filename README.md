# Tomcat-JSP-Servlet Development

This project uses **containers** to provide a development and testing environment.

* ``tomcat`` - a tomcat 10.1.x container, built to include the documentation and examples
* ``dbs`` - a MariaDB container, using docker volume, ``jsp-bookstore-data``
* ``adminer`` - a database WebUI management
* ``jsp-net`` - dedicated docker network

The example ``Tomcat`` application is based on [tomcat-containers](https://github.com/sjfke/tomcat-containers/blob/main/README.md) but makes no reference to ``Eclipse ``, nor
how the code was developed. 

The ``tomcat`` container listens on port ``8480``, not the default ``8080`` to avoid port conflicts.

The Java development was done with [IntelliJ IDEA Community Edition](https://www.jetbrains.com/idea/download).

``Maven`` uses ``org.codehaus.cargo.cargo-maven3-plugin`` to un/deploy the ``WAR`` file, and is installed 
locally on the development laptop, although it is possible to *containerize* 
it, [Apache Maven is a software project management and comprehension tool](https://hub.docker.com/_/maven).

To build the `Bookstore-0.0.1-SNAPSHOT.war` file from the command line

```powershell
PS C:\Users\sjfke> mvn clean package   # create war file
PS C:\Users\sjfke> mvn cargo:undeploy  # remove bookstore application on tomcat container
PS C:\Users\sjfke> mvn cargo:deploy    # deploy bookstore application on tomcat container
```

This project is an early stage of development and is restricted to:

* ``Windows 11 (home)`` but ``Linux`` approach is planned
* ``docker`` and ``docker compose``, although a ``podman`` approach is planned
* ``maven``, although a ``gradle`` is planned.

The ``Wharf`` folder contains ``README`` files, covering the detail of the local setup, such as ``DOCKER``, 
``MAVEN`` and ``MARIADB``

## Prerequisites

The following applications need installed locally.

* [Docker Desktop](./Wharf/DOCKER.md)
* [Maven](./Wharf/MAVEN.md)

Setting up ``MariDB`` is covered in

* [MariaDB](./Wharf/MARIADB.md)


### Build and Deploy to Tomcat container Using Maven

Tomcat 10 onwards requires the ``JSP`` pages use ``<%@ taglib uri="jakarta.tags.core" prefix="c" %>`` 

Using an incorrect ``maven``  dependencies often results in ``java.lang.NoClassDefFoundError: javax/servlet/jsp/tagext/TagLibraryValidator`` errors.

There is contradictory advice on how to do this, and ``Tomcat 10.0.x``, ``Tomcat 10.1.x`` and ``Tomcat 11.x`` require 
difference ``dependencies``, so use the following to avoid many wasted hours.

* [How to properly configure Jakarta EE libraries in Maven pom.xml for Tomcat?](https://stackoverflow.com/questions/65703840/how-to-properly-configure-jakarta-ee-libraries-in-maven-pom-xml-for-tomcat/65704617#65704617)

To build the `Bookstore-0.0.1-SNAPSHOT.war` file from the command line

```powershell
PS C:\Users\sjfke> mvn clean package   # create war file
PS C:\Users\sjfke> mvn cargo:undeploy  # remove bookstore application on tomcat container
PS C:\Users\sjfke> mvn cargo:deploy    # deploy bookstore application on tomcat container
```

### Tomcat Maven Dependencies

* [Tomcat Versions](https://cwiki.apache.org/confluence/display/TOMCAT/Tomcat+Versions)

Using ``Tomcat 10.0.x``, ``Tomcat 10.1.x`` and ``Tomcat 11.x`` require 
difference ``dependencies``, so use the following to avoid many wasted hours, which is copied 
from [How to properly configure Jakarta EE libraries in Maven pom.xml for Tomcat?](https://stackoverflow.com/questions/65703840/how-to-properly-configure-jakarta-ee-libraries-in-maven-pom-xml-for-tomcat/65704617#65704617)

It is usually possible to update the sub-version of the dependencies to the latest available.

#### Tomcat 9.X

For your Tomcat 9.x, which is based on ``Servlet 4.0``, ``JSP 2.3``, ``EL 3.0``, ``WS 1.1`` and ``JASIC 1.0``.

Use ``javax.*`` imports and the **entire** ``<dependencies>`` section should *minimally* look like:

```xml
<dependencies>
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.servlet.jsp</groupId>
        <artifactId>javax.servlet.jsp-api</artifactId>
        <version>2.3.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.el</groupId>
        <artifactId>javax.el-api</artifactId>
        <version>3.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.websocket</groupId>
        <artifactId>javax.websocket-api</artifactId>
        <version>1.1</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>javax.security.enterprise</groupId>
        <artifactId>javax.security.enterprise-api</artifactId>
        <version>1.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

#### Tomcat 10.0.x

For Tomcat 10.0.x, which is based on ``Servlet 5.0``, ``JSP 3.0``, ``EL 4.0``, ``WS 2.0`` and ``JASIC 2.0``.

Use ``jakarta.*`` imports and the **entire** ``<dependencies>`` section should *minimally* look like:

```xml
<dependencies>
    <dependency>
        <groupId>jakarta.servlet</groupId>
        <artifactId>jakarta.servlet-api</artifactId>
        <version>5.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.servlet.jsp</groupId>
        <artifactId>jakarta.servlet.jsp-api</artifactId>
        <version>3.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.el</groupId>
        <artifactId>jakarta.el-api</artifactId>
        <version>4.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.websocket</groupId>
        <artifactId>jakarta.websocket-api</artifactId>
        <version>2.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.security.enterprise</groupId>
        <artifactId>jakarta.security.enterprise-api</artifactId>
        <version>2.0.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

#### Tomcat 10.1.x

For Tomcat 10.1.x, which is based on ``Servlet 6.0``, ``JSP 3.1``, ``EL 5.0``, ``WS 2.1`` and ``JASIC 3.0``.

Use ``jakarta.*`` imports and the **entire** ``<dependencies>`` section should *minimally* look like:

```xml
<dependencies>
    <dependency>
        <groupId>jakarta.servlet</groupId>
        <artifactId>jakarta.servlet-api</artifactId>
        <version>6.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.servlet.jsp</groupId>
        <artifactId>jakarta.servlet.jsp-api</artifactId>
        <version>3.1.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.el</groupId>
        <artifactId>jakarta.el-api</artifactId>
        <version>5.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.websocket</groupId>
        <artifactId>jakarta.websocket-api</artifactId>
        <version>2.1.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.security.enterprise</groupId>
        <artifactId>jakarta.security.enterprise-api</artifactId>
        <version>3.0.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

#### Tomcat 11.x

For Tomcat 11.x, which is based on ``Servlet 6.1``, ``JSP 4.0``, ``EL 6.0``, ``WS 2.2`` and ``JASIC 4.0``.

Use`` jakarta.*`` imports and the **entire** ``<dependencies>`` section should *minimally* look like:

```xml
<dependencies>
    <dependency>
        <groupId>jakarta.servlet</groupId>
        <artifactId>jakarta.servlet-api</artifactId>
        <version>6.1.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.servlet.jsp</groupId>
        <artifactId>jakarta.servlet.jsp-api</artifactId>
        <version>4.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.el</groupId>
        <artifactId>jakarta.el-api</artifactId>
        <version>6.0.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.websocket</groupId>
        <artifactId>jakarta.websocket-api</artifactId>
        <version>2.2.0</version>
        <scope>provided</scope>
    </dependency>
    <dependency>
        <groupId>jakarta.security.enterprise</groupId>
        <artifactId>jakarta.security.enterprise-api</artifactId>
        <version>3.1.0</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

### Tomcat Manager HTML interface

```console
PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/list
OK - Listed applications for virtual host [localhost]
/:running:0:ROOT
/examples:running:0:examples
/host-manager:running:0:host-manager
/bookstore-1.5-SNAPSHOT:running:0:bookstore-1.5-SNAPSHOT
/manager:running:0:manager
/docs:running:0:docs

PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/serverinfo
OK - Server info
Tomcat Version: [Apache Tomcat/10.1.41]
OS Name: [Linux]
OS Version: [6.6.87.1-microsoft-standard-WSL2]
OS Architecture: [amd64]
JVM Version: [21.0.7+6-LTS]
JVM Vendor: [Eclipse Adoptium]

PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/stop?path=/bookstore-1.5-SNAPSHOT
OK - Stopped application at context path [/bookstore-1.5-SNAPSHOT]

PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/start?path=/bookstore-1.5-SNAPSHOT
OK - Started application at context path [/bookstore-1.5-SNAPSHOT]

PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/undeploy?path=/bookstore-1.5-SNAPSHOT
OK - Undeployed application at context path [/bookstore-1.5-SNAPSHOT]

PS1> curl.exe -u badmin:badmin -X PUT --upload-file .\target\bookstore-1.5-SNAPSHOT.war "http://localhost:8480/manager/text/deploy?path=/bookstore-1.5-SNAPSHOT"
OK - Deployed application at context path [/bookstore-1.5-SNAPSHOT]

# All these fail because the WAR file needs to be on the Tomcat server
PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/deploy?war=bookstore-1.5-SNAPSHOT.war
FAIL - Failed to deploy application at context path [/bookstore-1.5-SNAPSHOT]
PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/deploy?path=bookstore-1.5-SNAPSHOT.war
FAIL - Invalid parameters supplied for command [/deploy]
PS1> curl.exe -u badmin:badmin http://localhost:8480/manager/text/deploy?path=bookstore-1.5-SNAPSHOT
FAIL - Invalid parameters supplied for command [/deploy]

```

### Maven 3 Cargo Plugin

The Tomcat text manager deploy didn't work on Windows, and is a bit **clunky**, so this project uses the ``Maven 3 Cargo plugin``

A typical deployment sequence being

```console
PS1> mvn clean package
PS1> mvn cargo:undeploy
PS1> mvn cargo:deploy
```

> **Warning**
>>
>> **mvn install** deploys to the local ``.m2/repository``, which needs manual removal.




* [Cargo - Tomcat 10.x](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/886439938/Tomcat+10.x)
* [Maven 3 codehaus-cargo plugin](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/491631/Maven+3+Plugin)
* [Common Maven Cargo Plugin Issues and How to Fix Them](https://javanexus.com/blog/common-maven-cargo-issues-fix)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war), see 5.3 remote deploy
* [Deploying legacy WARs to Tomcat 10.x onwards](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/2520383491/Deploying+legacy+WARs+to+Tomcat+10.x+onwards)
