# Building Tomcat-JSP-Servlet

This document walks through building the application and setting up the environment.
It is an abridged version of [tomcat-containers](https://github.com/sjfke/tomcat-containers/blob/main/README.md) 
which focuses on building the application without any reference to [Eclipse IDE for Java Developers](https://www.eclipse.org/downloads/packages/release/2022-06/r/eclipse-ide-java-developers).

It uses ``Docker`` or ``Podman`` to create the development environment. 

## Prerequisites

The following applications need to be available or installed.

* Install one of the following, but not both:
  * [Docker Desktop](./DOCKER.md)
  * [Podman and Podman Desktop](./PODMAN.md)
* Optionally install:
  * [Tomcat](./TOMCAT.md)
  * [MariaDB](./MARIADB.md)

> **Note:** *Fedora does not install the java compiler by default*

```console
$ sudo dnf list installed | grep openjdk   # dnf
$ sudo dnf list --intsalled | grep openjdk # dnf5 (fedora >= 42)
java-17-openjdk-headless.x86_64                      1:17.0.9.0.9-3.fc39                 @updates
# if openjdk-devel is missing
$ sudo dnf install java-17-openjdk-devel.x86_64      # java-17
$ sudo dnf install java-21-openjdk-devel.x86_64      # java-21 fedora 42
$ sudo dnf install java-latest-openjdk-devel.x86_64  # java-24 fedora 42
```

## Creating MariaDB Database

Assuming you have `MariaDB` running in your chosen container environment.

### Create the `Bookstore.book` table

* `docker compose` open a terminal on the `tomcat-containers-bookstoredb-1` container, see [MariaDB in Docker](./DOCKER.md#mariadb-in-docker)

> ***Warning:*** `compose-mariadb-simple.yaml` hard-codes the DB root password
>
> ***Note:***`compose-mariadb.yaml` avoids hard-coding the DB root password by using environment variables
>
> > `--env-file env\mariadb` provides MariaDB root password
> >
> > `--env-file env\adminer` overrides Adminer defaults

```powershell
PS C:\Users\sjfke> docker volume ls                                                      # jsp_bookstoredata volume exists
PS C:\Users\sjfke> docker volume create jsp-bookstore-data                               # create jsp-bookstore-data volume if DOES NOT exist
PS C:\Users\sjfke> docker compose --env-file env/mariadb -f .\compose-mariadb.yaml up -d # adminer, mariadb using tomcat-containers_jspnet
PS C:\Users\sjfke> docker exec -it tomcat-containers-bookstoredb-1 bash                  # container interactive shell (alt. sh)
```

> ***Note:***
>
> Maria Database root password is in the `compose-mariadb-simple.yaml`, `env\mariadb`, and `compose.yaml` files.

```sql
# mariadb -u root -p
Enter password:

MariaDB [(none)]> create database Bookstore;
MariaDB [(none)]> use Bookstore

MariaDB [Bookstore]> drop table if exists book;
MariaDB [Bookstore]> create table book(
  `book_id` int(11) auto_increment primary key not null,
  `title` varchar(128) unique key not null,
  `author` varchar(45) not null,
  `price` float not null
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

MariaDB [Bookstore]> insert into book (title, author, price) values ('Thinking in Java', 'Bruce Eckel', '25.69');
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

### Create an application account and grant access

```sql
# mariadb -u root -p
Enter password:
MariaDB [(none)]> use Bookstore;
MariaDB [Bookstore]> create user 'bsapp'@'%' identified by 'P@ssw0rd';
MariaDB [Bookstore]> grant all privileges on Bookstore.* to 'bsapp'@'%';
MariaDB [Bookstore]> flush privileges;
MariaDB [Bookstore]> show grants for 'bsapp'@'%';
MariaDB [Bookstore]> exit;
```

> #### Notice
>
> * The *bsapp* account is not IP access restricted, i.e. not 'bsapp'@'localhost'.
> * *Docker* will allocate a random RFC-1918 IP to the database when it is deployed.

## Verify application account access

```sql
# mariadb -u bsapp -p Bookstore
Enter password:
MariaDB [Bookstore]> select * from book;
MariaDB [Bookstore]> exit;
```

## Using *Adminer* Web Interface

All of the above steps can be done and checked using through [adminer](http://localhost:8081/).

```yaml
System: MySQL
Server: bookstoredb
Username: root
Password: r00tpa55
Database: <blank>
```

### Build and Deploy to Tomcat container Using Maven

Tomcat 10 onwards requires the ``JSP`` pages use ``<%@ taglib uri="jakarta.tags.core" prefix="c" %>`` 

Using an incorrect ``maven``  dependencies often results in ``java.lang.NoClassDefFoundError: javax/servlet/jsp/tagext/TagLibraryValidator`` errors.

There is contradictory advice on how to do this, and ``Tomcat 10.0.x``, ``Tomcat 10.1.x`` and ``Tomcat 11.x`` require 
difference ``dependencies``, so use the following to avoid many wasted hours.

* [How to properly configure Jakarta EE libraries in Maven pom.xml for Tomcat?](https://stackoverflow.com/questions/65703840/how-to-properly-configure-jakarta-ee-libraries-in-maven-pom-xml-for-tomcat/65704617#65704617)

To build the `Bookstore-0.0.1-SNAPSHOT.war` file from the command line

```console
PS C:\Users\sjfke> mvn clean package   # create war file
PS C:\Users\sjfke> mvn cargo:undeploy  # remove bookstore application on tomcat container
PS C:\Users\sjfke> mvn cargo:deploy    # deploy bookstore application on tomcat container
```

### Testing the `Bookstore` application in Eclipse

First the start the database

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-mariadb-simple.yaml up -d  # Start MariaDB and Adminer
(venv) PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                # Check MariDB is up and accessible
sjfke@unix $ nc -i 5 localhost 3306                                              # Check MariDB is up and accessible
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-mariadb-simple.yaml up -d  # Start MariaDB and Adminer
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306                # Check MariDB is up and accessible
sjfke@unix$ nc -i 5 localhost 3306                                        # Check MariDB is up and accessible
```

***Podman Kube***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman secret list                              # check secrets are loaded
PS C:\Users\sjfke> podman volume list                              # check volume exists
PS C:\Users\sjfke> podman network ls                               # check `jspnet` network exists
PS C:\Users\sjfke> podman play kube --start .\adminer-pod.yaml     # Start Adminer
PS C:\Users\sjfke> podman play kube --start .\bookstoredb-pod.yaml # Start MariaDB
PS C:\Users\sjfke> Test-NetConnection localhost -Port 3306         # Check MariDB is up and accessible
sjfke@unix$ nc -i 5 localhost 3306                                 # Check MariDB is up and accessible
```

On the `Servers` tab, *right-click* on the `Tomcat v9 Server at localhost`, and select `Start`

Test using your browser or from `Powershell` or `UNIX` command line as shown

```console
PS C:\Users\sjfke> start http://localhost:8081           # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080           # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore # Check application is working

sjfke@unix$ firefox http://localhost:8081                # Check Adminer is working
sjfke@unix$ firefox http://localhost:8080                # Check Tomcat Server is working
sjfke@unix$ firefox http://localhost:8080/Bookstore      # Check application is working
```

Stopping and removing the database deployment

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-mariadb.yaml down # Ensure MariaDB and Adminer are stopped
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-mariadb.yaml down        # Ensure MariaDB and Adminer are stopped
```

***Podman Kube***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers\wharf\Podman
PS C:\Users\sjfke> podman play kube --down .\adminer-pod.yaml           # Ensure Adminer is stopped
PS C:\Users\sjfke> podman play kube --down .\bookstoredb-pod.yaml       # Ensure MariaDB is stopped
```

### Testing the `Bookstore` application using `compose`

Using the `compose-bookstore.yaml` file

***Podman-Compose*** from within the `Python` virtual environment.

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-bookstore.yaml up -d # Start Bookstore, MariaDB and Adminer
PS C:\Users\sjfke> start http://localhost:8081                             # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080                             # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                   # Check application is working
(venv) PS C:\Users\sjfke> podman-compose -f .\compose-bookstore.yaml down  # Start Bookstore, MariaDB and Adminer
```

***Docker***

```console
# Folder: C:\Users\sjfke\Github\tomcat-containers
PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml up -d        # Start Bookstore, MariaDB and Adminer
PS C:\Users\sjfke> start http://localhost:8081                             # Check Adminer is working
PS C:\Users\sjfke> start http://localhost:8080                             # Check Tomcat Server is working
PS C:\Users\sjfke> start http://localhost:8080/Bookstore                   # Check application is working
PS C:\Users\sjfke> docker compose -f .\compose-bookstore.yaml down         # Start Bookstore, MariaDB and Adminer
```

### Tomcat Maven Dependencies

* [Tomcat Versions](https://cwiki.apache.org/confluence/display/TOMCAT/Tomcat+Versions)

It is usually possible to update the subversion of the dependencies. 

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
