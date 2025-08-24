import 'package:flutter/material.dart';
import 'theme/tailwind_design_tokens.dart';

/// 🎨 Tailwind CSS v4 纯净系统接口
/// 完全符合官方标准，无兼容层，最先进的设计令牌系统
/// 
/// 核心原则:
/// ✅ 直接使用 Tailwind 官方设计令牌
/// ✅ 无兼容层，性能最优
/// ✅ 强制最佳实践
/// ✅ utility-first 设计理念

// ============================================================================
// 🎯 主接口：直接暴露 Tailwind 设计令牌
// ============================================================================

/// 💡 Tailwind 设计令牌系统访问器
/// 示例: TW.space('4'), TW.colorBlue[600], TW.textSize('lg')
class TW {
  /// 获取间距值 - 模拟 p-4, m-6 等
  static double space(String token) => TailwindDesignTokens.space(token);
  
  /// 获取圆角值 - 模拟 rounded-lg, rounded-xl 等
  static double radius(String token) => TailwindDesignTokens.radius(token);
  
  /// 获取阴影值 - 模拟 shadow-sm, shadow-lg 等
  static List<BoxShadow> shadow(String token) => TailwindDesignTokens.shadow(token);
  
  /// 获取文字大小 - 模拟 text-sm, text-lg 等
  static double textSize(String token) => TailwindDesignTokens.textSize(token);
  
  /// 获取字重 - 模拟 font-medium, font-bold 等
  static FontWeight fontWeight(String token) => TailwindDesignTokens.fontWeight(token);
  
  /// 获取断点值 - 模拟响应式断点
  static double breakpoint(String token) => TailwindDesignTokens.breakpoint(token);
  
  // 色彩系统访问器
  static Map<int, Color> get colorSlate => TailwindDesignTokens.colorSlate;
  static Map<int, Color> get colorGray => TailwindDesignTokens.colorGray;
  static Map<int, Color> get colorBlue => TailwindDesignTokens.colorBlue;
  static Map<int, Color> get colorGreen => TailwindDesignTokens.colorGreen;
  static Map<int, Color> get colorRed => TailwindDesignTokens.colorRed;
  static Map<int, Color> get colorOrange => TailwindDesignTokens.colorOrange;
  static Map<int, Color> get colorCyan => TailwindDesignTokens.colorCyan;
}

/// 🎨 语义令牌访问器
/// 示例: Semantic.primary, Semantic.getColor(context, ...)
class Semantic {
  // 主色调
  static Color get primary => TailwindSemanticTokens.primary;
  static Color get primaryHover => TailwindSemanticTokens.primaryHover;
  static Color get primaryLight => TailwindSemanticTokens.primaryLight;
  
  // 功能色系
  static Color get success => TailwindSemanticTokens.success;
  static Color get warning => TailwindSemanticTokens.warning;
  static Color get error => TailwindSemanticTokens.error;
  static Color get info => TailwindSemanticTokens.info;
  
  // 中性色系
  static Color get surface => TailwindSemanticTokens.surface;
  static Color get surfaceVariant => TailwindSemanticTokens.surfaceVariant;
  static Color get border => TailwindSemanticTokens.border;
  static Color get onSurface => TailwindSemanticTokens.onSurface;
  static Color get onSurfaceVariant => TailwindSemanticTokens.onSurfaceVariant;
  
  // 暗色主题
  static Color get darkPrimary => TailwindSemanticTokens.darkPrimary;
  static Color get darkSuccess => TailwindSemanticTokens.darkSuccess;
  static Color get darkWarning => TailwindSemanticTokens.darkWarning;
  static Color get darkError => TailwindSemanticTokens.darkError;
  static Color get darkSurface => TailwindSemanticTokens.darkSurface;
  static Color get darkSurfaceVariant => TailwindSemanticTokens.darkSurfaceVariant;
  static Color get darkBorder => TailwindSemanticTokens.darkBorder;
  static Color get darkOnSurface => TailwindSemanticTokens.darkOnSurface;
  static Color get darkOnSurfaceVariant => TailwindSemanticTokens.darkOnSurfaceVariant;
  
  // 工具方法
  static Color getColor(BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) => TailwindSemanticTokens.getColor(context, 
    lightColor: lightColor, darkColor: darkColor);
}

// ============================================================================
// 🌈 语义颜色快速访问器
// ============================================================================

/// 主要业务色 - blue-600
Color get primaryColor => TW.colorBlue[600]!;

/// 成功状态色 - green-500
Color get successColor => TW.colorGreen[500]!;

/// 警告状态色 - orange-500
Color get warningColor => TW.colorOrange[500]!;

/// 错误状态色 - red-500
Color get errorColor => TW.colorRed[500]!;

/// 信息状态色 - cyan-500
Color get infoColor => TW.colorCyan[500]!;

// ============================================================================
// 📐 标准间距快速访问器
// ============================================================================

/// 标准内边距 - p-4 (16px)
double get defaultPadding => TW.space('4');

// ============================================================================
// ⏱️ 动画与交互系统
// ============================================================================

/// 动画时长
class TWDuration {
  static const instant = Duration.zero;                    // 0ms
  static const fast = Duration(milliseconds: 150);        // 150ms - 微交互
  static const normal = Duration(milliseconds: 300);      // 300ms - 标准交互
  static const slow = Duration(milliseconds: 500);        // 500ms - 复杂交互
}

/// 动画曲线
class TWCurves {
  static const easeOut = Cubic(0.0, 0.0, 0.2, 1.0);      // 快入慢出
  static const easeIn = Cubic(0.4, 0.0, 1.0, 1.0);       // 慢入快出
  static const easeInOut = Cubic(0.4, 0.0, 0.2, 1.0);    // 平滑过渡
}

// ============================================================================
// 📱 响应式工具函数
// ============================================================================

/// 响应式工具类 - 基于 Tailwind 断点
class Responsive {
  /// 检查屏幕尺寸
  static bool isMobile(BuildContext context) => 
      MediaQuery.of(context).size.width < TW.breakpoint('md');
      
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= TW.breakpoint('md') && width < TW.breakpoint('lg');
  }
  
  static bool isDesktop(BuildContext context) => 
      MediaQuery.of(context).size.width >= TW.breakpoint('lg');

  /// 响应式列数 - sm:1 md:2 lg:3 xl:4
  static int cols(BuildContext context, {
    int sm = 1,    // mobile
    int md = 2,    // tablet  
    int lg = 3,    // desktop
    int xl = 4,    // wide
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= TW.breakpoint('xl')) return xl;
    if (width >= TW.breakpoint('lg')) return lg;
    if (width >= TW.breakpoint('md')) return md;
    return sm;
  }
  
  /// 响应式间距 - 等同于 gap-4 md:gap-6 lg:gap-8
  static double gap(BuildContext context, {
    String sm = '4',    // 16px
    String md = '6',    // 24px
    String lg = '8',    // 32px
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= TW.breakpoint('lg')) return TW.space(lg);
    if (width >= TW.breakpoint('md')) return TW.space(md);
    return TW.space(sm);
  }
}

// ============================================================================
// 🔤 常用文字样式快速构建器
// ============================================================================

/// 文字样式快速构建器 - 基于 Tailwind 文字系统
class TextStyles {
  /// 大标题 - text-4xl font-bold
  static TextStyle h1(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('4xl'),
    fontWeight: TW.fontWeight('bold'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[100]
        : TW.colorGray[900]),
  );
  
  /// 中标题 - text-2xl font-semibold
  static TextStyle h2(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('2xl'),
    fontWeight: TW.fontWeight('semibold'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[100]
        : TW.colorGray[900]),
  );
  
  /// 小标题 - text-xl font-medium
  static TextStyle h3(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('xl'),
    fontWeight: TW.fontWeight('medium'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[200]
        : TW.colorGray[800]),
  );
  
  /// 正文 - text-base
  static TextStyle body(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('base'),
    fontWeight: TW.fontWeight('normal'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[300]
        : TW.colorGray[700]),
  );
  
  /// 小字 - text-sm
  static TextStyle small(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('sm'),
    fontWeight: TW.fontWeight('normal'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[400]
        : TW.colorGray[600]),
  );
  
  /// 标注 - text-xs
  static TextStyle caption(BuildContext context, {Color? color}) => TextStyle(
    fontSize: TW.textSize('xs'),
    fontWeight: TW.fontWeight('normal'),
    color: color ?? (Theme.of(context).brightness == Brightness.dark 
        ? TW.colorGray[500]
        : TW.colorGray[500]),
  );
}

// ============================================================================
// 🎨 主题感知颜色工具
// ============================================================================

/// 主题感知颜色工具 - 自动处理明暗模式
class ThemeColors {
  /// 获取主题感知的文字颜色
  static Color text(BuildContext context, {int shade = 700}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark 
        ? TW.colorGray[1000 - shade]!  // 暗模式反转
        : TW.colorGray[shade]!;
  }
  
  /// 获取主题感知的表面颜色
  static Color surface(BuildContext context, {int shade = 50}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark 
        ? TW.colorGray[950 - shade]!   // 暗模式使用深色
        : TW.colorGray[shade]!;
  }
  
  /// 获取主题感知的边框颜色
  static Color border(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark 
        ? TW.colorGray[800]!
        : TW.colorGray[200]!;
  }
}

// ============================================================================
// 💡 使用示例和最佳实践
// ============================================================================

/// 📖 最佳实践示例:
/// 
/// 🎯 间距: TW.space('4')  // 16px
/// 🎨 颜色: TW.colorBlue[600]  // #2563EB
/// 📝 文字: TW.textSize('lg')  // 18px
/// 📱 响应: Responsive.isMobile(context)
/// 🔤 样式: TextStyles.h1(context)
/// 🌗 主题: ThemeColors.text(context)