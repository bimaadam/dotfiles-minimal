#!/usr/bin/env python3
import glob
import os
import sys

OUTPUT_SVG = "/tmp/waybar-battery.svg"
OUTPUT_TMP = "/tmp/waybar-battery.svg.tmp"

def get_battery_info():
    total_energy_now = 0
    total_energy_full = 0
    total_charge_now = 0
    total_charge_full = 0
    has_energy = False
    has_charge = False
    is_charging = False
    is_plugged = False
    bat_summaries = []

    # Check AC adapter
    ac_file = "/sys/class/power_supply/AC/online"
    if os.path.exists(ac_file):
        try:
            with open(ac_file) as f:
                if f.read().strip() == "1":
                    is_plugged = True
        except Exception:
            pass

    bat_dirs = sorted(glob.glob("/sys/class/power_supply/BAT*"))
    for bdir in bat_dirs:
        bname = os.path.basename(bdir)
        present_file = os.path.join(bdir, "present")
        if os.path.exists(present_file):
            try:
                with open(present_file) as f:
                    if f.read().strip() != "1":
                        continue
            except Exception:
                pass

        status_file = os.path.join(bdir, "status")
        st = "Unknown"
        if os.path.exists(status_file):
            try:
                with open(status_file) as f:
                    st = f.read().strip()
                    if st.lower() == "charging":
                        is_charging = True
            except Exception:
                pass

        en_now = os.path.join(bdir, "energy_now")
        en_full = os.path.join(bdir, "energy_full")
        ch_now = os.path.join(bdir, "charge_now")
        ch_full = os.path.join(bdir, "charge_full")
        cap_file = os.path.join(bdir, "capacity")

        cap = 0
        if os.path.exists(cap_file):
            try:
                with open(cap_file) as f:
                    cap = int(f.read().strip())
            except Exception:
                pass

        bat_summaries.append(f"{bname}: {cap}% ({st})")

        if os.path.exists(en_now) and os.path.exists(en_full):
            try:
                with open(en_now) as f:
                    total_energy_now += int(f.read().strip())
                with open(en_full) as f:
                    total_energy_full += int(f.read().strip())
                has_energy = True
            except Exception:
                pass
        elif os.path.exists(ch_now) and os.path.exists(ch_full):
            try:
                with open(ch_now) as f:
                    total_charge_now += int(f.read().strip())
                with open(ch_full) as f:
                    total_charge_full += int(f.read().strip())
                has_charge = True
            except Exception:
                pass

    if has_energy and total_energy_full > 0:
        pct = int(round((total_energy_now / total_energy_full) * 100.0))
    elif has_charge and total_charge_full > 0:
        pct = int(round((total_charge_now / total_charge_full) * 100.0))
    else:
        # Fallback to capacity files
        caps = []
        for bdir in bat_dirs:
            cap_file = os.path.join(bdir, "capacity")
            if os.path.exists(cap_file):
                try:
                    with open(cap_file) as f:
                        caps.append(int(f.read().strip()))
                except Exception:
                    pass
        pct = int(round(sum(caps) / len(caps))) if caps else 100

    pct = max(0, min(100, pct))
    return pct, is_charging, is_plugged, bat_summaries

THEME_FILE = os.path.expanduser("~/.config/waybar/current_theme")

def get_current_theme():
    if os.path.exists(THEME_FILE):
        try:
            with open(THEME_FILE) as f:
                t = f.read().strip().lower()
                if t in ("macos", "light"):
                    return "macos"
        except Exception:
            pass
    return "default"

def generate_svg(pct, charging):
    width = 37.0
    total_w = 42.5
    term_x = 39.0
    fill_max = 34.0
    fill_w = max(0.0, min(fill_max, fill_max * (pct / 100.0)))

    theme = get_current_theme()
    bolt_path = "M 4.2 1.5 L 1.8 6.2 L 3.8 6.2 L 2.8 10.5 L 6.8 5.2 L 4.8 5.2 Z"

    if theme == "macos":
        # macOS Light theme colors
        stroke_color = "#1d1d1f"
        term_color = "#1d1d1f"
        if charging:
            fill_color = "#30D158"  # iOS/macOS green
            if pct == 100:
                bolt_x, font_size, text_x = 3.5, 8.5, 24.5
            elif pct < 10:
                bolt_x, font_size, text_x = 7.5, 9.5, 22.0
            else:
                bolt_x, font_size, text_x = 5.0, 9.0, 23.0
            bolt_elem = f"""<path d="{bolt_path}" transform="translate({bolt_x}, 2)" />"""
        else:
            if pct <= 20:
                fill_color = "#FF3B30"  # macOS red
            elif pct <= 30:
                fill_color = "#FF9500"  # macOS orange
            else:
                fill_color = "#1d1d1f"  # Solid dark fill
            bolt_elem = ""
            font_size = 8.5 if pct == 100 else 9.5
            text_x = 19.5

        base_text_color = "#1d1d1f"
        clip_text_color = "#000000" if charging else "#FFFFFF"
    else:
        # Default Dark theme colors
        stroke_color = "#FFFFFF"
        term_color = "#FFFFFF"
        if charging:
            fill_color = "#30D158"
            if pct == 100:
                bolt_x, font_size, text_x = 3.5, 8.5, 24.5
            elif pct < 10:
                bolt_x, font_size, text_x = 7.5, 9.5, 22.0
            else:
                bolt_x, font_size, text_x = 5.0, 9.0, 23.0
            bolt_elem = f"""<path d="{bolt_path}" transform="translate({bolt_x}, 2)" />"""
        else:
            if pct <= 20:
                fill_color = "#FF453A"
            elif pct <= 30:
                fill_color = "#FF9F0A"
            else:
                fill_color = "#FFFFFF"
            bolt_elem = ""
            font_size = 8.5 if pct == 100 else 9.5
            text_x = 19.5

        base_text_color = "#FFFFFF"
        clip_text_color = "#000000"

    text_elem = f"""<text x="{text_x:.1f}" y="11.2" font-family="Cantarell, -apple-system, BlinkMacSystemFont, 'Noto Sans', sans-serif" font-size="{font_size}" font-weight="800" text-anchor="middle">{pct}</text>"""

    svg = f"""<svg xmlns="http://www.w3.org/2000/svg" width="{total_w}" height="16" viewBox="0 0 {total_w} 16">
  <defs>
    <clipPath id="fill-clip">
      <rect x="2.5" y="2.5" width="{fill_w:.1f}" height="11" rx="2.5" />
    </clipPath>
  </defs>

  <!-- Battery Outer Capsule -->
  <rect x="1" y="1" width="{width}" height="14" rx="4.5" fill="none" stroke="{stroke_color}" stroke-width="1.3" />

  <!-- Positive Terminal Bump -->
  <rect x="{term_x}" y="4.5" width="2" height="7" rx="1" fill="{term_color}" />

  <!-- Battery Fill Level -->
  <rect x="2.5" y="2.5" width="{fill_w:.1f}" height="11" rx="2.5" fill="{fill_color}" />

  <!-- Base elements (visible over empty background) -->
  <g fill="{base_text_color}">
    {bolt_elem}
    {text_elem}
  </g>

  <!-- Inverted elements (visible over filled region) -->
  <g clip-path="url(#fill-clip)" fill="{clip_text_color}">
    {bolt_elem}
    {text_elem}
  </g>
</svg>
"""
    return svg

def main():
    pct, is_charging, is_plugged, bat_summaries = get_battery_info()

    # Consider charging if either status says charging or battery is plugged and not full
    charging = is_charging or (is_plugged and pct < 100)

    svg_content = generate_svg(pct, charging)

    with open(OUTPUT_TMP, "w") as f:
        f.write(svg_content)
    os.replace(OUTPUT_TMP, OUTPUT_SVG)

    # Tooltip string
    status_str = "Charging" if is_charging else ("Plugged in" if is_plugged else "Discharging")
    details = " · ".join(bat_summaries) if bat_summaries else "No battery info"
    tooltip = f"Battery: {pct}% ({status_str}) — {details}"

    # Print Waybar image module output format: path\ntooltip
    print(OUTPUT_SVG)
    print(tooltip)

if __name__ == "__main__":
    main()
