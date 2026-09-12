#!/usr/bin/env python3
import json
import os
import sys
import time
import urllib.request

CACHE_FILE = "/tmp/waybar_weather_cache.json"
CACHE_TTL = 900  # 15 minutes

WEATHER_ICONS = {
    "113": "☀️",   # Sunny / Clear
    "116": "⛅",   # Partly Cloudy
    "119": "☁️",   # Cloudy
    "122": "☁️",   # Overcast
    "143": "🌫️",   # Mist
    "176": "🌦️",   # Patchy rain possible
    "179": "🌨️",   # Patchy snow possible
    "182": "🌨️",   # Patchy sleet possible
    "185": "🌨️",   # Patchy freezing drizzle
    "200": "🌩️",   # Thundery outbreaks
    "248": "🌫️",   # Fog
    "260": "🌫️",   # Freezing fog
    "263": "🌦️",   # Patchy light drizzle
    "266": "🌧️",   # Light drizzle
    "281": "🌧️",   # Freezing drizzle
    "296": "🌧️",   # Light rain
    "302": "🌧️",   # Moderate rain
    "308": "🌧️",   # Heavy rain
    "311": "🌧️",   # Light freezing rain
    "353": "🌦️",   # Light rain shower
    "356": "🌧️",   # Moderate/heavy rain shower
    "386": "⛈️",   # Patchy light rain with thunder
    "389": "⛈️",   # Moderate/heavy rain with thunder
}

def get_cached_weather():
    if os.path.exists(CACHE_FILE):
        try:
            with open(CACHE_FILE) as f:
                data = json.load(f)
                if time.time() - data.get("timestamp", 0) < CACHE_TTL:
                    return data.get("payload")
        except Exception:
            pass
    return None

def fetch_weather():
    req = urllib.request.Request(
        "https://wttr.in/?format=j1",
        headers={"User-Agent": "curl/7.88.1"}
    )
    with urllib.request.urlopen(req, timeout=5) as response:
        return json.loads(response.read().decode())

def parse_weather(data):
    current = data["current_condition"][0]
    area = data["nearest_area"][0]

    code = current.get("weatherCode", "113")
    icon = WEATHER_ICONS.get(code, "⛅")

    temp = current.get("temp_C", "--")
    feels = current.get("FeelsLikeC", temp)
    desc = current.get("weatherDesc", [{}])[0].get("value", "Unknown").strip()
    humidity = current.get("humidity", "--")
    city = area.get("areaName", [{}])[0].get("value", "Local")

    text = f"{icon} {temp}°C"
    tooltip = (
        f"<b>{city}</b>: {desc}\n"
        f"Temperature: {temp}°C (Feels like {feels}°C)\n"
        f"Humidity: {humidity}%\n"
        f"Updated via wttr.in"
    )

    return {
        "text": text,
        "tooltip": tooltip,
        "class": "weather"
    }

def main():
    payload = get_cached_weather()
    if not payload:
        try:
            data = fetch_weather()
            payload = parse_weather(data)
            with open(CACHE_FILE, "w") as f:
                json.dump({"timestamp": time.time(), "payload": payload}, f)
        except Exception:
            if os.path.exists(CACHE_FILE):
                try:
                    with open(CACHE_FILE) as f:
                        payload = json.load(f).get("payload")
                except Exception:
                    pass
            if not payload:
                payload = {
                    "text": "⛅ --°C",
                    "tooltip": "Weather data currently unavailable",
                    "class": "offline"
                }

    print(json.dumps(payload), flush=True)

if __name__ == "__main__":
    main()
