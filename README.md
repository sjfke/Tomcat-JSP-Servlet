# Tomcat-JSP-Servlet Development

This project uses **containers** to provide a development and testing environment.

* ``tomcat`` - a tomcat 10.1.x container, built to include the documentation and examples
* ``dbs`` - a MariaDB container, using docker volume, ``jsp-bookstore-data``
* ``adminer`` - a database WebUI management
* ``jsp-net`` - dedicated docker network

The example ``Tomcat`` application is based on [tomcat-containers](https://github.com/sjfke/tomcat-containers/blob/main/README.md) and 
[JSP Servlet JDBC MySQL Create Read Update Delete (CRUD) Example](https://www.codejava.net/coding/jsp-servlet-jdbc-mysql-create-read-update-delete-crud-example) 
but makes no reference to ``Eclipse ``, nor how the code was developed.

The application has been converted to [HTML5 Introduction ](https://www.w3docs.com/learn-html/html5-introduction.html) 
and makes use of [Pure.CSS](https://pure-css.github.io/) downloaded from a CDN to do some simple formatting.
To illustrate static content an [Almost](https://cssgradient.io/gradient-backgrounds/) background is also used.

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

The ``Wharf`` folder contains ``README`` files, covering the detail of the local setup, such as [DOCKER](./Wharf/DOCKER.md), 
[MAVEN](./Wharf/MAVEN.md), [MAVEN_DEPLOYMENT](./Wharf/MAVEN_DEPLOYMENT.md), [TOMCAT_MAVEN](./Wharf/TOMCAT_MAVEN.md) 
and [MARIADB](./Wharf/MARIADB.md)

## Prerequisites

The following applications need installed locally, [Docker Desktop](./Wharf/DOCKER.md) and [Maven](Wharf/MAVEN.md)

Setting up ``MariDB`` is covered in [MariaDB](./Wharf/MARIADB.md)

## Build and Deploy to Tomcat container Using Maven

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

To view the ``bookstore`` web application for the fist time.

```powershell
PS C:\Users\sjfke> start http://localhost:8480/bookstore/
```

## Tomcat Maven Dependencies

Tomcat 10 onwards requires the ``JSP`` pages use ``<%@ taglib uri="jakarta.tags.core" prefix="c" %>`` 

There is contradictory advice on the required ``Maven`` ``dependencies``, furthermore ``Tomcat 10.0.x``, ``Tomcat 10.1.x`` and ``Tomcat 11.x`` require 
difference ``dependencies``.

> #### Warning
>
> Using incorrect ``maven``  dependencies often results in ``java.lang.NoClassDefFoundError: javax/servlet/jsp/tagext/TagLibraryValidator`` errors.

[Tomcat Maven Dependencies](./Wharf/TOMCAT_MAVEN.md) provides the correct dependencies for each version of ``Tomcat``

## Maven Deployment to Tomcat container

Two approaches are described 

* [Tomcat Manager HTML interface](./Wharf/MAVEN_DEPLOYMENT.md#tomcat-manager-html-interface) 
* [Maven 3 Cargo Plugin](./Wharf/MAVEN_DEPLOYMENT.md#maven-3-cargo-plugin)

