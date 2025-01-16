#IMAGE: Get the base image for Liberty
FROM 227000603860.dkr.ecr.us-east-2.amazonaws.com/cogitosum/boot3warweb

## Being ROOT
USER root
## Kinesis Agent

# RUN yum install -y amazon-ssm-agent
# RUN yum systemctl enable amazon-ssm-agent
# RUN yum systemctl start amazon-ssm-agent

#BINARIES: Add in all necessary application binaries
COPY src/main/liberty/config/server.xml /config/server.xml

RUN chown 1001:0 /config/server.xml
# Generate Liberty config based on server.xml
# RUN feature.sh
RUN configure.sh
USER 1001

## RUN mvn clean package

ADD webModule.war /opt/ibm/wlp/usr/servers/defaultServer/apps/webModule.war
