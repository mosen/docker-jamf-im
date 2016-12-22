#!/usr/bin/env bash

export JSAM_HOSTNAME=${JSAM_HOSTNAME:-"jsam"}
export JSS_URL=${JSS_URL:-"jss"}
export JSS_USERNAME=${JSS_USERNAME:-"admin"}
export JSS_PASSWORD=${JSS_PASSWORD:-"password"}

if [ $1 == "enroll" ]; then
    echo "Enrolling JAMF Infrastructure Manager..."
    cd /usr/share/jamf-im
    echo "$JSS_PASSWORD" | java -jar \
        -Dcom.jamfsoftware.jsam.configDir="/etc/jamf-im/jsam" -jar /usr/share/jamf-im/jsam-enroll-1.0.1.jar \
        --hostname "$JSAM_HOSTNAME" \
        --jss-url  "$JSS_URL" \
        --username "$JSS_USERNAME" \
        --stdin || NO_INVITE=1

    if [ $NO_INVITE -eq 1 ]; then
        echo "Failed to enroll Infrastructure Manager."
    fi
else
    echo "Starting JAMF Infrastructure Manager..."
    /usr/bin/java -Dcom.jamfsoftware.jsam.configDir=/etc/jamf-im/jsam \
       -Dlog4j.configurationFile=/etc/jamf-im/jsam/logging/log4j2-jamf-im-launcher.xml \
       -DjsamLogPath=/var/log \
       -jar /usr/share/jamf-im/jsam-launcher-1.0.1.jar
fi
