# Maven Installation

For this project ``Maven`` is installed locally, although there is 
an [Apache Maven is a software project management and comprehension tool](https://hub.docker.com/_/maven) image.

## Prerequisites

To function `Maven` requires a minimal `settings.xml` which usually has to be manually created.

* [Apache Maven Project - Settings Reference](https://maven.apache.org/settings.html)
* [Maven Complete Reference - Appendix: Settings Details](https://www.sonatype.com/maven-complete-reference/settings-details)

```console
PS C:\Users\sjfke> new-item C:\Users\sjfke\.m2\settings.xml
PS C:\Users\sjfke> get-content C:\Users\sjfke\.m2\settings.xml
```

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <localRepository/>
  <interactiveMode/>
  <usePluginRegistry/>
  <offline/>
  <pluginGroups/>
  <servers/>
  <mirrors/>
  <proxies/>
  <profiles/>
  <activeProfiles/>
</settings>
```

### Installing Maven

#### Windows Platform

Follow [How to Install Maven on Windows](https://phoenixnap.com/kb/install-maven-windows) instructions

* [Download latest Maven](https://maven.apache.org/download.cgi), such as `apache-maven-3.9.10`

In ``System`` > ``Advanced system settings`` > ``Environment variables`` > ``System variables``

* Create ``MAVEN_HOME`` = `C:\Program Files\Maven\apache-maven-3.9.10`
* Update ``Path``, add ``%MAVEN_HOME%\bin``

```console
PS C:\Users\sjfke> mvn --version
Apache Maven 3.9.10 (5f519b97e944483d878815739f519b2eade0a91d)
Maven home: C:\Program Files\Maven\apache-maven-3.9.10
Java version: 21.0.7, vendor: Eclipse Adoptium, runtime: C:\Program Files\Eclipse Adoptium\jdk-21.0.7.6-hotspot
Default locale: en_GB, platform encoding: UTF-8
OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"
```

### General Maven and Maven Packaging questions

* [Maven: The Complete Reference](https://www.sonatype.com/maven-complete-reference)
* [Apache Maven Project - Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html)
* [Apache Maven Project - WAR Plugin Usage](https://maven.apache.org/plugins/maven-war-plugin/usage.html)
* [Apache Maven Project - WAR Plugin Documentation](https://maven.apache.org/plugins/maven-war-plugin/plugin-info.html)
* [How to Deploy a WAR File to Tomcat](https://www.baeldung.com/tomcat-deploy-war)
* [10 best practices to build a Java container with Docker](https://snyk.io/blog/best-practices-to-build-java-containers-with-docker/)

