import json
import re
import sys
import os

def parse_rgb_to_hex(rgb_str):
    # rgb(38, 58, 28) -> #263a1c
    match = re.match(r'rgb\((\d+),\s*(\d+),\s*(\d+)\)', rgb_str)
    if match:
        r, g, b = map(int, match.groups())
        return f"#{r:02x}{g:02x}{b:02x}"
    return rgb_str

def parse_cmyk_to_str(cmyk_str):
    # cmyk(4, 100, 71, 20) -> "4,100,71,20"
    match = re.match(r'cmyk\((\d+),\s*(\d+),\s*(\d+),\s*(\d+)\)', cmyk_str)
    if match:
        return ",".join(match.groups())
    return cmyk_str

def main():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    try:
        with open(os.path.join(base_dir, 'palette.json'), 'r', encoding='utf-8') as f:
            palette_data = json.load(f)
        
        with open(os.path.join(base_dir, 'tmp-palette.json'), 'r', encoding='utf-8') as f:
            tmp_data = json.load(f)
    except FileNotFoundError:
        print("Error: Files not found.")
        sys.exit(1)

    existing_names = {item['name'] for item in palette_data.get('palette', [])}
    new_items_count = 0
    
    # Iterate through all sections in tmp-palette
    # Using 'sections' to cover 'Representative_10' and 'Other'
    sections = tmp_data.get('sections', {})
    
    # Flatten lists and deduplicate by name locally first
    candidates = {}
    
    for section_name, items in sections.items():
        for item in items:
            name = item.get('name')
            if not name:
                continue
            candidates[name] = item

    # Add to palette if not exists
    for name, item in candidates.items():
        if name in existing_names:
            print(f"Skipping existing color: {name}")
            continue
            
        new_color = {
            "name": name,
            "rgb": parse_rgb_to_hex(item.get('rgb', '')),
            "cmyk": parse_cmyk_to_str(item.get('cmyk', '')),
            # Optional: Add extra metadata if useful
            "code": item.get('code'),
            "source": item.get('source_file')
        }
        
        palette_data['palette'].append(new_color)
        new_items_count += 1
        print(f"Added new color: {name} ({new_color['rgb']})")

    if new_items_count > 0:
        with open(os.path.join(base_dir, 'palette.json'), 'w', encoding='utf-8') as f:
            json.dump(palette_data, f, indent=2, ensure_ascii=False)
        print(f"\nSuccessfully added {new_items_count} colors to palette.json")
    else:
        print("\nNo new colors found to add.")

if __name__ == "__main__":
    main()
