# Gradle Installation

For this project ``Gradle`` is installed locally, although there is 
an [Gradle is a build tool with a focus on build automation and support for multi-language development](https://hub.docker.com/_/gradle/) image.

The ``gradle`` installation instructions has been changed from the default to be consistent ``maven`` instructions.

## Prerequisites

To function `Gradle` requires a ``Java`` installation, accessible via ``JAVA_HOME``

```console
PS C:\Users\sjfke> java -version
openjdk version "21.0.7" 2025-04-15 LTS
OpenJDK Runtime Environment Temurin-21.0.7+6 (build 21.0.7+6-LTS)
OpenJDK 64-Bit Server VM Temurin-21.0.7+6 (build 21.0.7+6-LTS, mixed mode, sharing)
```
### Installing Maven

#### Windows Platform

Create a folder in ``Gradle`` and unpack the downloaded gradle zip file into this folder

```powershell
PS C:\Users\sjfke> new-item -ItemType Directory "C:\Program Files\Gradle"
# Extract gradle zip into this folder
PS C:\Users\sjfke> ls "C:\Program Files\Gradle"
```

* [Download latest Gradele](https://gradle.org/releases/), such as `gradle-8.14.3`

In the ``Windows`` task bar search enter ``Environment variables`` which takes you to 
``System Properties`` > ``Advanced system settings`` > ``Environment variables`` > ``System variables``

* Create ``GRADLE_HOME`` = `C:\Program Files\Gradle\gradle-8.14.3`
* Update ``Path``, add ``%GRADLE_HOME%\bin``

```console
PS C:\Users\sjfke> gradle -version

------------------------------------------------------------
Gradle 8.14.3
------------------------------------------------------------

Build time:    2025-07-04 13:15:44 UTC
Revision:      e5ee1df3d88b8ca3a8074787a94f373e3090e1db

Kotlin:        2.0.21
Groovy:        3.0.24
Ant:           Apache Ant(TM) version 1.10.15 compiled on August 25 2024
Launcher JVM:  21.0.7 (Eclipse Adoptium 21.0.7+6-LTS)
Daemon JVM:    C:\Program Files\Eclipse Adoptium\jdk-21.0.7.6-hotspot (no JDK specified, using current Java home)
OS:            Windows 11 10.0 amd64
```

### General Gradle references

* [The Gradle Cookbook](https://cookbook.gradle.org/preface/)
* [Gradle - Migrating Builds From Apache Maven](https://docs.gradle.org/current/userguide/migrating_from_maven.html)
* [Gradle - User Manual](https://docs.gradle.org/current/userguide/userguide.html)
* [Gradle - Core Basics](https://docs.gradle.org/current/userguide/gradle_basics.html)
* [Gradle - Build File Basics](https://docs.gradle.org/current/userguide/build_file_basics.html)
* [MVN Repository](https://mvnrepository.com/) which also specifies the ``gradle`` alternative
