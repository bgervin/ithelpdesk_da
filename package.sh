#!/bin/bash
# Script to create the M365 Copilot Declarative Agent package
# This creates a zip file that can be uploaded to Teams Admin Center or Copilot Studio

set -e

echo "Creating IT HelpDesk Declarative Agent Package..."
echo ""

# Check if we're in the right directory
if [ ! -d "appPackage" ]; then
    echo "Error: appPackage directory not found!"
    echo "Please run this script from the root of the ithelpdesk_da repository."
    exit 1
fi

# Check if icon files exist (placeholders or actual files)
if [ ! -f "appPackage/color.png" ] && [ ! -f "appPackage/color.png.txt" ]; then
    echo "Warning: color.png not found!"
    echo "Please add a 192x192 pixel color icon to appPackage/color.png"
fi

if [ ! -f "appPackage/outline.png" ] && [ ! -f "appPackage/outline.png.txt" ]; then
    echo "Warning: outline.png not found!"
    echo "Please add a 32x32 pixel outline icon to appPackage/outline.png"
fi

# Create temporary directory for packaging
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Copy all necessary files
echo "Copying files..."
cp appPackage/*.json "$TEMP_DIR/"
cp appPackage/*.md "$TEMP_DIR/"

# Copy icon files if they exist (skip .txt placeholders)
if [ -f "appPackage/color.png" ]; then
    cp appPackage/color.png "$TEMP_DIR/"
else
    echo "Warning: Skipping color.png (using placeholder)"
fi

if [ -f "appPackage/outline.png" ]; then
    cp appPackage/outline.png "$TEMP_DIR/"
else
    echo "Warning: Skipping outline.png (using placeholder)"
fi

# Create the zip package
OUTPUT_FILE="ithelpdesk-agent.zip"
echo "Creating package: $OUTPUT_FILE"

cd "$TEMP_DIR"
zip -q "$OUTPUT_FILE" *.json *.md *.png 2>/dev/null || zip -q "$OUTPUT_FILE" *.json *.md

# Move the package to the original directory
mv "$OUTPUT_FILE" "$OLDPWD/"

# Clean up
cd "$OLDPWD"
rm -rf "$TEMP_DIR"

echo ""
echo "✓ Package created successfully: $OUTPUT_FILE"
echo ""
echo "Next steps:"
echo "1. Review the README.md for deployment instructions"
echo "2. Ensure you've configured:"
echo "   - ServiceNow instance URL in servicenow-openapi.json"
echo "   - ServiceNow authentication credentials"
echo "   - Knowledge base URL in declarativeAgent.json"
echo "   - App icons (color.png and outline.png)"
echo "3. Upload $OUTPUT_FILE to Teams Admin Center or Copilot Studio"
echo ""
