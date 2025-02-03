# Build and configure the application
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi-minimal

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

# Copy the WAR file directly
COPY --chown=1001:0 $APPNAME /config/apps/$APPNAME

USER root
# Install AWS X-Ray daemon ( BEWARE of the region )
curl https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-3.x.rpm -o /home/ec2-user/xray.rpm
yum install -y /home/ec2-user/xray.rpm
systemctl start xray
systemctl enable xray

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
