# Build and configure the application
FROM icr.io/appcafe/open-liberty:25.0.0.1-full-java17-openj9-ubi

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

# Copy the WAR file directly
COPY --chown=1001:0 $APPNAME /config/apps/$APPNAME

USER root
# Install AWS X-Ray daemon ( BEWARE of the region )
rpm -ivh https://download-ib01.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/d/dnf-repo-0.6-1.el9.x86_64.rpm
dnf install yum
yum install -y curl
curl https://s3.us-east-2.amazonaws.com/aws-xray-assets.us-east-2/xray-daemon/aws-xray-daemon-3.x.rpm -o /tmp/xray.rpm
yum install -y /tmp/xray.rpm
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
