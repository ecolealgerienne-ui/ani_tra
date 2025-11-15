#!/usr/bin/env python3
"""
Fix Duration constant usages by REMOVING incorrect 'const' keyword.
AppConstants.longAnimation is already a const Duration, so we don't need 'const' before it.
"""

import re
from pathlib import Path

def fix_duration_in_file(file_path):
    """Fix Duration constant usage in a single file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    changes = 0

    # Fix: const AppConstants.XXXAnimation -> AppConstants.XXXAnimation
    # Remove incorrect 'const' before AppConstants duration constants
    pattern = r'\bconst\s+AppConstants\.(longAnimation|mediumAnimation|shortAnimation)\b'
    new_content = re.sub(pattern, r'AppConstants.\1', content)
    if new_content != content:
        changes = content.count('const AppConstants.') - new_content.count('const AppConstants.')
        content = new_content

    # Write back if changed
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True, changes

    return False, 0


def main():
    """Process all Dart files with Duration issues."""
    base_dir = Path('/home/user/ani_tra')

    # Find all .dart files that might have this issue
    dart_files = list(base_dir.glob('lib/**/*.dart'))

    print("Fixing Duration constant usages (removing incorrect 'const')...")
    print("=" * 80)

    fixed_count = 0
    total_changes = 0

    for file_path in sorted(dart_files):
        fixed, changes = fix_duration_in_file(file_path)
        if fixed:
            rel_path = file_path.relative_to(base_dir)
            print(f"✓ Fixed {changes} occurrence(s) in: {rel_path}")
            fixed_count += 1
            total_changes += changes

    print("=" * 80)
    print(f"Fixed {total_changes} occurrences in {fixed_count} files")
    print("\nDone!")


if __name__ == '__main__':
    main()
