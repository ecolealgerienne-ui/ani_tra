#!/usr/bin/env python3
"""
Script to replace hardcoded values with AppConstants in widget files.
"""

import re
import os
from pathlib import Path

# Reuse the same mappings
FONT_SIZE_MAP = {
    '10': 'fontSizeMicro',
    '10.0': 'fontSizeMicro',
    '11': 'fontSizeTiny',
    '11.0': 'fontSizeTiny',
    '12': 'fontSizeSmall',
    '12.0': 'fontSizeSmall',
    '13': 'fontSizeSubtitle',
    '13.0': 'fontSizeSubtitle',
    '14': 'fontSizeBody',
    '14.0': 'fontSizeBody',
    '15': 'fontSizeLabel',
    '15.0': 'fontSizeLabel',
    '16': 'fontSizeMedium',
    '16.0': 'fontSizeMedium',
    '18': 'fontSizeImportant',
    '18.0': 'fontSizeImportant',
    '20': 'fontSizeLarge',
    '20.0': 'fontSizeLarge',
    '22': 'fontSizeLargeTitle',
    '22.0': 'fontSizeLargeTitle',
    '24': 'fontSizeExtraLarge',
    '24.0': 'fontSizeExtraLarge',
}

ICON_SIZE_MAP = {
    '14': 'iconSizeTiny',
    '14.0': 'iconSizeTiny',
    '16': 'iconSizeXSmall',
    '16.0': 'iconSizeXSmall',
    '18': 'iconSizeSmall',
    '18.0': 'iconSizeSmall',
    '20': 'iconSizeRegular',
    '20.0': 'iconSizeRegular',
    '24': 'iconSizeMedium',
    '24.0': 'iconSizeMedium',
    '28': 'iconSizeMedium',
    '28.0': 'iconSizeMedium',
    '32': 'iconSizeMedium',
    '32.0': 'iconSizeMedium',
    '36': 'iconSizeExtraLarge',
    '36.0': 'iconSizeExtraLarge',
    '40': 'headerIconSize',
    '40.0': 'headerIconSize',
    '48': 'iconSizeMediumLarge',
    '48.0': 'iconSizeMediumLarge',
    '60': 'typeCardIconSize',
    '60.0': 'typeCardIconSize',
    '64': 'iconSizeLarge',
    '64.0': 'iconSizeLarge',
    '80': 'iconSizeHuge',
    '80.0': 'iconSizeHuge',
}

BORDER_RADIUS_MAP = {
    '4': 'borderRadiusTiny',
    '4.0': 'borderRadiusTiny',
    '6': 'borderRadiusSmall',
    '6.0': 'borderRadiusSmall',
    '8': 'borderRadiusMedium',
    '8.0': 'borderRadiusMedium',
    '12': 'badgeBorderRadius',
    '12.0': 'badgeBorderRadius',
}

DURATION_MAP = {
    '200': 'shortAnimation',
    '300': 'mediumAnimation',
    '500': 'longAnimation',
}

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
    '48': 'spacingXLarge',
    '48.0': 'spacingXLarge',
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

    # 1. Replace fontSize: X
    for value, const_name in FONT_SIZE_MAP.items():
        pattern = rf'\bfontSize:\s*{re.escape(value)}\b'
        replacement = f'fontSize: AppConstants.{const_name}'
        new_content = re.sub(pattern, replacement, content)
        if new_content != content:
            replacements += content.count(f'fontSize: {value}') - new_content.count(f'fontSize: {value}')
            content = new_content

    # 2. Replace size: X (for Icon widgets)
    for value, const_name in ICON_SIZE_MAP.items():
        pattern = rf'\bsize:\s*{re.escape(value)}\b'
        replacement = f'size: AppConstants.{const_name}'
        new_content = re.sub(pattern, replacement, content)
        if new_content != content:
            replacements += content.count(f'size: {value}') - new_content.count(f'size: {value}')
            content = new_content

    # 3. Replace BorderRadius.circular(X)
    for value, const_name in BORDER_RADIUS_MAP.items():
        pattern = rf'BorderRadius\.circular\(\s*{re.escape(value)}\s*\)'
        replacement = f'BorderRadius.circular(AppConstants.{const_name})'
        content = re.sub(pattern, replacement, content)

    # 4. Replace SizedBox(height: X) and SizedBox(width: X)
    for value, const_name in SPACING_MAP.items():
        pattern = rf'SizedBox\(\s*height:\s*{re.escape(value)}\s*\)'
        replacement = f'SizedBox(height: AppConstants.{const_name})'
        content = re.sub(pattern, replacement, content)

        pattern = rf'SizedBox\(\s*width:\s*{re.escape(value)}\s*\)'
        replacement = f'SizedBox(width: AppConstants.{const_name})'
        content = re.sub(pattern, replacement, content)

    # 5. Replace EdgeInsets.all(X)
    for value, const_name in SPACING_MAP.items():
        pattern = rf'EdgeInsets\.all\(\s*{re.escape(value)}\s*\)'
        replacement = f'EdgeInsets.all(AppConstants.{const_name})'
        content = re.sub(pattern, replacement, content)

    # 6. Replace EdgeInsets.symmetric patterns
    for value_h, const_h in SPACING_MAP.items():
        pattern = rf'EdgeInsets\.symmetric\(\s*horizontal:\s*{re.escape(value_h)}\s*\)'
        replacement = f'EdgeInsets.symmetric(horizontal: AppConstants.{const_h})'
        content = re.sub(pattern, replacement, content)

        pattern = rf'EdgeInsets\.symmetric\(\s*vertical:\s*{re.escape(value_h)}\s*\)'
        replacement = f'EdgeInsets.symmetric(vertical: AppConstants.{const_h})'
        content = re.sub(pattern, replacement, content)

    # 7. Replace Duration(milliseconds: X)
    for value, const_name in DURATION_MAP.items():
        pattern = rf'Duration\(\s*milliseconds:\s*{re.escape(value)}\s*\)'
        replacement = f'AppConstants.{const_name}'
        content = re.sub(pattern, replacement, content)

    # 8. Replace width: X, height: X
    for value, const_name in SPACING_MAP.items():
        pattern = rf'\bwidth:\s*{re.escape(value)}\b'
        replacement = f'width: AppConstants.{const_name}'
        content = re.sub(pattern, replacement, content)

        pattern = rf'\bheight:\s*{re.escape(value)}\b'
        replacement = f'height: AppConstants.{const_name}'
        content = re.sub(pattern, replacement, content)

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
    """Process all widget files."""
    widgets_dir = Path('/home/user/ani_tra/lib/widgets')

    # Find all .dart files
    dart_files = list(widgets_dir.rglob('*.dart'))

    print(f"Found {len(dart_files)} widget files to process")
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
