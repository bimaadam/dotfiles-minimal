#!/usr/bin/env bash

# Notify helper
notify() {
    notify-send -a "Wi-Fi" -u normal "$1" "$2" 2>/dev/null
}

# Check Wi-Fi state
wifi_state=$(nmcli -fields WIFI g 2>/dev/null | tr -d ' ' | tail -n 1)

if [[ "$wifi_state" =~ "disabled" ]]; then
    toggle_opt="󰤨  Enable Wi-Fi"
else
    toggle_opt="󰤭  Disable Wi-Fi"
fi

# Build menu options
options="$toggle_opt\n󰑐  Rescan Networks"

# Scan networks
if [[ "$wifi_state" =~ "enabled" ]]; then
    wifi_list=$(nmcli --get-values "IN-USE,SSID,SECURITY,BARS" device wifi list --rescan no 2>/dev/null | awk -F':' '
    $2 != "" {
        active = ($1 == "*") ? "✔ " : "   "
        lock = ($3 != "" && $3 != "--") ? " 󰌾" : "  "
        print active $2 lock " (" $4 ")"
    }' | sort -u)

    if [[ -n "$wifi_list" ]]; then
        options="$options\n$wifi_list"
    fi
fi

# Launch Rofi
chosen=$(echo -e "$options" | rofi -dmenu -i -p "󰤨 Wi-Fi" -theme-str 'window {width: 380px; height: 380px;} listview {lines: 8;}')

# Exit if cancelled
[[ -z "$chosen" ]] && exit 0

# Actions
if [[ "$chosen" == "󰤨  Enable Wi-Fi" ]]; then
    nmcli radio wifi on
    notify "Wi-Fi Enabled" "Scanning for available networks..."
elif [[ "$chosen" == "󰤭  Disable Wi-Fi" ]]; then
    nmcli radio wifi off
    notify "Wi-Fi Disabled" "Wireless networking turned off."
elif [[ "$chosen" == "󰑐  Rescan Networks" ]]; then
    notify "Scanning" "Refreshing available Wi-Fi networks..."
    nmcli device wifi rescan
    exec "$0"
else
    # Extract SSID (strip checkmark, lock icon, bars)
    ssid=$(echo "$chosen" | sed 's/^[✔ ]*//; s/ 󰌾.*//; s/ (.*)//; s/[[:space:]]*$//')

    if [[ -z "$ssid" ]]; then
        exit 0
    fi

    # Check if already connected
    if [[ "$chosen" =~ ^✔ ]]; then
        action=$(echo -e "󰤭  Disconnect\n󰑐  Reconnect" | rofi -dmenu -i -p "$ssid" -theme-str 'window {width: 280px; height: 160px;} listview {lines: 2;}')
        if [[ "$action" == "󰤭  Disconnect" ]]; then
            nmcli connection down id "$ssid" 2>/dev/null || nmcli device disconnect wlan0
            notify "Disconnected" "Disconnected from $ssid"
        elif [[ "$action" == "󰑐  Reconnect" ]]; then
            nmcli connection up id "$ssid"
            notify "Connected" "Reconnected to $ssid"
        fi
        exit 0
    fi

    # Check if connection profile already exists
    if nmcli connection show | grep -Fq "$ssid"; then
        notify "Connecting" "Connecting to saved network $ssid..."
        if nmcli connection up id "$ssid"; then
            notify "Connected" "Successfully connected to $ssid"
        else
            notify "Connection Failed" "Could not connect to $ssid"
        fi
    else
        # Needs password?
        if [[ "$chosen" =~ "󰌾" ]]; then
            password=$(rofi -dmenu -password -p "Password for $ssid" -theme-str 'window {width: 340px; height: 120px;}')
            [[ -z "$password" ]] && exit 0

            notify "Connecting" "Authenticating with $ssid..."
            if nmcli device wifi connect "$ssid" password "$password"; then
                notify "Connected" "Successfully connected to $ssid"
            else
                notify "Connection Failed" "Incorrect password or connection timed out."
            fi
        else
            notify "Connecting" "Connecting to open network $ssid..."
            if nmcli device wifi connect "$ssid"; then
                notify "Connected" "Connected to $ssid"
            else
                notify "Connection Failed" "Could not connect to $ssid"
            fi
        fi
    fi
fi
