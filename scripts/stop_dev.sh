#!/bin/bash

# Flutter Web CORS开发环境停止脚本

set -e

echo "🔄 停止Flutter Web开发环境"
echo "=================================="

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 停止代理服务器
stop_proxy() {
    echo -e "${YELLOW}🔄 停止CORS代理服务器...${NC}"
    
    # 通过PID文件停止
    if [ -f proxy.pid ]; then
        PROXY_PID=$(cat proxy.pid)
        if kill -0 $PROXY_PID 2>/dev/null; then
            kill $PROXY_PID
            echo -e "${GREEN}✅ 代理服务器已停止 (PID: $PROXY_PID)${NC}"
        else
            echo -e "${YELLOW}⚠️  代理服务器进程不存在${NC}"
        fi
        rm -f proxy.pid
    fi
    
    # 强制停止占用3001端口的进程
    if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}🔄 强制停止端口3001上的进程...${NC}"
        lsof -ti:3001 | xargs kill -9 2>/dev/null || true
    fi
}

# 停止Flutter Web
stop_flutter() {
    echo -e "${YELLOW}🔄 停止Flutter Web应用...${NC}"
    
    # 停止占用16001端口的进程
    if lsof -Pi :16001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${YELLOW}🔄 停止端口16001上的进程...${NC}"
        lsof -ti:16001 | xargs kill -9 2>/dev/null || true
        echo -e "${GREEN}✅ Flutter Web应用已停止${NC}"
    else
        echo -e "${YELLOW}⚠️  端口16001上没有运行的进程${NC}"
    fi
}

# 清理临时文件
cleanup_files() {
    echo -e "${YELLOW}🧹 清理临时文件...${NC}"
    
    # 删除日志文件（可选）
    if [ -f proxy.log ]; then
        echo -e "${BLUE}📄 代理服务器日志已保留: proxy.log${NC}"
    fi
    
    # 删除PID文件
    rm -f proxy.pid
    
    echo -e "${GREEN}✅ 清理完成${NC}"
}

# 显示状态
show_status() {
    echo ""
    echo -e "${BLUE}🔍 端口状态检查:${NC}"
    
    # 检查端口3001
    if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${RED}❌ 端口3001仍被占用${NC}"
    else
        echo -e "${GREEN}✅ 端口3001已释放${NC}"
    fi
    
    # 检查端口16001
    if lsof -Pi :16001 -sTCP:LISTEN -t >/dev/null 2>&1; then
        echo -e "${RED}❌ 端口16001仍被占用${NC}"
    else
        echo -e "${GREEN}✅ 端口16001已释放${NC}"
    fi
}

# 主流程
main() {
    stop_proxy
    stop_flutter
    cleanup_files
    show_status
    
    echo ""
    echo -e "${GREEN}=================================${NC}"
    echo -e "${GREEN}🎉 开发环境已完全停止${NC}"
    echo -e "${GREEN}=================================${NC}"
    echo ""
    echo -e "${BLUE}💡 重新启动请运行: ./scripts/start_dev.sh${NC}"
}

# 运行主流程
main "$@"