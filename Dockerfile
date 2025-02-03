# Build and configure the application
FROM icr.io/appcafe/open-liberty:25.0.0.1-full-java17-openj9-ubi

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

# Copy the WAR file directly
COPY --chown=1001:0 $APPNAME /config/apps/$APPNAME

USER root
# Install AWS X-Ray daemon ( BEWARE of the region )
RUN dnf install yum
RUN yum install -y curl
RUN curl https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-3.x.rpm -o /tmp/xray.rpm
RUN yum install -y /tmp/xray.rpm
#RUN systemctl start xray
#RUN systemctl enable xray

USER 1001

# Thin the application and configure
RUN springBootUtility thin \
  --sourceAppPath=/config/apps/$APPNAME \
  --targetThinAppPath=/config/apps/thin-$APPNAME \
  --targetLibCachePath=/lib.index.cache

# Copy the server.xml configuration
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml

# Install Liberty features and run additional configuration
RUN features.sh && configure.sh
