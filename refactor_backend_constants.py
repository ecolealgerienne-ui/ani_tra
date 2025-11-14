#!/usr/bin/env python3
"""
Script to replace hardcoded values with AppConstants in backend files
(repositories, models, drift).
These typically don't have UI constants but may have Duration or other values.
"""

import re
from pathlib import Path

# Duration values that should be extracted
DURATION_MAP = {
    '200': 'shortAnimation',
    '300': 'mediumAnimation',
    '500': 'longAnimation',
}


def replace_in_file(file_path):
    """Replace hardcoded values in a single file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content
    replacements = 0

    # Check if already imports constants
    has_constants_import = "import '../utils/constants.dart';" in content or \
                          "import '../../utils/constants.dart';" in content or \
                          "import 'package:ani_tra/utils/constants.dart';" in content

    # Replace Duration(milliseconds: X) - might be in some backend code
    for value, const_name in DURATION_MAP.items():
        pattern = rf'Duration\(\s*milliseconds:\s*{re.escape(value)}\s*\)'
        replacement = f'AppConstants.{const_name}'
        new_content = re.sub(pattern, replacement, content)
        if new_content != content:
            replacements += 1
            content = new_content

    # Add import if we made changes and don't already have it
    if content != original_content and not has_constants_import:
        # Determine import path based on directory depth
        if 'lib/repositories/' in str(file_path):
            import_line = "import '../utils/constants.dart';\n"
        elif 'lib/models/' in str(file_path):
            import_line = "import '../utils/constants.dart';\n"
        elif 'lib/drift/' in str(file_path):
            import_line = "import '../utils/constants.dart';\n"
        else:
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
    """Process all backend files."""
    base_dir = Path('/home/user/ani_tra/lib')

    directories = [
        base_dir / 'repositories',
        base_dir / 'models',
        base_dir / 'drift'
    ]

    all_files = []
    for directory in directories:
        if directory.exists():
            # Skip .g.dart generated files
            files = [f for f in directory.rglob('*.dart') if not f.name.endswith('.g.dart')]
            all_files.extend(files)

    print(f"Found {len(all_files)} backend files to process")
    print("=" * 80)

    total_modified = 0
    total_replacements = 0

    for file_path in sorted(all_files):
        rel_path = file_path.relative_to(Path('/home/user/ani_tra'))
        modified, count = replace_in_file(file_path)

        if modified:
            print(f"✓ {rel_path}: {count} replacements")
            total_modified += 1
            total_replacements += count

    print("=" * 80)
    print(f"\nSummary:")
    print(f"  Files modified: {total_modified}/{len(all_files)}")
    print(f"  Total replacements: {total_replacements}")

    if total_modified == 0:
        print("\n  No hardcoded values found in backend files (expected)")

    print("\nDone!")


if __name__ == '__main__':
    main()
