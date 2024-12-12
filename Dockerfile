#IMAGE: Get the base image for Liberty
FROM 227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/liberty

#BINARIES: Add in all necessary application binaries
COPY src/main/liberty/config/server.xml /config/server.xml
USER root
RUN chown 1001:0 /config/server.xml
USER 1001

# Generate Liberty config based on server.xml
RUN configure.sh

RUN mvn clean package

#ADD target/webModule.war /opt/ibm/wlp/usr/servers/defaultServer/apps
