#!/bin/bash

# Flutter Web CORS环境健康检查脚本

set -e

echo "🔍 Flutter Web CORS环境健康检查"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查计数器
CHECKS_PASSED=0
TOTAL_CHECKS=0

# 检查函数
check_service() {
    local name=$1
    local url=$2
    local expected_code=${3:-200}
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    echo -n "  检查 $name ... "
    
    if command -v curl >/dev/null 2>&1; then
        local response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null || echo "000")
        
        if [ "$response_code" = "$expected_code" ]; then
            echo -e "${GREEN}✅ 正常 ($response_code)${NC}"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
            return 0
        else
            echo -e "${RED}❌ 失败 ($response_code)${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  curl未安装，跳过网络检查${NC}"
        return 1
    fi
}

# 检查端口是否被占用
check_port() {
    local port=$1
    local service_name=$2
    
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    
    echo -n "  检查端口 $port ($service_name) ... "
    
    if command -v lsof >/dev/null 2>&1; then
        if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo -e "${GREEN}✅ 运行中${NC}"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
            return 0
        else
            echo -e "${RED}❌ 未运行${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️  lsof未安装，跳过端口检查${NC}"
        return 1
    fi
}

# 检查必要工具
check_tools() {
    echo -e "${BLUE}🔧 检查必要工具:${NC}"
    
    local tools=("node" "npm" "flutter" "curl" "lsof")
    
    for tool in "${tools[@]}"; do
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        echo -n "  $tool ... "
        
        if command -v $tool >/dev/null 2>&1; then
            local version=""
            case $tool in
                "node") version=" ($(node -v))" ;;
                "npm") version=" ($(npm -v))" ;;
                "flutter") version=" ($(flutter --version | head -1 | cut -d' ' -f2))" ;;
            esac
            echo -e "${GREEN}✅ 已安装${version}${NC}"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            echo -e "${RED}❌ 未安装${NC}"
        fi
    done
}

# 检查Node.js依赖
check_dependencies() {
    echo ""
    echo -e "${BLUE}📦 检查Node.js依赖:${NC}"
    
    if [ -f package.json ]; then
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        echo -n "  package.json ... "
        echo -e "${GREEN}✅ 存在${NC}"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
        
        if [ -d node_modules ]; then
            TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
            echo -n "  node_modules ... "
            echo -e "${GREEN}✅ 已安装${NC}"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
            echo -n "  node_modules ... "
            echo -e "${RED}❌ 未安装 (运行: npm install)${NC}"
        fi
    else
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        echo -n "  package.json ... "
        echo -e "${RED}❌ 不存在${NC}"
    fi
}

# 检查服务状态
check_services() {
    echo ""
    echo -e "${BLUE}🌐 检查服务状态:${NC}"
    
    # 检查代理服务器端口
    check_port 3001 "CORS代理服务器"
    
    # 检查Flutter Web端口
    check_port 16001 "Flutter Web应用"
    
    echo ""
    echo -e "${BLUE}🏥 检查服务健康状态:${NC}"
    
    # 检查代理服务器健康检查端点
    check_service "代理服务器健康检查" "http://127.0.0.1:3001/health"
    
    # 检查原始API服务器
    check_service "原始API服务器" "http://47.106.218.81:20080" "404"
    
    # 检查Flutter Web应用
    check_service "Flutter Web应用" "http://localhost:16001" "200"
}

# 检查配置文件
check_config() {
    echo ""
    echo -e "${BLUE}⚙️  检查配置文件:${NC}"
    
    local config_files=(
        "lib/config/api_config.dart"
        "lib/config/cors_config.dart"
        "proxy.js"
        "pubspec.yaml"
    )
    
    for file in "${config_files[@]}"; do
        TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
        echo -n "  $file ... "
        
        if [ -f "$file" ]; then
            echo -e "${GREEN}✅ 存在${NC}"
            CHECKS_PASSED=$((CHECKS_PASSED + 1))
        else
            echo -e "${RED}❌ 不存在${NC}"
        fi
    done
}

# 显示建议
show_recommendations() {
    echo ""
    echo -e "${BLUE}💡 建议操作:${NC}"
    
    if [ $CHECKS_PASSED -eq $TOTAL_CHECKS ]; then
        echo -e "${GREEN}🎉 所有检查通过！环境配置正确。${NC}"
        echo ""
        echo "📋 快速操作指南:"
        echo "  启动开发环境: ./scripts/start_dev.sh"
        echo "  停止开发环境: ./scripts/stop_dev.sh"
        echo "  打开应用: http://localhost:16001"
        echo "  代理服务器: http://127.0.0.1:3001"
    else
        echo -e "${YELLOW}⚠️  发现 $((TOTAL_CHECKS - CHECKS_PASSED)) 个问题，建议修复:${NC}"
        echo ""
        echo "🔧 修复步骤:"
        
        if ! command -v node >/dev/null 2>&1; then
            echo "  1. 安装 Node.js: https://nodejs.org/"
        fi
        
        if ! command -v flutter >/dev/null 2>&1; then
            echo "  2. 安装 Flutter: https://flutter.dev/docs/get-started/install"
        fi
        
        if [ ! -d node_modules ]; then
            echo "  3. 安装依赖: npm install"
        fi
        
        if ! lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "  4. 启动代理服务器: npm start"
        fi
        
        if ! lsof -Pi :16001 -sTCP:LISTEN -t >/dev/null 2>&1; then
            echo "  5. 启动Flutter应用: flutter run -d web-server --web-port 16001"
        fi
    fi
}

# 显示环境信息
show_environment_info() {
    echo ""
    echo -e "${BLUE}📊 环境信息:${NC}"
    echo "  操作系统: $(uname -s)"
    echo "  架构: $(uname -m)"
    echo "  当前目录: $(pwd)"
    echo "  脚本位置: $(dirname "$0")"
    
    if [ -f proxy.pid ]; then
        echo "  代理进程PID: $(cat proxy.pid)"
    fi
    
    if [ -f proxy.log ]; then
        echo "  代理日志: proxy.log (最后10行)"
        echo "    $(tail -1 proxy.log 2>/dev/null || echo '日志为空')"
    fi
}

# 主流程
main() {
    check_tools
    check_dependencies
    check_config
    check_services
    show_environment_info
    
    echo ""
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}📈 检查结果: $CHECKS_PASSED/$TOTAL_CHECKS 通过${NC}"
    echo -e "${BLUE}=================================${NC}"
    
    show_recommendations
}

# 运行主流程
main "$@"