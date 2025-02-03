# Build and configure the application
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi-minimal

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

# Copy the WAR file directly
COPY --chown=1001:0 $APPNAME /config/apps/$APPNAME

# Install AWS X-Ray daemon
RUN yum install -y unzip
RUN curl -o /tmp/xray-daemon.zip https://s3.amazonaws.com/aws-xray-assets.us-east-1/xray-daemon/aws-xray-daemon-linux.zip
RUN unzip /tmp/xray-daemon.zip -d /usr/local/bin
RUN rm /tmp/xray-daemon.zip

# Run the daemon in the background along with the application
CMD /usr/local/bin/xray-daemon -o

# Thin the application and configure
RUN springBootUtility thin \
  --sourceAppPath=/config/apps/$APPNAME \
  --targetThinAppPath=/config/apps/thin-$APPNAME \
  --targetLibCachePath=/lib.index.cache

# Copy the server.xml configuration
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml

# Install Liberty features and run additional configuration
RUN features.sh && configure.sh
