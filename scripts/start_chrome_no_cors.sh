#!/bin/bash

# Flutter Web开发环境CORS解决方案
# 启动Chrome浏览器并禁用CORS检查

TEMP_DIR="/tmp/chrome_dev_cors"
rm -rf "$TEMP_DIR" && mkdir -p "$TEMP_DIR"

echo "🚀 启动Chrome（已禁用CORS）..."

/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome \
    --user-data-dir="$TEMP_DIR" \
    --disable-web-security \
    --disable-features=VizDisplayCompositor \
    http://localhost:16001

echo "✅ 完成"