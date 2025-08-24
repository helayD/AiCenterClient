#!/bin/bash

# macOS Flutter开发环境启动脚本
# 用于快速启动macOS版本的Flutter应用

set -e  # 出错时退出

echo "🍎 启动macOS Flutter开发环境..."

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Flutter环境
echo -e "${BLUE}📋 检查Flutter环境...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter未安装或未在PATH中${NC}"
    exit 1
fi

# 显示Flutter版本
flutter --version

# 检查macOS设备是否可用
echo -e "${BLUE}🖥️  检查macOS设备...${NC}"
if ! flutter devices | grep -q "macOS"; then
    echo -e "${RED}❌ macOS设备不可用${NC}"
    exit 1
fi
echo -e "${GREEN}✅ macOS设备可用${NC}"

# 安装依赖
echo -e "${BLUE}📦 安装Flutter依赖...${NC}"
flutter pub get
echo -e "${GREEN}✅ 依赖安装完成${NC}"

# 更新CocoaPods（macOS特有）
echo -e "${BLUE}🍎 更新CocoaPods...${NC}"
cd macos
pod install
cd ..
echo -e "${GREEN}✅ CocoaPods更新完成${NC}"

# 清理并构建
echo -e "${BLUE}🧹 清理项目...${NC}"
flutter clean
flutter pub get

# 构建macOS应用
echo -e "${BLUE}🏗️  构建macOS应用...${NC}"
flutter build macos --debug
echo -e "${GREEN}✅ macOS应用构建完成${NC}"

# 启动应用
echo -e "${BLUE}🚀 启动macOS应用...${NC}"
echo -e "${YELLOW}应用将在新窗口中打开...${NC}"
echo -e "${YELLOW}使用 'r' 进行热重载，'R' 进行热重启，'q' 退出${NC}"

# 启动应用并显示启动信息
flutter run -d macos --debug

echo -e "${GREEN}🎉 macOS开发环境启动完成！${NC}"