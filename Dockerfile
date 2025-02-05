# Build and configure the application
FROM icr.io/appcafe/open-liberty:24.0.0.12-full-java17-openj9-ubi

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

USER root

# Install the X-Ray daemon
RUN yum install -y unzip
RUN yum install -y curl
RUN curl -o /tmp/daemon.zip https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-linux-3.x.zip
RUN unzip /tmp/daemon.zip && cp xray /usr/bin/xray
RUN ls -ltr
COPY start-server.sh /opt/ol/helpers/runtime/start-server.sh
RUN chmod +x /opt/ol/helpers/runtime/start-server.sh
USER 1001
COPY --chown=1001:0 $APPNAME /config/apps/$APPNAME

# Thin the application and configure
RUN springBootUtility thin \
  --sourceAppPath=/config/apps/$APPNAME \
  --targetThinAppPath=/config/apps/thin-$APPNAME \
  --targetLibCachePath=/lib.index.cache

# Copy the server.xml configuration
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml

ENTRYPOINT ["/opt/ol/helpers/runtime/start-server.sh"]

# Install Liberty features and run additional configuration
#RUN features.sh && configure.sh
