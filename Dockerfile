# Stage and thin the application
FROM icr.io/appcafe/open-liberty:full-java21-openj9-ubi-minimal AS staging

ARG APPNAME=webModule.war
COPY --chown=1001:0 target/$APPNAME /staging/$APPNAME

RUN springBootUtility thin \
 --sourceAppPath=/staging/$APPNAME \
 --targetThinAppPath=/staging/thin-$APPNAME \
 --targetLibCachePath=/staging/lib.index.cache

FROM icr.io/appcafe/open-liberty:kernel-slim-java21-openj9-ubi-minimal

ARG APPNAME=webModule.war
ARG VERSION=1.0
ARG REVISION=SNAPSHOT
COPY --chown=1001:0 src/main/liberty/config/server.xml /config/server.xml

RUN features.sh

COPY --chown=1001:0 --from=staging /staging/lib.index.cache /lib.index.cache
COPY --chown=1001:0 --from=staging /staging/$APPNAME \
                    /config/apps/$APPNAME

RUN configure.sh