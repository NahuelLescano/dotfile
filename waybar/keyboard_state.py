#!/usr/bin/env python3

import json
import subprocess

def read_devices():
    try:
        return subprocess.check_output(["hyprctl", "-j", "devices"], text=True)
    except Exception:
        return None


def pick_keyboard(keyboards, preferred_name):
    for keyboard in keyboards:
        if keyboard.get("name") == preferred_name:
            return keyboard
    for keyboard in keyboards:
        if keyboard.get("main") is True:
            return keyboard
    return None


def main():
    preferred = "yichip-wireless-device"
    data = read_devices()
    if not data:
        print("  CAPS:OFF NUM:OFF")
        return

    obj = json.loads(data)
    keyboards = obj.get("keyboards", [])
    kb = pick_keyboard(keyboards, preferred)

    caps = bool(kb.get("capsLock")) if kb else False
    num = bool(kb.get("numLock")) if kb else False

    caps_label = "CAPS:ON" if caps else "CAPS:OFF"
    num_label = "NUM:ON" if num else "NUM:OFF"

    print(f"  {caps_label} {num_label}")


if __name__ == "__main__":
    main()
