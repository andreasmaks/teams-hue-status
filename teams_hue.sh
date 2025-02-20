#!/bin/bash

# Hue Bridge Configuration
HUE_BRIDGE_IP="your_hue_bridge_ip"
USERNAME="your_hue_username"
LIGHT_ID="your_light_id"

# Function to control the Hue light
set_hue_light() {
    local STATE=$1
    local URL="http://$HUE_BRIDGE_IP/api/$USERNAME/lights/$LIGHT_ID/state"

    if [ "$STATE" == "off" ]; then
        curl -s -X PUT "$URL" -d '{"on":false}' > /dev/null
    else
        curl -s -X PUT "$URL" -d '{"on":true, "hue":0, "sat":254, "bri":64}' > /dev/null  # 25% brightness
    fi
}

# Checks if the "retain" value increases (Microphone query for Teams)
is_meeting_active() {
    RETAIN_VALUES=$(ioreg -c "AppleHDAEngineInput" | grep "IOAudioEngineUserClient" | grep -o "retain [0-9]*" | awk '{print $2}')

    for VALUE in $RETAIN_VALUES; do
        if [ "$VALUE" -gt 6 ]; then
            return 0  # Meeting active
        fi
    done
    return 1  # No meeting
}

# Loop to check status continuously
LAST_STATE="off"

while true; do
    if is_meeting_active; then
        if [ "$LAST_STATE" != "on" ]; then
            echo "📞 Meeting detected - Setting Hue to red"
            set_hue_light "on"
            LAST_STATE="on"
        fi
    else
        if [ "$LAST_STATE" != "off" ]; then
            echo "📞 No meeting - Turning off Hue"
            set_hue_light "off"
            LAST_STATE="off"
        fi
    fi

    sleep 5  # Check every 5 seconds
done
