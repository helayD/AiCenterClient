#!/bin/bash

# Flutter Web CORS开发环境启动脚本
# 自动启动代理服务器和Flutter Web应用

set -e

echo "🚀 启动Flutter Web开发环境 (CORS解决方案)"
echo "================================================"

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 检查Node.js
check_node() {
    if ! command -v node &> /dev/null; then
        echo -e "${RED}❌ Node.js 未安装，请先安装 Node.js${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Node.js 版本: $(node -v)${NC}"
}

# 检查Flutter
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        echo -e "${RED}❌ Flutter 未安装，请先安装 Flutter${NC}"
        exit 1
    fi
    echo -e "${GREEN}✅ Flutter 版本: $(flutter --version | head -1)${NC}"
}

# 安装Node.js依赖
install_dependencies() {
    echo -e "${YELLOW}📦 安装Node.js依赖...${NC}"
    npm install
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 依赖安装完成${NC}"
    else
        echo -e "${RED}❌ 依赖安装失败${NC}"
        exit 1
    fi
}

# 启动代理服务器
start_proxy() {
    echo -e "${YELLOW}🔄 启动CORS代理服务器...${NC}"
    # 检查端口3001是否被占用
    if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null; then
        echo -e "${YELLOW}⚠️  端口3001已被占用，尝试终止现有进程...${NC}"
        lsof -ti:3001 | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    # 后台启动代理服务器
    nohup npm run dev > proxy.log 2>&1 &
    PROXY_PID=$!
    echo $PROXY_PID > proxy.pid
    
    # 等待代理服务器启动
    sleep 3
    
    # 检查代理服务器是否启动成功
    if curl -s http://127.0.0.1:3001/health >/dev/null 2>&1; then
        echo -e "${GREEN}✅ 代理服务器启动成功 (PID: $PROXY_PID)${NC}"
        echo -e "${BLUE}📍 代理地址: http://127.0.0.1:3001${NC}"
        echo -e "${BLUE}🏥 健康检查: http://127.0.0.1:3001/health${NC}"
    else
        echo -e "${RED}❌ 代理服务器启动失败，检查 proxy.log${NC}"
        exit 1
    fi
}

# 启动Flutter Web
start_flutter() {
    echo -e "${YELLOW}🔄 启动Flutter Web应用...${NC}"
    
    # 检查端口16001是否被占用
    if lsof -Pi :16001 -sTCP:LISTEN -t >/dev/null; then
        echo -e "${YELLOW}⚠️  端口16001已被占用，尝试终止现有进程...${NC}"
        lsof -ti:16001 | xargs kill -9 2>/dev/null || true
        sleep 2
    fi
    
    echo -e "${BLUE}🌐 启动地址: http://localhost:16001${NC}"
    echo -e "${BLUE}🎯 使用代理模式: 启用${NC}"
    echo ""
    echo -e "${GREEN}================================================${NC}"
    echo -e "${GREEN}🎉 开发环境启动完成！${NC}"
    echo -e "${GREEN}📱 Flutter Web: http://localhost:16001${NC}"
    echo -e "${GREEN}🔧 代理服务器: http://127.0.0.1:3001${NC}"
    echo -e "${GREEN}================================================${NC}"
    echo ""
    echo -e "${YELLOW}💡 提示:${NC}"
    echo "- 按 Ctrl+C 停止应用"
    echo "- 代理服务器日志: proxy.log"
    echo "- 停止脚本: scripts/stop_dev.sh"
    echo ""
    
    # 启动Flutter Web (前台运行)
    flutter run -d web-server --web-port 16001 --web-hostname 0.0.0.0
}

# 清理函数
cleanup() {
    echo ""
    echo -e "${YELLOW}🔄 正在停止开发服务器...${NC}"
    
    # 停止代理服务器
    if [ -f proxy.pid ]; then
        PROXY_PID=$(cat proxy.pid)
        if kill -0 $PROXY_PID 2>/dev/null; then
            kill $PROXY_PID
            echo -e "${GREEN}✅ 代理服务器已停止${NC}"
        fi
        rm -f proxy.pid
    fi
    
    # 停止占用端口的进程
    lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    lsof -ti:16001 | xargs kill -9 2>/dev/null || true
    
    echo -e "${GREEN}🎉 开发环境已停止${NC}"
    exit 0
}

# 注册信号处理
trap cleanup SIGINT SIGTERM

# 主流程
main() {
    echo -e "${BLUE}🔍 环境检查${NC}"
    check_node
    check_flutter
    
    echo ""
    echo -e "${BLUE}📦 准备依赖${NC}"
    install_dependencies
    
    echo ""
    echo -e "${BLUE}🚀 启动服务${NC}"
    start_proxy
    
    echo ""
    start_flutter
}

# 运行主流程
main "$@"