#!/usr/bin/env python3
"""
Fix Duration constant usages by adding 'const' keyword where needed.
"""

import re
from pathlib import Path

def fix_duration_in_file(file_path):
    """Fix Duration constant usage in a single file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # Fix: Future.delayed(AppConstants.XXXAnimation) -> Future.delayed(const AppConstants.XXXAnimation)
    # Pattern: Future.delayed( followed by AppConstants.XXXAnimation without const
    pattern = r'Future\.delayed\(\s*AppConstants\.(longAnimation|mediumAnimation|shortAnimation)\s*\)'
    replacement = r'Future.delayed(const AppConstants.\1)'
    content = re.sub(pattern, replacement, content)

    # Fix: await Future.delayed(AppConstants.XXXAnimation) -> await Future.delayed(const AppConstants.XXXAnimation)
    pattern = r'await\s+Future\.delayed\(\s*AppConstants\.(longAnimation|mediumAnimation|shortAnimation)\s*\)'
    replacement = r'await Future.delayed(const AppConstants.\1)'
    content = re.sub(pattern, replacement, content)

    # Write back if changed
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True

    return False


def main():
    """Process all Dart files with Duration issues."""
    files_to_fix = [
        'lib/screens/animal/add_animal_screen.dart',
        'lib/screens/animal/animal_list_screen.dart',
        'lib/screens/lot/lot_list_screen.dart',
        'lib/screens/movement/sale_screen.dart',
        'lib/screens/movement/slaughter_screen.dart',
        'lib/screens/weight/weight_record_screen.dart',
    ]

    base_dir = Path('/home/user/ani_tra')

    print("Fixing Duration constant usages...")
    print("=" * 80)

    fixed_count = 0
    for file_rel in files_to_fix:
        file_path = base_dir / file_rel
        if file_path.exists():
            if fix_duration_in_file(file_path):
                print(f"✓ Fixed: {file_rel}")
                fixed_count += 1
            else:
                print(f"  No changes needed: {file_rel}")
        else:
            print(f"  File not found: {file_rel}")

    print("=" * 80)
    print(f"Fixed {fixed_count} files")
    print("\nDone!")


if __name__ == '__main__':
    main()
