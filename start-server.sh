#!/bin/bash

# Start the Open Liberty server (original ENTRYPOINT command)
/opt/ol/helpers/runtime/docker-server.sh /opt/ol/wlp/bin/server run defaultServer &

# Run the X-Ray Daemon in the background
/usr/bin/xray -o -t 0.0.0.0:2000 -b 0.0.0.0:2000 -n us-east-2 &

# Wait for any background processes to complete
wait
