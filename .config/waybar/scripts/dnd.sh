#!/usr/bin/env bash

is_paused=$(dunstctl is-paused 2>/dev/null)

if [ "$is_paused" = "true" ]; then
    printf '{"text":"󰂛","class":"paused","tooltip":"Do Not Disturb: Active\\nClick: Enable Notifications\\nRight-Click: Show Last Notification"}\n'
else
    printf '{"text":"󰂚","class":"normal","tooltip":"Notifications: Active\\nClick: Enable Do Not Disturb\\nRight-Click: Show Last Notification"}\n'
fi
