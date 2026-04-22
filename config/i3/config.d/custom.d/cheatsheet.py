#!/usr/bin/env python3
import os
import sys
import subprocess


PATH = os.path.expanduser("~/.config/i3/config.d/keybinds.conf")


def get_bindings(path): 
    bindings = []
    current_comment = ""

    with open(path, "r") as f: 
    
        for line in f:
            line = line.strip()
       
            if not line:
                continue


            if line.startswith("##"):
                current_text = line.lstrip("#").strip()
                
                if current_comment:
                    current_comment += " " + current_text
                else:
                    current_comment = current_text
                continue
        
            if line.startswith("bindsym") or line.startswith("bindcode"):
                parts = line.split()
            
                if len(parts) < 2:
                    continue
                key = parts[1]
                key = key.replace('$mod', 'Super')
            
                comment = current_comment
                current_comment = ""

                bindings.append((key, comment))

                continue

            current_comment = ""
    
    return bindings

def format_for_rofi(bindings):
    lines = []
    for key, comment in bindings:
        if comment:
            lines.append(f"{key} -> {comment}")
        else:
            lines.append(key)
    return "\n".join(lines)


def main():
    bindings = get_bindings(PATH)

    if not bindings:
        print("No keybind config found", file=sys.stderr)
        sys.exit(1)

    rofi_input = format_for_rofi(bindings)

    try:
        result = subprocess.run(
        ["rofi", "-dmenu", "-p", "Keybindings", "-i"],
        input=rofi_input,
        text=True,
        capture_output=True,
        check=False
        )
    except FileNotFoundError:
        print("rofi not found", file=sys.stderr)
        sys.exit(1)

    if result.returncode != 0 or not result.stdout.strip():
        return

if __name__ == "__main__":
    main()
