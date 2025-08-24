# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

这是一个Flutter响应式管理面板/仪表板应用程序，支持跨平台部署（Web、移动端、桌面）和多语言国际化。项目采用Provider状态管理模式，实现了完全响应式设计，支持移动端、平板和桌面端的适配。

### 核心特性
- **🌍 跨平台支持**: Web、Android、iOS、macOS、Windows
- **🌐 多语言支持**: 中文简体、English，支持动态切换
- **📱 响应式设计**: 移动端、平板、桌面端完美适配
- **🎨 Material Design 3主题**: 官方MD3配色+明亮/暗黑/自动模式
- **🔐 真实API认证**: 完整的登录、注销、token管理
- **🌐 HTTP客户端**: 自动重试、错误处理、Cookie管理
- **⚡ 热重载**: 开发模式支持实时更新
- **✨ WCAG可访问性**: 4.5:1对比度标准，确保无障碍访问

## 开发环境设置

### 前置要求
- Flutter SDK (>=3.5.0 <4.0.0)
- Dart SDK
- 对应平台的开发工具（Android Studio、Xcode等）

### 安装依赖
```bash
flutter pub get
```

## 核心开发命令

### 运行项目
```bash
# 开发模式运行（热重载）
flutter run

# 指定平台运行
flutter run -d chrome          # Web浏览器
flutter run -d macos           # macOS桌面
flutter run -d android         # Android设备/模拟器
flutter run -d ios             # iOS设备/模拟器

# 指定端口运行（Web）
flutter run -d chrome --web-hostname localhost --web-port 16000
```

### 构建项目
```bash
# Web构建
flutter build web

# Android APK构建
flutter build apk

# iOS构建
flutter build ios

# macOS构建
flutter build macos

# Windows构建
flutter build windows
```

### 测试
```bash
# 运行所有测试
flutter test

# 运行特定测试文件
flutter test test/widget_test.dart

# 测试覆盖率
flutter test --coverage
```

### 代码质量检查
```bash
# 代码格式化
flutter format .

# 静态分析
flutter analyze

# 依赖检查
flutter pub deps
```

## 项目架构

### 目录结构
```
lib/
├── main.dart              # 应用入口点
├── constants.dart          # 全局常量（颜色、padding等）
├── responsive.dart         # 响应式布局工具类
├── controllers/            # 状态管理控制器
│   └── menu_app_controller.dart
├── models/                 # 数据模型
│   ├── my_files.dart      # 文件存储模型
│   └── recent_file.dart   # 最近文件模型
└── screens/               # UI界面
    ├── main/              # 主界面
    │   ├── main_screen.dart
    │   └── components/
    │       └── side_menu.dart
    └── dashboard/         # 仪表板
        ├── dashboard_screen.dart
        └── components/    # 仪表板组件
```

### 核心架构模式

#### 1. 响应式设计系统
- **桌面端**: 屏幕宽度 >= 1100px
- **平板端**: 850px <= 屏幕宽度 < 1100px  
- **移动端**: 屏幕宽度 < 850px

使用 `Responsive` 类进行响应式布局：
```dart
Responsive(
  mobile: MobileLayout(),
  tablet: TabletLayout(), // 可选
  desktop: DesktopLayout(),
)
```

#### 2. 状态管理
采用Provider模式：
- `MenuAppController`: 侧边栏菜单控制
- 使用 `ChangeNotifier` 实现状态变更通知
- 通过 `MultiProvider` 注入依赖

#### 3. 科技商务设计系统 🎨
基于Tailwind CSS设计原理的企业级UI设计系统，提供完整的明暗双主题和组件库。

**核心设计文件**:
- `lib/theme/tech_theme_system.dart` - 主题系统和设计令牌
- `lib/components/tech_components.dart` - 科技商务组件库  
- `lib/design/ui_specification.dart` - 完整使用规范文档
- `lib/design/integration_guide.dart` - 实际集成指南

**主题系统配置**:
```dart
// 在main.dart中配置
MaterialApp(
  theme: TechThemeSystem.lightTheme,
  darkTheme: TechThemeSystem.darkTheme,
  themeMode: ThemeMode.system, // 支持系统跟随
)
```

**核心设计令牌**:
```dart
// 基于OKLCH色彩空间的科学配色
class TechLightColors {
  static const primary = Color(0xFF2563EB);      // 科技蓝
  static const secondary = Color(0xFF059669);    // 成功绿
  static const accent = Color(0xFF7C3AED);       // 创新紫
  static const warning = Color(0xFFD97706);      // 警告橙
  static const error = Color(0xFFDC2626);        // 错误红
  // 完整色彩层次 (50-950)...
}

// Tailwind风格4px基准间距系统
class TechSpacing {
  static const xs = 4.0;    // 0.25rem
  static const sm = 8.0;    // 0.5rem
  static const md = 16.0;   // 1rem (标准)
  static const lg = 24.0;   // 1.5rem
  static const xl = 32.0;   // 2rem
  static const xxl = 48.0;  // 3rem
}
```

**🌟 科技商务设计系统特色**:
- ✅ **Tailwind CSS原理**: 基于utility-first和设计令牌系统
- ✅ **OKLCH色彩空间**: 科学配色，确保视觉一致性和可访问性
- ✅ **明暗双主题**: 完整的Light/Dark模式支持
- ✅ **4px基准系统**: 精确的rem基准间距体系
- ✅ **科技商务风格**: 扁平化、数据导向、专业可信的企业级设计
- ✅ **组件化架构**: 完整的组件库，支持响应式设计

### 关键依赖包
- `provider ^6.1.2`: 状态管理
- `google_fonts ^6.2.1`: Google字体支持（Poppins）
- `flutter_svg ^2.0.10`: SVG图标支持
- `fl_chart ^0.68.0`: 图表组件
- `cupertino_icons ^1.0.8`: iOS风格图标
- `flutter_localizations`: Flutter官方国际化支持
- `intl ^0.19.0`: 国际化和本地化
- `shared_preferences ^2.2.2`: 本地数据存储
- `http ^1.2.2`: HTTP客户端基础包
- `dio ^5.9.0`: 高级HTTP客户端（拦截器、Cookie支持）
- `dio_cookie_manager ^3.3.0`: Cookie管理器
- `cookie_jar ^4.0.8`: Cookie存储

## 开发指南

### 添加新界面
1. 在 `lib/screens/` 下创建新目录
2. 实现响应式布局，继承 `StatelessWidget` 或 `StatefulWidget`
3. 在 `side_menu.dart` 中添加导航项
4. 更新路由配置

### 添加新组件
1. 组件放在对应界面的 `components/` 目录下
2. 遵循现有的命名约定（小写下划线分隔）
3. 实现响应式设计，考虑三种屏幕尺寸
4. 使用项目主题色彩系统

### 状态管理最佳实践
1. 继承 `ChangeNotifier` 创建控制器
2. 使用 `notifyListeners()` 通知UI更新
3. 在widget中使用 `Consumer` 或 `context.watch()` 监听状态
4. 控制器通过 `Provider` 注入到widget树

### 样式指南

#### 使用新设计系统
```dart
// 1. 使用TechCard替代传统Card
TechCard(
  padding: EdgeInsets.all(TechThemeSystem.spacing.lg),
  child: YourContent(),
)

// 2. 使用主题色彩而非硬编码
Container(color: Theme.of(context).colorScheme.primary)

// 3. 使用TechButton替代普通Button
TechButton.primary(
  onPressed: () {},
  child: Text('主要操作'),
)

// 4. 使用MetricDisplay展示数据指标
MetricDisplay(
  title: '总用户数',
  value: '12,847',
  change: '+12.5%',
  trend: TrendType.up,
  icon: Icons.people,
)
```

#### 设计原则
- **扁平化设计**: 无过度装饰，突出内容本身
- **主题统一**: 使用 `Theme.of(context)` 获取主题色彩
- **间距规范**: 使用 `TechThemeSystem.spacing` 替代硬编码数值
- **响应式优先**: 考虑移动端、平板、桌面三种屏幕尺寸
- **可访问性**: 确保4.5:1对比度标准

#### 资源组织
- SVG图标存放在 `assets/icons/`
- 图片资源存放在 `assets/images/`
- 设计系统文档在 `lib/design/` 目录

## 国际化与本地化

### 支持语言
- **中文简体** (zh-CN) - 默认语言
- **英文** (en-US) - 国际语言

### 国际化架构
```
lib/
├── l10n/                           # 国际化资源
│   ├── app_en.arb                  # 英文翻译文件
│   ├── app_zh.arb                  # 中文翻译文件
│   └── (自动生成)
│       ├── app_localizations.dart  # 本地化类
│       ├── app_localizations_en.dart
│       └── app_localizations_zh.dart
├── controllers/
│   └── locale_controller.dart      # 语言状态管理
```

### 使用国际化文本
```dart
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// 在Widget中使用
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  
  return Text(l10n.adminLogin);  // 替代硬编码文本
}

// 在Controller中使用（需要传递context）
String? validateEmail(String? value, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  if (value == null || value.isEmpty) {
    return l10n.emailRequired;
  }
  return null;
}
```

### 添加新的翻译文本
1. 在 `lib/l10n/app_en.arb` 中添加英文文本
2. 在 `lib/l10n/app_zh.arb` 中添加对应中文文本
3. 运行 `flutter gen-l10n` 重新生成本地化代码
4. 在代码中使用 `l10n.新键名` 访问

### 语言切换
```dart
// 获取语言控制器
final localeController = context.read<LocaleController>();

// 切换到英文
await localeController.setLocale(Locale('en', 'US'));

// 切换到中文
await localeController.setLocale(Locale('zh', 'CN'));

// 切换到下一个语言
await localeController.toggleLanguage();

// 使用系统语言
await localeController.useSystemLocale();
```

### 添加新语言支持
1. 更新 `LocaleController.supportedLocales` 添加新语言
2. 创建新的 ARB 文件 (如: `app_fr.arb`)
3. 翻译所有文本键值
4. 更新 `getLanguageName` 方法
5. 重新生成本地化代码

## 平台特定注意事项

### Web部署
- 构建输出在 `build/web/` 目录
- 支持Progressive Web App (PWA)
- 需要配置 `web/index.html` 进行定制

### 移动端
- Android: 最小SDK版本在 `android/app/build.gradle` 配置
- iOS: 部署目标在 `ios/Runner.xcodeproj` 配置
- 图标和启动屏配置在各平台资源目录

### 桌面端
- macOS: 需要开发者证书进行代码签名
- Windows: 使用CMake构建系统
- 权限配置在各平台的manifest文件中

## API认证系统

### 架构概述
应用集成了完整的API认证系统，支持真实的后端API通信，包括登录、token管理、自动刷新等功能。

### 核心组件

#### 1. API配置 (`lib/config/api_config.dart`)
```dart
// API端点配置
static const String baseUrl = 'http://47.106.218.81:20080';
static const Map<String, String> endpoints = {
  'login': '/api/v1/auth/login',
  'logout': '/api/v1/auth/logout',
  'refresh': '/api/v1/auth/refresh',
  'profile': '/api/v1/user/profile',
};
```

#### 2. HTTP服务 (`lib/services/http_service.dart`)
- **Dio客户端**: 高级HTTP功能
- **Cookie管理**: 自动session管理
- **请求拦截器**: 自动添加Authorization头
- **响应拦截器**: 自动token刷新、错误处理
- **重试机制**: 网络失败自动重试

#### 3. 认证服务 (`lib/services/auth_service.dart`)
```dart
// 登录API调用
final response = await authService.login(
  identifier: "admin",
  password: "Admin123@",
  rememberMe: false,
);
```

#### 4. 认证控制器 (`lib/controllers/auth_controller.dart`)
- **状态管理**: 登录状态、用户信息、错误消息
- **自动初始化**: 应用启动时检查登录状态
- **Token管理**: 自动存储和刷新
- **错误处理**: 网络错误、认证失败处理

### 登录流程

1. **用户输入**: 用户名/邮箱 + 密码
2. **API调用**: POST `/api/v1/auth/login`
3. **Token存储**: 成功后存储access_token和refresh_token
4. **状态更新**: 更新认证状态和用户信息
5. **导航跳转**: 自动跳转到主界面

### 请求格式
```json
{
  "identifier": "admin",
  "password": "Admin123@",
  "remember_me": false
}
```

### 响应处理
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": 4096,
      "email": "admin@example.com",
      "username": "admin",
      "name": "Administrator"
    }
  }
}
```

### 安全特性
- **Token自动刷新**: 401错误时自动刷新token
- **安全存储**: 使用SharedPreferences安全存储凭据
- **Session管理**: Cookie自动管理和持久化
- **错误处理**: 网络错误、认证错误友好提示

## 主题系统

### 主题模式
- **明亮模式**: 白色背景，深色文字
- **暗黑模式**: 深色背景，浅色文字  
- **自动模式**: 跟随系统主题设置

### 主题控制器 (`lib/controllers/theme_controller.dart`)
```dart
// 切换主题模式
await themeController.setThemeMode(AppThemeMode.light);   // 明亮模式
await themeController.setThemeMode(AppThemeMode.dark);    // 暗黑模式  
await themeController.setThemeMode(AppThemeMode.auto);    // 自动模式

// 获取当前主题状态
bool isDark = themeController.isDarkMode;
```

### 主题组件 (`lib/components/theme_selector.dart`)
- **ThemeSelector**: 完整的主题选择界面
- **QuickThemeToggle**: 快速切换按钮

### 科技商务组件库 🎨

#### 核心组件
```dart
// TechCard - 现代化内容容器
TechCard(
  padding: EdgeInsets.all(TechThemeSystem.spacing.lg),
  showBorder: true,           // 可选边框
  elevation: 2,               // 可选阴影
  child: YourContent(),
)

// MetricDisplay - KPI数据展示
MetricDisplay(
  title: '业务指标',
  value: '12,847',
  change: '+12.5%',
  trend: TrendType.up,        // up, down, neutral
  icon: Icons.trending_up,
)

// TechButton - 多变体按钮系统  
TechButton.primary(onPressed: () {}, child: Text('主要'))
TechButton.secondary(onPressed: () {}, child: Text('次要'))
TechButton.outline(onPressed: () {}, child: Text('轮廓'))
TechButton.ghost(onPressed: () {}, child: Text('幽灵'))

// StatusIndicator - 状态指示器
StatusIndicator(
  status: StatusType.success, // success, warning, error, info
  text: '在线',
  showDot: true,
)
```

#### 设计特色
- **扁平化设计**: 无过度装饰，突出内容本身
- **科学配色**: OKLCH色彩空间，确保视觉一致性
- **响应式**: 支持移动端、平板、桌面适配  
- **明暗双主题**: 完整的Light/Dark模式
- **可访问性**: 4.5:1对比度标准

#### 组件层次
- **Primary**: 页面主要操作，最高视觉权重
- **Secondary**: 次要操作，中等视觉权重
- **Outline**: 较低优先级操作，边框样式
- **Ghost**: 最低视觉权重，透明背景

### 主题持久化
- 使用SharedPreferences存储用户主题偏好
- 应用启动时自动恢复用户选择
- 支持系统主题变化监听

## 运行指南

### 双服务开发环境启动

**完整启动流程**（推荐）：

#### 1. 启动CORS代理服务器
```bash
# 启动Node.js代理服务器（端口3001）
npm start
```

#### 2. 启动Flutter Web应用
```bash
# 启动Flutter Web应用（端口16001）
flutter run -d web-server --web-port 16001
```

**注意**: 如果遇到静态资源404错误（SVG图标无法加载），请参考[故障排查 - Flutter Web静态资源404问题](#flutter-web静态资源404问题)部分的解决方案。

### CORS跨域解决方案

#### **代理服务器架构**
- **代理服务器**: `http://127.0.0.1:3001`
- **Flutter应用**: `http://localhost:16001`  
- **后端API**: `http://47.106.218.81:20080`

#### **工作原理**
```
Flutter Web (16001) → CORS代理 (3001) → 后端API (20080)
```

#### **核心特性**
- ✅ **自动CORS头部处理**: 完全移除后端CORS头部，设置正确的代理头部
- ✅ **智能Origin验证**: 支持localhost和127.0.0.1多种地址格式
- ✅ **OPTIONS预检处理**: 自动处理浏览器CORS预检请求
- ✅ **错误处理与日志**: 完整的请求日志和错误处理机制

#### **代理配置** (`proxy.js`)
使用http-proxy-middleware v3语法，关键配置：
```javascript
// 正确的v3事件语法
on: {
  proxyRes: (proxyRes, req, res) => {
    // 清理后端CORS头部，设置代理CORS头部
  }
}
```

### 传统启动方式（不推荐）

#### Chrome禁用CORS启动（仅开发测试用）
```bash
# 启动Chrome（禁用CORS检查）
./scripts/start_chrome_no_cors.sh
```

**注意**: 此方法存在安全风险，仅用于开发测试，生产环境必须使用代理方案。

### 环境验证与测试

#### **服务状态检查**
```bash
# 检查代理服务器健康状态
curl http://127.0.0.1:3001/health

# 检查Flutter应用访问
open http://localhost:16001
```

#### **API连接测试**
```bash
# 通过代理测试登录API
curl -X POST http://127.0.0.1:3001/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -H "Origin: http://localhost:16001" \
  -d '{"identifier":"admin","password":"Admin123@","remember_me":false}'
```

### 测试登录
- **用户名**: admin
- **密码**: Admin123@
- **API端点**: 通过代理 `http://127.0.0.1:3001/api/v1/auth/login`
- **预期响应**: 成功返回access_token和用户信息

### 科技商务设计系统验证 🎨

#### 快速集成指南
1. **配置主题**: 在main.dart中配置TechThemeSystem双主题
2. **组件替换**: Card → TechCard, Button → TechButton
3. **间距统一**: 使用TechThemeSystem.spacing替代硬编码
4. **色彩规范**: 使用主题色彩而非自定义颜色
5. **响应式**: 验证移动端、平板、桌面适配效果

#### 设计验证清单
- [ ] 主题系统正确配置，支持明暗切换
- [ ] TechCard组件替换传统Card
- [ ] MetricDisplay正确展示KPI数据
- [ ] TechButton多变体按钮工作正常
- [ ] 间距使用设计系统标准值
- [ ] 深色模式显示正常
- [ ] 响应式布局适配正确
- [ ] 可访问性对比度达标

#### 预期效果
- **扁平化设计**: 无装饰元素，突出内容本身
- **科技商务风格**: 专业、数据导向的企业级视觉
- **OKLCH配色**: 科学色彩空间，确保视觉一致性
- **明暗双主题**: 完整的Light/Dark模式体验
- **4px基准间距**: 精确的视觉节奏和层次

#### 快速开始
```bash
# 1. 查看设计系统文档
open lib/design/ui_specification.dart

# 2. 查看集成指南  
open lib/design/integration_guide.dart

# 3. 启动应用验证效果
flutter run -d chrome --web-port 16001
```

### 多语言测试
1. 在侧边栏选择语言
2. 验证界面文本切换
3. 测试所有界面的翻译完整性

## 故障排查

### Flutter Web静态资源404问题

#### **问题**: SVG图标和静态资源返回404错误
**现象**: 
- SVG文件无法加载: `http://localhost:16001/assets/assets/icons/Figma_file.svg` 返回404
- 浏览器控制台显示资源加载失败
- 应用界面图标无法正常显示

**根本原因**: Flutter Web开发服务器状态异常，资源映射失效

**解决方案**:
```bash
# 1. 停止当前Flutter Web服务器
pkill -f "flutter run.*web-server.*16001"

# 2. 重新启动Flutter Web服务器  
flutter run -d web-server --web-port 16001

# 3. 验证资源访问
curl -I "http://localhost:16001/assets/assets/icons/Figma_file.svg"
```

**关键发现**:
- ✅ **双重assets路径是正确的**: `assets/assets/icons/` 是Flutter Web标准路径结构
- ✅ **pubspec.yaml配置无误**: `assets: - assets/icons/` 配置正确
- ✅ **文件系统结构正确**: `build/web/assets/assets/icons/` 构建输出正确
- ❌ **开发服务器状态问题**: 长时间运行导致资源映射异常

**预防措施**:
- 定期重启Flutter Web开发服务器，特别是长时间开发后
- 使用热重载(`r`)而不是完全重启来提高开发效率
- 遇到静态资源问题时优先考虑服务器重启，而非代码修改

### CORS相关问题

#### **问题**: "Access-Control-Allow-Origin重复值"
**原因**: http-proxy-middleware版本语法问题或后端CORS头部未正确清理
**解决方案**: 
```javascript
// 确保使用v3正确语法
on: {
  proxyRes: (proxyRes, req, res) => {
    // 清理所有后端CORS头部
    Object.keys(proxyRes.headers).forEach(key => {
      if (key.toLowerCase().startsWith('access-control-')) {
        delete proxyRes.headers[key];
      }
    });
  }
}
```

#### **问题**: 代理服务器无法启动
**检查步骤**:
1. 确认端口3001未被占用: `lsof -i :3001`
2. 检查Node.js和npm版本: `node -v && npm -v`
3. 重新安装依赖: `rm -rf node_modules && npm install`

#### **问题**: Flutter Web应用无法访问API
**检查步骤**:
1. 确认代理服务器正在运行
2. 检查Flutter应用的API配置是否指向代理地址
3. 查看浏览器开发者工具的Network标签页排查请求

### 性能优化建议

#### **开发环境**
- 使用热重载: `flutter run -d web-server --web-port 16001`
- 启用详细日志: 代理服务器已集成完整的请求日志

#### **生产部署**
- 后端配置正确的CORS头部
- 使用CDN加速Flutter Web资源
- 启用Gzip压缩和缓存策略

## macOS平台专门优化 🍎

### 核心特性
- **原生macOS支持**: 集成macos_ui和macos_window_utils包
- **系统字体优化**: 使用.AppleSystemUIFont避免网络字体加载问题
- **直连API**: 绕过CORS代理，直接连接后端API (http://47.106.218.81:20080)
- **原生窗口管理**: 透明标题栏和macOS窗口工具集成

### macOS启动脚本
```bash
# 使用macOS专门启动脚本
./scripts/start_macos_dev.sh

# 或手动启动
flutter clean
flutter pub get
cd macos && pod install && cd ..
flutter run -d macos --debug
```

### macOS特定配置
- **最低版本**: macOS 10.14.6
- **Podfile**: 更新部署目标至10.14.6支持macos_window_utils
- **网络配置**: 
  - 连接超时: 30秒
  - 空闲超时: 15秒  
  - 强制直连: `client.findProxy = (uri) => 'DIRECT'`
  - 允许自签名证书（开发模式）

### macOS字体系统
- **主字体**: .AppleSystemUIFont (Apple系统UI字体)
- **回退策略**: 网络字体加载失败时自动使用系统字体
- **性能**: 避免Google Fonts网络请求，提升启动速度

### macOS窗口集成
```swift
// MainFlutterWindow.swift 已配置
import macos_window_utils

MainFlutterWindowManipulator.start(mainFlutterWindow: self)
```

### macOS与Web版本差异
| 特性 | macOS版本 | Web版本 |
|------|-----------|---------|
| API连接 | 直连 (47.106.218.81:20080) | CORS代理 (127.0.0.1:3001) |
| 字体系统 | Apple系统字体 | Google Fonts |
| 网络配置 | 直连，禁用代理 | 通过代理服务器 |
| 窗口管理 | 原生macOS窗口 | 浏览器窗口 |

### 验证macOS优化
运行macOS应用后，控制台应显示:
```
flutter: [AdminApp] [INFO] macOS Development mode: Direct API connection configured
flutter: [AdminApp] [INFO] Cookie jar initialized successfully
```

这表明macOS专门的网络和字体优化已生效。