import 'package:flutter/material.dart';
import 'theme/tailwind_colors.dart';

// ============================================================================
// 统一配色系统 - 仅使用Tailwind CSS标准
// ============================================================================

/// 主要业务色 - 直接使用Tailwind Blue-600
const primaryColor = TailwindColors.blue600;

/// 成功状态色 - 直接使用Tailwind Green-500  
const successColor = TailwindColors.green500;

/// 警告状态色 - 直接使用Tailwind Orange-500
const warningColor = TailwindColors.orange500;

/// 错误状态色 - 直接使用Tailwind Red-500
const errorColor = TailwindColors.red500;

/// 信息状态色 - 直接使用Tailwind Cyan-500
const infoColor = TailwindColors.cyan500;

// ============================================================================
// 统一间距系统 - 基于4px标准
// ============================================================================

/// 标准间距 - 16px (Tailwind的4单位)
const defaultPadding = TechSpacing.md;

/// 间距系统 - 基于4px基准
class TechSpacing {
  const TechSpacing();
  
  static const double px = 1.0;    // 1px - 细线
  static const double xs = 4.0;    // 1 unit - 微间距  
  static const double sm = 8.0;    // 2 units - 小间距
  static const double md = 16.0;   // 4 units - 标准间距
  static const double lg = 24.0;   // 6 units - 大间距
  static const double xl = 32.0;   // 8 units - 超大间距
  static const double xxl = 48.0;  // 12 units - 巨大间距
  static const double xxxl = 64.0; // 16 units - 最大间距
}

// ============================================================================
// 圆角系统
// ============================================================================

class TechRadius {
  const TechRadius();
  
  static const double none = 0.0;      // rounded-none
  static const double xs = 2.0;        // rounded-xs
  static const double sm = 4.0;        // rounded-sm
  static const double md = 6.0;        // rounded-md
  static const double lg = 8.0;        // rounded-lg
  static const double xl = 12.0;       // rounded-xl
  static const double xxl = 16.0;      // rounded-2xl
  static const double xxxl = 24.0;     // rounded-3xl
  static const double full = 9999.0;   // rounded-full
}

// ============================================================================
// 阴影系统
// ============================================================================

class TechShadow {
  const TechShadow();
  
  static const List<BoxShadow> none = []; // shadow-none
  
  static const List<BoxShadow> xs = [    // shadow-xs
    BoxShadow(
      color: Color(0x0A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];
  
  static const List<BoxShadow> sm = [    // shadow-sm
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];
  
  static const List<BoxShadow> md = [    // shadow-md
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
  ];
}

// ============================================================================
// 动画系统
// ============================================================================

class TechDuration {
  const TechDuration();
  
  static const Duration instant = Duration.zero;           // 瞬间
  static const Duration fast = Duration(milliseconds: 150); // 快速
  static const Duration normal = Duration(milliseconds: 300); // 标准
  static const Duration slow = Duration(milliseconds: 500);  // 缓慢
}

class TechCurves {
  const TechCurves();
  
  static const Cubic easeOut = Cubic(0.0, 0.0, 0.2, 1.0);      // ease-out
  static const Cubic easeIn = Cubic(0.4, 0.0, 1.0, 1.0);       // ease-in
  static const Cubic easeInOut = Cubic(0.4, 0.0, 0.2, 1.0);    // ease-in-out
}

// ============================================================================
// 响应式断点
// ============================================================================

class TechBreakpoints {
  const TechBreakpoints();
  
  static const double mobile = 640.0;   // sm - 移动端
  static const double tablet = 768.0;   // md - 平板
  static const double laptop = 1024.0;  // lg - 笔记本
  static const double desktop = 1280.0; // xl - 桌面
  static const double wide = 1536.0;    // 2xl - 宽屏
}

// ============================================================================
// 排版系统
// ============================================================================

class TechTypography {
  const TechTypography();
  
  // 字体大小 (基于Tailwind比例系统)
  static const double displayLarge = 56.0;    // text-6xl - 主展示标题
  static const double displayMedium = 48.0;   // text-5xl - 次展示标题
  static const double displaySmall = 36.0;    // text-4xl - 小展示标题
  
  static const double headlineLarge = 32.0;   // text-3xl - 大标题
  static const double headlineMedium = 24.0;  // text-2xl - 中标题
  static const double headlineSmall = 20.0;   // text-xl - 小标题
  
  static const double titleLarge = 18.0;      // text-lg - 大标题
  static const double titleMedium = 16.0;     // text-base - 中标题
  static const double titleSmall = 14.0;      // text-sm - 小标题
  
  static const double bodyLarge = 16.0;       // text-base - 大正文
  static const double bodyMedium = 14.0;      // text-sm - 中正文
  static const double bodySmall = 12.0;       // text-xs - 小正文
  
  static const double labelLarge = 14.0;      // text-sm - 大标签
  static const double labelMedium = 12.0;     // text-xs - 中标签
  static const double labelSmall = 10.0;      // text-2xs - 小标签

  // 字重
  static const FontWeight thin = FontWeight.w100;        // font-thin
  static const FontWeight extraLight = FontWeight.w200;  // font-extralight
  static const FontWeight light = FontWeight.w300;       // font-light
  static const FontWeight normal = FontWeight.w400;      // font-normal
  static const FontWeight medium = FontWeight.w500;      // font-medium
  static const FontWeight semiBold = FontWeight.w600;    // font-semibold
  static const FontWeight bold = FontWeight.w700;        // font-bold
  static const FontWeight extraBold = FontWeight.w800;   // font-extrabold
  static const FontWeight black = FontWeight.w900;       // font-black

  // 行高
  static const double lineHeightTight = 1.25;   // leading-tight
  static const double lineHeightSnug = 1.375;   // leading-snug  
  static const double lineHeightNormal = 1.5;   // leading-normal
  static const double lineHeightRelaxed = 1.625; // leading-relaxed
  static const double lineHeightLoose = 2.0;    // leading-loose

  // 字间距
  static const double letterSpacingTighter = -0.05; // tracking-tighter
  static const double letterSpacingTight = -0.025;  // tracking-tight
  static const double letterSpacingNormal = 0.0;    // tracking-normal
  static const double letterSpacingWide = 0.025;    // tracking-wide
  static const double letterSpacingWider = 0.05;    // tracking-wider
  static const double letterSpacingWidest = 0.1;    // tracking-widest
}