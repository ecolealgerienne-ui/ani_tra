#!/usr/bin/env python3
"""
Script to replace hardcoded values with AppConstants in provider files.
Providers typically have fewer UI constants, but may have Duration values.
"""

import re
from pathlib import Path

# Duration values that should be extracted
DURATION_MAP = {
    '200': 'shortAnimation',
    '300': 'mediumAnimation',
    '500': 'longAnimation',
}

# Other common constants
SPACING_MAP = {
    '2': 'spacingMicro',
    '2.0': 'spacingMicro',
    '4': 'spacingTiny',
    '4.0': 'spacingTiny',
    '8': 'spacingExtraSmall',
    '8.0': 'spacingExtraSmall',
    '12': 'spacingSmall',
    '12.0': 'spacingSmall',
    '16': 'spacingMedium',
    '16.0': 'spacingMedium',
    '24': 'spacingMediumLarge',
    '24.0': 'spacingMediumLarge',
    '32': 'spacingLarge',
    '32.0': 'spacingLarge',
}


def replace_in_file(file_path):
    """Replace hardcoded values in a single file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    replacements = 0

    # Check if already imports constants
    has_constants_import = "import '../utils/constants.dart';" in content or \
                          "import 'package:ani_tra/utils/constants.dart';" in content

    # Replace Duration(milliseconds: X) - providers commonly have these
    for value, const_name in DURATION_MAP.items():
        pattern = rf'Duration\(\s*milliseconds:\s*{re.escape(value)}\s*\)'
        replacement = f'AppConstants.{const_name}'
        new_content = re.sub(pattern, replacement, content)
        if new_content != content:
            replacements += 1
            content = new_content

    # Add import if we made changes and don't already have it
    if content != original_content and not has_constants_import:
        import_line = "import '../utils/constants.dart';\n"

        # Find the last import statement
        import_pattern = r"^import\s+['\"].*?['\"];?\s*$"
        matches = list(re.finditer(import_pattern, content, re.MULTILINE))

        if matches:
            last_import = matches[-1]
            insert_pos = last_import.end()
            content = content[:insert_pos] + '\n' + import_line + content[insert_pos:]
        else:
            content = import_line + content

    # Write back if changed
    if content != original_content:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        return True, replacements

    return False, 0


def main():
    """Process all provider files."""
    providers_dir = Path('/home/user/ani_tra/lib/providers')

    # Find all .dart files
    dart_files = list(providers_dir.rglob('*.dart'))

    print(f"Found {len(dart_files)} provider files to process")
    print("=" * 80)

    total_modified = 0
    total_replacements = 0

    for file_path in sorted(dart_files):
        rel_path = file_path.relative_to(Path('/home/user/ani_tra'))
        modified, count = replace_in_file(file_path)

        if modified:
            print(f"✓ {rel_path}: {count} replacements")
            total_modified += 1
            total_replacements += count
        else:
            print(f"  {rel_path}: no changes")

    print("=" * 80)
    print(f"\nSummary:")
    print(f"  Files modified: {total_modified}/{len(dart_files)}")
    print(f"  Total replacements: {total_replacements}")
    print("\nDone!")


if __name__ == '__main__':
    main()
