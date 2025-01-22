# Build and configure the application
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi-minimal

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT

# Copy the WAR file directly
RUN ls -ltr /config/apps

RUN ls -ltr target
COPY --chown=1001:0 target/$APPNAME /config/apps/$APPNAME

# Thin the application and configure
RUN springBootUtility thin \
  --sourceAppPath=/config/apps/$APPNAME \
  --targetThinAppPath=/config/apps/thin-$APPNAME \
  --targetLibCachePath=/lib.index.cache

# Copy the server.xml configuration
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml

# Install Liberty features and run additional configuration
RUN features.sh && configure.sh
