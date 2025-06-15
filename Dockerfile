FROM tomcat:10.1.41-jdk21-temurin

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.name="Bookstore" \
      io.k8s.description="Bookstore" \
      io.k8s.display-name="Bookstore" \
      io.k8s.version="1.0" \
      org.opencontainers.image.authors="sjfke.pool.shark@hotmail.com"

# CATALINA_BASE:   /usr/local/tomcat
# CATALINA_HOME:   /usr/local/tomcat
# CATALINA_TMPDIR: /usr/local/tomcat/temp
# JRE_HOME:        /usr
# CLASSPATH:       /usr/local/tomcat/bin/bootstrap.jar:/usr/local/tomcat/bin/tomcat-juli.jar
# Tomcat configuration files are available in /usr/local/tomcat/conf/

ENV PORT=8080
WORKDIR /usr/local/tomcat

# Setup Tomcat in a development configuration
RUN mv webapps webapps.safe && mv webapps.dist/ webapps
COPY ./Config/conf/tomcat-users.xml /usr/local/tomcat/conf/
RUN chmod 644 /usr/local/tomcat/conf/tomcat-users.xml
# Adjust context.xml for Docker Desktop IP ranges
COPY ./Config/webapps/docs/META-INF/context.xml /usr/local/tomcat/webapps/docs/META-INF/
COPY ./Config/webapps/examples/META-INF/context.xml /usr/local/tomcat/webapps/examples/META-INF/
COPY ./Config/webapps/manager/META-INF/context.xml /usr/local/tomcat/webapps/manager/META-INF/
COPY ./Config/webapps/host-manager/META-INF/context.xml /usr/local/tomcat/webapps/host-manager/META-INF/


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
# USER 1001
USER 0

# TODO: Set the default port for applications built using this image
# EXPOSE ${PORT}
CMD ["catalina.sh", "run"]