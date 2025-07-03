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

``Maven`` is installed locally on the development laptop, although it is possible to *containerize* 
it, [Apache Maven is a software project management and comprehension tool](https://hub.docker.com/_/maven) or use
the bundled [IntelliJ IDEA Maven](https://www.jetbrains.com/help/idea/maven-support.html)

The maven plugin ``org.codehaus.cargo.cargo-maven3-plugin`` is used to un/deploy the ``WAR`` file.

To build the `Bookstore-0.0.1-SNAPSHOT.war` file from the command line

```powershell
PS C:\Users\sjfke> mvn clean package   # create war file
PS C:\Users\sjfke> mvn cargo:undeploy  # remove bookstore application on tomcat container
PS C:\Users\sjfke> mvn cargo:deploy    # deploy bookstore application on tomcat container
```

The ``Wharf`` folder contains ``README`` files, covering the detail of the local setup, such as [DOCKER](./Wharf/DOCKER.md), 
[MAVEN](./Wharf/MAVEN.md), [MAVEN_DEPLOYMENT](./Wharf/MAVEN_DEPLOYMENT.md), [TOMCAT_MAVEN](./Wharf/TOMCAT_MAVEN.md) 
and [MARIADB](./Wharf/MARIADB.md)

## Future Updates

This project is an early stage of development and is restricted to:

* ``Windows 11 (home)`` but ``Linux`` approach is planned
* ``docker`` and ``docker compose``, although a ``podman`` approach is planned
* ``maven``, although a ``gradle`` is planned.

## Prerequisites

The following applications need installed locally, [Docker Desktop](./Wharf/DOCKER.md) and [Maven](Wharf/MAVEN.md)

Setting up ``MariDB`` is covered in [MariaDB](./Wharf/MARIADB.md)

## Build and Deploy to Tomcat container Using Maven

Tomcat 10 onwards requires the ``JSP`` pages use ``<%@ taglib uri="jakarta.tags.core" prefix="c" %>`` 

Using an incorrect ``maven``  dependencies often results in ``java.lang.NoClassDefFoundError: javax/servlet/jsp/tagext/TagLibraryValidator`` errors.

There is contradictory advice on how to set up this properly, and furthermore ``Tomcat 10.0.x``, ``Tomcat 10.1.x`` and ``Tomcat 11.x`` require 
difference ``dependencies``, so read [Tomcat Maven Dependencies](./Wharf/TOMCAT_MAVEN.md) to avoid many wasted hours.

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
## Tomcat Setup

To set up ``Tomcat`` for development, the contents of the ``Config`` folder are used.

This make ``docs``, ``examples``, ``host-manager`` and ``manger`` available and accessible on the ``Docker`` IP subnets.

Two user roles are created, with the password being the same as the account name.

* ``admin`` for ``host-manager`` and ``manger``
* ``badmin`` for the Manager HTML interface

The ``tomcat-users.xml``

```xml
<?xml version="1.0" encoding="UTF-8"?>

<tomcat-users version="1.0" xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd">
    <user password="admin" roles="manager-gui,manager-status,admin-gui" username="admin"/>
    <user password="badmin" roles="manager-script,admin-script" username="badmin"/>
</tomcat-users>
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

But it is the ``maven-3-cargo-plugin`` that is used.