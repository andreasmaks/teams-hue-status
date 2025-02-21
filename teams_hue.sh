#!/bin/bash

# Hue Bridge Configuration
HUE_BRIDGE_IP="<HUE_BRIDGE_IP>"  # Replace with your Hue Bridge IP
USERNAME="<USERNAME>"  # Replace with your Hue API username
LIGHT_ID="<LIGHT_ID>"  # Replace with your Hue light ID

# Function to control the Hue light
set_hue_light() {
    local STATE=$1
    local URL="http://$HUE_BRIDGE_IP/api/$USERNAME/lights/$LIGHT_ID/state"

    if [ "$STATE" == "off" ]; then
        curl -s -X PUT "$URL" -d '{"on":false}' > /dev/null
    else
        curl -s -X PUT "$URL" -d '{"on":true, "hue":0, "sat":254, "bri":64}' > /dev/null  # Set brightness to 25%
    fi
}

# Function to get the total CPU usage of Microsoft Teams
get_teams_cpu() {
    ps -Ao %cpu,comm | grep "MSTeams" | awk '{sum+=$1} END {print sum+0}' | tr ',' '.'
}

# Initialize CPU history with three values
CPU_HISTORY=(0 0 0)
LAST_STATE="off"

while true; do
    # Get the current CPU usage
    CPU_USAGE=$(get_teams_cpu)

    # Update the CPU history (keep the last 3 values)
    CPU_HISTORY=("${CPU_HISTORY[@]:1}" "$CPU_USAGE")

    # Calculate the average CPU usage
    CPU_AVG=$(echo "(${CPU_HISTORY[0]} + ${CPU_HISTORY[1]} + ${CPU_HISTORY[2]}) / 3" | bc -l)

    # Detect an active meeting (average CPU above 12%)
    if (( $(echo "$CPU_AVG > 12" | bc -l) )); then
        if [ "$LAST_STATE" != "on" ]; then
            echo "📞 Meeting detected (Avg CPU: $CPU_AVG%) - Setting Hue to red"
            set_hue_light "on"
            LAST_STATE="on"
        fi
    else
        if [ "$LAST_STATE" != "off" ]; then
            echo "📞 No meeting (Avg CPU: $CPU_AVG%) - Turning off Hue"
            set_hue_light "off"
            LAST_STATE="off"
        fi
    fi

    sleep 5  # Check every 5 seconds
done
