#IMAGE: Get the base image for Liberty
FROM websphere-liberty:21.0.0.12-full-java17-openj9


#BINARIES: Add in all necessary application binaries
COPY src/main/liberty/config/server.xml /config/server.xml
USER root
RUN chown 1001:0 /config/server.xml
USER 1001

# Generate Liberty config based on server.xml
RUN configure.sh

ADD target/webModule.war /opt/ibm/wlp/usr/servers/defaultServer/apps
