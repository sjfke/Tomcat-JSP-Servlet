# Maven Deployment to Tomcat

Deploying to a Tomcat container, using *"Tomcat Manager HTML interface"* or *"Maven 3 Cargo Plugin"*

## Tomcat Manager HTML interface

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

## Maven 3 Cargo Plugin

The Tomcat text manager deploy didn't work on Windows, and is a bit **clunky**, so this project uses the ``Maven 3 Cargo plugin``

A typical deployment sequence being

```console
PS1> mvn clean package
PS1> mvn cargo:undeploy
PS1> mvn cargo:deploy
```

> #### Warning
>
> **mvn install** deploys to the local ``.m2/repository``, which needs manual removal.

* [Cargo - Tomcat 10.x](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/886439938/Tomcat+10.x)
* [Maven 3 codehaus-cargo plugin](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/491631/Maven+3+Plugin)
* [Common Maven Cargo Plugin Issues and How to Fix Them](https://javanexus.com/blog/common-maven-cargo-issues-fix)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war), see 5.3 remote deploy
* [Deploying legacy WARs to Tomcat 10.x onwards](https://codehaus-cargo.atlassian.net/wiki/spaces/CARGO/pages/2520383491/Deploying+legacy+WARs+to+Tomcat+10.x+onwards)