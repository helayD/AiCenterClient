import 'package:flutter/material.dart';

/// Tailwind CSS v4 设计令牌系统
/// 完全符合官方 @theme 指令标准和 OKLCH 色彩空间规范
/// 
/// 特性:
/// - 官方 OKLCH 数值，确保感知均匀性
/// - --spacing 基准计算系统 (0.25rem = 4px)
/// - 标准变量命名约定 --color-*-*, --spacing-*, --radius-*
/// - 设计令牌自动生成 utility 类的模拟实现
/// 
/// 参考: https://tailwindcss.com/docs/theme

class TailwindDesignTokens {
  const TailwindDesignTokens();

  // ============================================================================
  // 基础设计令牌 - 等同于 @theme 指令
  // ============================================================================

  /// 间距基准 - 等同于 --spacing: 0.25rem
  static const double spacingBase = 4.0; // 0.25rem = 4px
  
  /// 间距计算函数 - 等同于 calc(var(--spacing) * n)
  static double spacing(double multiplier) => spacingBase * multiplier;

  // ============================================================================
  // OKLCH 色彩系统 - 官方标准数值
  // ============================================================================
  
  /// Slate色彩系列 - 等同于 --color-slate-*
  static const Map<int, Color> colorSlate = {
    50: Color(0xFFF8FAFC),   // oklch(0.984 0.003 247.858)
    100: Color(0xFFF1F5F9),  // oklch(0.968 0.007 247.896) 
    200: Color(0xFFE2E8F0),  // oklch(0.929 0.013 255.508)
    300: Color(0xFFCBD5E1),  // oklch(0.869 0.022 252.894)
    400: Color(0xFF94A3B8),  // oklch(0.704 0.04 256.788)
    500: Color(0xFF64748B),  // oklch(0.554 0.046 257.417)
    600: Color(0xFF475569),  // oklch(0.446 0.043 257.281)
    700: Color(0xFF334155),  // oklch(0.372 0.044 257.287)
    800: Color(0xFF1E293B),  // oklch(0.279 0.041 260.031)
    900: Color(0xFF0F172A),  // oklch(0.208 0.042 265.755)
    950: Color(0xFF020617),  // oklch(0.129 0.042 264.695)
  };

  /// Gray色彩系列 - 等同于 --color-gray-*
  static const Map<int, Color> colorGray = {
    50: Color(0xFFF9FAFB),   // oklch(0.985 0.002 247.839)
    100: Color(0xFFF3F4F6),  // oklch(0.967 0.003 264.542)
    200: Color(0xFFE5E7EB),  // oklch(0.928 0.006 264.531)
    300: Color(0xFFD1D5DB),  // oklch(0.872 0.01 258.338)
    400: Color(0xFF9CA3AF),  // oklch(0.707 0.022 261.325)
    500: Color(0xFF6B7280),  // oklch(0.551 0.027 264.364)
    600: Color(0xFF4B5563),  // oklch(0.446 0.03 256.802)
    700: Color(0xFF374151),  // oklch(0.373 0.034 259.733)
    800: Color(0xFF1F2937),  // oklch(0.278 0.033 256.848)
    900: Color(0xFF111827),  // oklch(0.21 0.034 264.665)
    950: Color(0xFF030712),  // oklch(0.13 0.028 261.692)
  };

  /// Blue色彩系列 - 等同于 --color-blue-*
  static const Map<int, Color> colorBlue = {
    50: Color(0xFFEFF6FF),   // oklch(0.97 0.014 254.604)
    100: Color(0xFFDBEAFE),  // oklch(0.932 0.032 255.585)
    200: Color(0xFFBFDBFE),  // oklch(0.882 0.059 254.128)
    300: Color(0xFF93C5FD),  // oklch(0.809 0.105 251.813)
    400: Color(0xFF60A5FA),  // oklch(0.707 0.165 254.624)
    500: Color(0xFF3B82F6),  // oklch(0.623 0.214 259.815)
    600: Color(0xFF2563EB),  // oklch(0.546 0.245 262.881)
    700: Color(0xFF1D4ED8),  // oklch(0.488 0.243 264.376)
    800: Color(0xFF1E40AF),  // oklch(0.424 0.199 265.638)
    900: Color(0xFF1E3A8A),  // oklch(0.379 0.146 265.522)
    950: Color(0xFF172554),  // oklch(0.282 0.091 267.935)
  };

  /// Green色彩系列 - 等同于 --color-green-*
  static const Map<int, Color> colorGreen = {
    50: Color(0xFFF0FDF4),   // oklch(0.982 0.018 155.826)
    100: Color(0xFFDCFCE7),  // oklch(0.962 0.044 156.743)
    200: Color(0xFFBBF7D0),  // oklch(0.925 0.084 155.995)
    300: Color(0xFF86EFAC),  // oklch(0.871 0.15 154.449)
    400: Color(0xFF4ADE80),  // oklch(0.792 0.209 151.711)
    500: Color(0xFF22C55E),  // oklch(0.723 0.219 149.579)
    600: Color(0xFF16A34A),  // oklch(0.627 0.194 149.214)
    700: Color(0xFF15803D),  // oklch(0.527 0.154 150.069)
    800: Color(0xFF166534),  // oklch(0.448 0.119 151.328)
    900: Color(0xFF14532D),  // oklch(0.393 0.095 152.535)
    950: Color(0xFF052E16),  // oklch(0.266 0.065 152.934)
  };

  /// Red色彩系列 - 等同于 --color-red-*
  static const Map<int, Color> colorRed = {
    50: Color(0xFFFEF2F2),   // oklch(0.971 0.013 17.38)
    100: Color(0xFFFEE2E2),  // oklch(0.936 0.032 17.717)
    200: Color(0xFFFECACA),  // oklch(0.885 0.062 18.334)
    300: Color(0xFFFCA5A5),  // oklch(0.808 0.114 19.571)
    400: Color(0xFFF87171),  // oklch(0.704 0.191 22.216)
    500: Color(0xFFEF4444),  // oklch(0.637 0.237 25.331)
    600: Color(0xFFDC2626),  // oklch(0.577 0.245 27.325)
    700: Color(0xFFB91C1C),  // oklch(0.505 0.213 27.518)
    800: Color(0xFF991B1B),  // oklch(0.444 0.177 26.899)
    900: Color(0xFF7F1D1D),  // oklch(0.396 0.141 25.723)
    950: Color(0xFF450A0A),  // oklch(0.258 0.092 26.042)
  };

  /// Orange色彩系列 - 等同于 --color-orange-*
  static const Map<int, Color> colorOrange = {
    50: Color(0xFFFFF7ED),   // oklch(0.98 0.016 73.684)
    100: Color(0xFFFFEDD5),  // oklch(0.954 0.038 75.164)
    200: Color(0xFFFED7AA),  // oklch(0.901 0.076 70.697)
    300: Color(0xFFFDBA74),  // oklch(0.837 0.128 66.29)
    400: Color(0xFFFB923C),  // oklch(0.75 0.183 55.934)
    500: Color(0xFFF97316),  // oklch(0.705 0.213 47.604)
    600: Color(0xFFEA580C),  // oklch(0.646 0.222 41.116)
    700: Color(0xFFC2410C),  // oklch(0.553 0.195 38.402)
    800: Color(0xFF9A3412),  // oklch(0.47 0.157 37.304)
    900: Color(0xFF7C2D12),  // oklch(0.408 0.123 38.172)
    950: Color(0xFF431407),  // oklch(0.266 0.079 36.259)
  };

  /// Cyan色彩系列 - 等同于 --color-cyan-*
  static const Map<int, Color> colorCyan = {
    50: Color(0xFFECFEFF),   // oklch(0.984 0.019 200.873)
    100: Color(0xFFCFFAFE),  // oklch(0.956 0.045 203.388)
    200: Color(0xFFA5F3FC),  // oklch(0.917 0.08 205.041)
    300: Color(0xFF67E8F9),  // oklch(0.865 0.127 207.078)
    400: Color(0xFF22D3EE),  // oklch(0.789 0.154 211.53)
    500: Color(0xFF06B6D4),  // oklch(0.715 0.143 215.221)
    600: Color(0xFF0891B2),  // oklch(0.609 0.126 221.723)
    700: Color(0xFF0E7490),  // oklch(0.52 0.105 223.128)
    800: Color(0xFF155E75),  // oklch(0.45 0.085 224.283)
    900: Color(0xFF164E63),  // oklch(0.398 0.07 227.392)
    950: Color(0xFF083344),  // oklch(0.302 0.056 229.695)
  };

  // ============================================================================
  // 间距系统 - 等同于 Tailwind 间距 utility 类
  // ============================================================================
  
  /// 间距令牌 - 等同于 p-*, m-*, gap-* 等 utility 类
  static final Map<String, double> spacingTokens = {
    'px': 1.0,              // px
    '0': 0.0,               // 0
    '0.5': spacing(0.5),    // 0.5 * 4px = 2px
    '1': spacing(1),        // 1 * 4px = 4px  
    '1.5': spacing(1.5),    // 1.5 * 4px = 6px
    '2': spacing(2),        // 2 * 4px = 8px
    '2.5': spacing(2.5),    // 2.5 * 4px = 10px
    '3': spacing(3),        // 3 * 4px = 12px
    '3.5': spacing(3.5),    // 3.5 * 4px = 14px
    '4': spacing(4),        // 4 * 4px = 16px
    '5': spacing(5),        // 5 * 4px = 20px
    '6': spacing(6),        // 6 * 4px = 24px
    '7': spacing(7),        // 7 * 4px = 28px
    '8': spacing(8),        // 8 * 4px = 32px
    '9': spacing(9),        // 9 * 4px = 36px
    '10': spacing(10),      // 10 * 4px = 40px
    '11': spacing(11),      // 11 * 4px = 44px
    '12': spacing(12),      // 12 * 4px = 48px
    '14': spacing(14),      // 14 * 4px = 56px
    '16': spacing(16),      // 16 * 4px = 64px
    '20': spacing(20),      // 20 * 4px = 80px
    '24': spacing(24),      // 24 * 4px = 96px
  };

  // ============================================================================
  // 圆角系统 - 等同于 --radius-*
  // ============================================================================
  
  /// 圆角令牌 - 等同于 rounded-* utility 类
  static const Map<String, double> radiusTokens = {
    'none': 0.0,      // rounded-none
    'sm': 2.0,        // rounded-sm
    '': 4.0,          // rounded (默认)
    'md': 6.0,        // rounded-md  
    'lg': 8.0,        // rounded-lg
    'xl': 12.0,       // rounded-xl
    '2xl': 16.0,      // rounded-2xl
    '3xl': 24.0,      // rounded-3xl
    'full': 9999.0,   // rounded-full
  };

  // ============================================================================
  // 阴影系统 - 等同于 --shadow-*
  // ============================================================================
  
  /// 阴影令牌 - 等同于 shadow-* utility 类
  static const Map<String, List<BoxShadow>> shadowTokens = {
    'none': [],
    'sm': [
      BoxShadow(
        color: Color(0x0D000000), // rgb(0 0 0 / 0.05)
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
    ],
    '': [
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1)
        offset: Offset(0, 1),
        blurRadius: 3,
        spreadRadius: 0,
      ),
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1) 
        offset: Offset(0, 1),
        blurRadius: 2,
        spreadRadius: -1,
      ),
    ],
    'md': [
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1)
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -1,
      ),
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1)
        offset: Offset(0, 2),
        blurRadius: 4,
        spreadRadius: -2,
      ),
    ],
    'lg': [
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1)
        offset: Offset(0, 10),
        blurRadius: 15,
        spreadRadius: -3,
      ),
      BoxShadow(
        color: Color(0x1A000000), // rgb(0 0 0 / 0.1)
        offset: Offset(0, 4),
        blurRadius: 6,
        spreadRadius: -4,
      ),
    ],
  };

  // ============================================================================
  // 文字系统 - 等同于 --text-* 和 --font-*
  // ============================================================================
  
  /// 文字大小令牌 - 等同于 text-* utility 类
  static const Map<String, double> textSizeTokens = {
    'xs': 12.0,       // text-xs
    'sm': 14.0,       // text-sm
    'base': 16.0,     // text-base
    'lg': 18.0,       // text-lg
    'xl': 20.0,       // text-xl
    '2xl': 24.0,      // text-2xl
    '3xl': 30.0,      // text-3xl
    '4xl': 36.0,      // text-4xl
    '5xl': 48.0,      // text-5xl
    '6xl': 60.0,      // text-6xl
    '7xl': 72.0,      // text-7xl
    '8xl': 96.0,      // text-8xl
    '9xl': 128.0,     // text-9xl
  };

  /// 字重令牌 - 等同于 font-* utility 类
  static const Map<String, FontWeight> fontWeightTokens = {
    'thin': FontWeight.w100,        // font-thin
    'extralight': FontWeight.w200,  // font-extralight
    'light': FontWeight.w300,       // font-light
    'normal': FontWeight.w400,      // font-normal
    'medium': FontWeight.w500,      // font-medium
    'semibold': FontWeight.w600,    // font-semibold
    'bold': FontWeight.w700,        // font-bold
    'extrabold': FontWeight.w800,   // font-extrabold
    'black': FontWeight.w900,       // font-black
  };

  // ============================================================================
  // 响应式断点 - 等同于 --breakpoint-*
  // ============================================================================
  
  /// 断点令牌 - 等同于 Tailwind 响应式断点
  static const Map<String, double> breakpointTokens = {
    'sm': 640.0,    // sm: @media (min-width: 640px)
    'md': 768.0,    // md: @media (min-width: 768px) 
    'lg': 1024.0,   // lg: @media (min-width: 1024px)
    'xl': 1280.0,   // xl: @media (min-width: 1280px)
    '2xl': 1536.0,  // 2xl: @media (min-width: 1536px)
  };

  // ============================================================================
  // 便捷访问器 - 模拟 Tailwind utility 类的使用方式
  // ============================================================================

  /// 获取间距值 - 模拟 p-4, m-6 等
  static double space(String token) => spacingTokens[token] ?? 0.0;
  
  /// 获取圆角值 - 模拟 rounded-lg, rounded-xl 等
  static double radius(String token) => radiusTokens[token] ?? 0.0;
  
  /// 获取阴影值 - 模拟 shadow-sm, shadow-lg 等
  static List<BoxShadow> shadow(String token) => shadowTokens[token] ?? [];
  
  /// 获取文字大小 - 模拟 text-sm, text-lg 等
  static double textSize(String token) => textSizeTokens[token] ?? 16.0;
  
  /// 获取字重 - 模拟 font-medium, font-bold 等
  static FontWeight fontWeight(String token) => fontWeightTokens[token] ?? FontWeight.w400;
  
  /// 获取断点值 - 模拟响应式断点
  static double breakpoint(String token) => breakpointTokens[token] ?? 0.0;
}

/// Tailwind 语义色彩系统 - 等同于自定义语义令牌
class TailwindSemanticTokens {
  const TailwindSemanticTokens();
  
  // ============================================================================
  // 明亮主题语义映射 - 等同于 CSS 语义变量
  // ============================================================================
  
  /// 主色调 - 品牌识别色
  static Color get primary => TailwindDesignTokens.colorBlue[600]!;
  static Color get primaryHover => TailwindDesignTokens.colorBlue[700]!;
  static Color get primaryLight => TailwindDesignTokens.colorBlue[100]!;
  
  /// 功能色系 - 状态指示
  static Color get success => TailwindDesignTokens.colorGreen[500]!;
  static Color get warning => TailwindDesignTokens.colorOrange[500]!;
  static Color get error => TailwindDesignTokens.colorRed[500]!;
  static Color get info => TailwindDesignTokens.colorCyan[500]!;
  
  /// 中性色系 - 界面基础
  static Color get surface => TailwindDesignTokens.colorGray[50]!;
  static Color get surfaceVariant => TailwindDesignTokens.colorGray[100]!;
  static Color get border => TailwindDesignTokens.colorGray[200]!;
  static Color get onSurface => TailwindDesignTokens.colorGray[800]!;
  static Color get onSurfaceVariant => TailwindDesignTokens.colorGray[600]!;
  
  // ============================================================================
  // 暗色主题语义映射
  // ============================================================================
  
  /// 暗色主色调
  static Color get darkPrimary => TailwindDesignTokens.colorBlue[400]!;
  static Color get darkSuccess => TailwindDesignTokens.colorGreen[400]!;
  static Color get darkWarning => TailwindDesignTokens.colorOrange[400]!;
  static Color get darkError => TailwindDesignTokens.colorRed[400]!;
  
  /// 暗色中性色系
  static Color get darkSurface => TailwindDesignTokens.colorGray[900]!;
  static Color get darkSurfaceVariant => TailwindDesignTokens.colorGray[800]!;
  static Color get darkBorder => TailwindDesignTokens.colorGray[800]!;
  static Color get darkOnSurface => TailwindDesignTokens.colorGray[100]!;
  static Color get darkOnSurfaceVariant => TailwindDesignTokens.colorGray[400]!;
  
  /// 根据主题获取颜色
  static Color getColor(BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return Theme.of(context).brightness == Brightness.dark ? darkColor : lightColor;
  }
}
