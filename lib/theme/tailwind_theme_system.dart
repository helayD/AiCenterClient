import 'package:flutter/material.dart';
import 'tailwind_design_tokens.dart';

/// Tailwind CSS v4 主题系统
/// 完全符合官方设计令牌标准和 OKLCH 色彩空间规范
/// 
/// 特性:
/// - 完全基于 Tailwind 官方 OKLCH 数值
/// - 统一的明暗双主题支持
/// - Material 3 设计规范兼容
/// - 科技商务风格优化
/// - 完全符合 @theme 指令标准

class TailwindThemeSystem {
  /// 创建明亮主题 - 等同于 Tailwind Light Mode
  static ThemeData get lightTheme => _buildTheme(false);
  
  /// 创建暗色主题 - 等同于 Tailwind Dark Mode  
  static ThemeData get darkTheme => _buildTheme(true);

  static ThemeData _buildTheme(bool isDark) {
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      
      // 配色方案 - 直接使用 Tailwind 语义颜色
      colorScheme: _buildColorScheme(isDark),
      
      // 文字主题 - 基于 Tailwind 文字系统
      textTheme: _buildTextTheme(isDark),
      
      // 组件主题 - 遵循 Tailwind utility 类风格
      cardTheme: _buildCardTheme(isDark),
      elevatedButtonTheme: _buildElevatedButtonTheme(isDark),
      appBarTheme: _buildAppBarTheme(isDark),
      inputDecorationTheme: _buildInputDecorationTheme(isDark),
      dividerTheme: _buildDividerTheme(isDark),
      
      // 背景色 - 使用 Tailwind 背景色系统
      scaffoldBackgroundColor: isDark 
          ? TailwindDesignTokens.colorGray[950]!
          : TailwindDesignTokens.colorGray[50]!,
    );
  }

  /// 构建配色方案 - 等同于 Tailwind 色彩系统
  static ColorScheme _buildColorScheme(bool isDark) {
    if (isDark) {
      return ColorScheme.dark(
        // 主色调系列 - 使用 Tailwind Blue
        primary: TailwindDesignTokens.colorBlue[400]!,      // 暗色主题使用更亮的色调
        onPrimary: TailwindDesignTokens.colorBlue[950]!,
        primaryContainer: TailwindDesignTokens.colorBlue[800]!,
        onPrimaryContainer: TailwindDesignTokens.colorBlue[100]!,
        
        // 次要色系列 - 使用 Tailwind Slate
        secondary: TailwindDesignTokens.colorSlate[400]!,
        onSecondary: TailwindDesignTokens.colorSlate[900]!,
        secondaryContainer: TailwindDesignTokens.colorSlate[800]!,
        onSecondaryContainer: TailwindDesignTokens.colorSlate[200]!,
        
        // 错误色系列 - 使用 Tailwind Red
        error: TailwindDesignTokens.colorRed[400]!,
        onError: TailwindDesignTokens.colorRed[950]!,
        errorContainer: TailwindDesignTokens.colorRed[900]!,
        onErrorContainer: TailwindDesignTokens.colorRed[200]!,
        
        // 表面色系列 - 使用 Tailwind Gray
        surface: TailwindDesignTokens.colorGray[900]!,
        onSurface: TailwindDesignTokens.colorGray[100]!,
        surfaceContainerHighest: TailwindDesignTokens.colorGray[800]!,
        onSurfaceVariant: TailwindDesignTokens.colorGray[400]!,
        
        // 边框和轮廓
        outline: TailwindDesignTokens.colorGray[700]!,
        outlineVariant: TailwindDesignTokens.colorGray[800]!,
        
        // 基础色彩
        shadow: TailwindDesignTokens.colorGray[950]!,
        scrim: TailwindDesignTokens.colorGray[950]!,
        
        // 反色系列
        inverseSurface: TailwindDesignTokens.colorGray[100]!,
        onInverseSurface: TailwindDesignTokens.colorGray[900]!,
        inversePrimary: TailwindDesignTokens.colorBlue[600]!,
      );
    } else {
      return ColorScheme.light(
        // 主色调系列 - 使用 Tailwind Blue
        primary: TailwindDesignTokens.colorBlue[600]!,
        onPrimary: TailwindDesignTokens.colorGray[50]!,
        primaryContainer: TailwindDesignTokens.colorBlue[100]!,
        onPrimaryContainer: TailwindDesignTokens.colorBlue[900]!,
        
        // 次要色系列 - 使用 Tailwind Slate  
        secondary: TailwindDesignTokens.colorSlate[600]!,
        onSecondary: TailwindDesignTokens.colorGray[50]!,
        secondaryContainer: TailwindDesignTokens.colorSlate[100]!,
        onSecondaryContainer: TailwindDesignTokens.colorSlate[900]!,
        
        // 错误色系列 - 使用 Tailwind Red
        error: TailwindDesignTokens.colorRed[600]!,
        onError: TailwindDesignTokens.colorGray[50]!,
        errorContainer: TailwindDesignTokens.colorRed[100]!,
        onErrorContainer: TailwindDesignTokens.colorRed[900]!,
        
        // 表面色系列 - 使用 Tailwind Gray
        surface: TailwindDesignTokens.colorGray[50]!,
        onSurface: TailwindDesignTokens.colorGray[900]!,
        surfaceContainerHighest: TailwindDesignTokens.colorGray[100]!,
        onSurfaceVariant: TailwindDesignTokens.colorGray[600]!,
        
        // 边框和轮廓
        outline: TailwindDesignTokens.colorGray[300]!,
        outlineVariant: TailwindDesignTokens.colorGray[200]!,
        
        // 基础色彩
        shadow: TailwindDesignTokens.colorGray[950]!,
        scrim: TailwindDesignTokens.colorGray[950]!,
        
        // 反色系列
        inverseSurface: TailwindDesignTokens.colorGray[900]!,
        onInverseSurface: TailwindDesignTokens.colorGray[50]!,
        inversePrimary: TailwindDesignTokens.colorBlue[400]!,
      );
    }
  }

  /// 构建文字主题 - 基于 Tailwind 文字系统
  static TextTheme _buildTextTheme(bool isDark) {
    final Color headlineColor = isDark 
        ? TailwindDesignTokens.colorGray[50]!
        : TailwindDesignTokens.colorGray[900]!;
    final Color bodyColor = isDark 
        ? TailwindDesignTokens.colorGray[300]!
        : TailwindDesignTokens.colorGray[700]!;
    final Color captionColor = isDark 
        ? TailwindDesignTokens.colorGray[400]!
        : TailwindDesignTokens.colorGray[500]!;
    
    return TextTheme(
      // 展示级文字 - 等同于 text-6xl, text-5xl, text-4xl
      displayLarge: TextStyle(
        fontSize: TailwindDesignTokens.textSize('6xl'),       // text-6xl = 60px
        fontWeight: TailwindDesignTokens.fontWeight('bold'),  // font-bold = 700
        color: headlineColor,
        letterSpacing: -0.025,                                // tracking-tight
      ),
      displayMedium: TextStyle(
        fontSize: TailwindDesignTokens.textSize('5xl'),       // text-5xl = 48px
        fontWeight: TailwindDesignTokens.fontWeight('bold'),
        color: headlineColor,
        letterSpacing: -0.025,
      ),
      displaySmall: TextStyle(
        fontSize: TailwindDesignTokens.textSize('4xl'),       // text-4xl = 36px
        fontWeight: TailwindDesignTokens.fontWeight('semibold'), // font-semibold = 600
        color: headlineColor,
      ),
      
      // 标题级文字 - 等同于 text-3xl, text-2xl, text-xl
      headlineLarge: TextStyle(
        fontSize: TailwindDesignTokens.textSize('3xl'),       // text-3xl = 30px
        fontWeight: TailwindDesignTokens.fontWeight('semibold'),
        color: headlineColor,
      ),
      headlineMedium: TextStyle(
        fontSize: TailwindDesignTokens.textSize('2xl'),       // text-2xl = 24px
        fontWeight: TailwindDesignTokens.fontWeight('semibold'),
        color: headlineColor,
      ),
      headlineSmall: TextStyle(
        fontSize: TailwindDesignTokens.textSize('xl'),        // text-xl = 20px
        fontWeight: TailwindDesignTokens.fontWeight('medium'), // font-medium = 500
        color: headlineColor,
      ),
      
      // 正文级文字 - 等同于 text-lg, text-base, text-sm
      bodyLarge: TextStyle(
        fontSize: TailwindDesignTokens.textSize('lg'),        // text-lg = 18px
        fontWeight: TailwindDesignTokens.fontWeight('normal'), // font-normal = 400
        color: bodyColor,
        height: 1.625,                                         // leading-relaxed
      ),
      bodyMedium: TextStyle(
        fontSize: TailwindDesignTokens.textSize('base'),       // text-base = 16px
        fontWeight: TailwindDesignTokens.fontWeight('normal'),
        color: bodyColor,
        height: 1.5,                                           // leading-normal
      ),
      bodySmall: TextStyle(
        fontSize: TailwindDesignTokens.textSize('sm'),        // text-sm = 14px
        fontWeight: TailwindDesignTokens.fontWeight('normal'),
        color: captionColor,
        height: 1.5,
      ),
      
      // 标签级文字 - 等同于 text-xs
      labelLarge: TextStyle(
        fontSize: TailwindDesignTokens.textSize('sm'),
        fontWeight: TailwindDesignTokens.fontWeight('medium'),
        color: captionColor,
      ),
      labelMedium: TextStyle(
        fontSize: TailwindDesignTokens.textSize('xs'),        // text-xs = 12px
        fontWeight: TailwindDesignTokens.fontWeight('medium'),
        color: captionColor,
      ),
      labelSmall: TextStyle(
        fontSize: TailwindDesignTokens.textSize('xs'),
        fontWeight: TailwindDesignTokens.fontWeight('normal'),
        color: captionColor,
        letterSpacing: 0.025,                                 // tracking-wide
      ),
    );
  }

  /// 构建卡片主题 - 等同于 Tailwind Card 样式
  static CardTheme _buildCardTheme(bool isDark) {
    return CardTheme(
      color: isDark 
          ? TailwindDesignTokens.colorGray[900]!
          : TailwindDesignTokens.colorGray[50]!,
      shadowColor: TailwindDesignTokens.colorGray[950]!.withOpacity(0.1),
      elevation: 0,  // 默认无阴影，符合 Tailwind 扁平化设计
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('lg')), // rounded-lg
        side: BorderSide(
          color: isDark
              ? TailwindDesignTokens.colorGray[800]!
              : TailwindDesignTokens.colorGray[200]!,
          width: 1,
        ),
      ),
    );
  }

  /// 构建按钮主题 - 等同于 Tailwind Button 样式
  static ElevatedButtonThemeData _buildElevatedButtonTheme(bool isDark) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: TailwindDesignTokens.colorBlue[600]!, // bg-blue-600
        foregroundColor: TailwindDesignTokens.colorGray[50]!,   // text-white
        elevation: 0,  // 无阴影，符合 Tailwind 扁平化设计
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')), // rounded
        ),
        padding: EdgeInsets.symmetric(
          horizontal: TailwindDesignTokens.space('4'),  // px-4
          vertical: TailwindDesignTokens.space('2'),    // py-2
        ),
        textStyle: TextStyle(
          fontSize: TailwindDesignTokens.textSize('base'),     // text-base
          fontWeight: TailwindDesignTokens.fontWeight('medium'), // font-medium
        ),
      ),
    );
  }

  /// 构建应用栏主题 - 等同于 Tailwind 导航样式
  static AppBarTheme _buildAppBarTheme(bool isDark) {
    return AppBarTheme(
      backgroundColor: isDark 
          ? TailwindDesignTokens.colorGray[900]!
          : TailwindDesignTokens.colorGray[50]!,
      foregroundColor: isDark 
          ? TailwindDesignTokens.colorGray[100]!
          : TailwindDesignTokens.colorGray[900]!,
      elevation: 0,  // 无阴影
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: TailwindDesignTokens.textSize('xl'),        // text-xl
        fontWeight: TailwindDesignTokens.fontWeight('semibold'), // font-semibold
        color: isDark 
            ? TailwindDesignTokens.colorGray[100]!
            : TailwindDesignTokens.colorGray[900]!,
      ),
    );
  }

  /// 构建输入框主题 - 等同于 Tailwind Input 样式
  static InputDecorationTheme _buildInputDecorationTheme(bool isDark) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark 
          ? TailwindDesignTokens.colorGray[800]!.withOpacity(0.5)
          : TailwindDesignTokens.colorGray[100]!,
      
      // 边框样式 - 等同于 border border-gray-300
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')), // rounded
        borderSide: BorderSide(
          color: isDark 
              ? TailwindDesignTokens.colorGray[700]!
              : TailwindDesignTokens.colorGray[300]!,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')),
        borderSide: BorderSide(
          color: isDark 
              ? TailwindDesignTokens.colorGray[700]!
              : TailwindDesignTokens.colorGray[300]!,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')),
        borderSide: BorderSide(
          color: TailwindDesignTokens.colorBlue[600]!,         // border-blue-600
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')),
        borderSide: BorderSide(
          color: TailwindDesignTokens.colorRed[600]!,          // border-red-600
          width: 1,
        ),
      ),
      
      // 内边距 - 等同于 px-3 py-2
      contentPadding: EdgeInsets.symmetric(
        horizontal: TailwindDesignTokens.space('3'),          // px-3
        vertical: TailwindDesignTokens.space('2'),            // py-2
      ),
      
      // 文字样式
      labelStyle: TextStyle(
        fontSize: TailwindDesignTokens.textSize('base'),      // text-base
        color: isDark 
            ? TailwindDesignTokens.colorGray[400]!
            : TailwindDesignTokens.colorGray[600]!,
      ),
      hintStyle: TextStyle(
        fontSize: TailwindDesignTokens.textSize('base'),
        color: isDark 
            ? TailwindDesignTokens.colorGray[500]!
            : TailwindDesignTokens.colorGray[400]!,
      ),
    );
  }

  /// 构建分割线主题 - 等同于 Tailwind Divider 样式
  static DividerThemeData _buildDividerTheme(bool isDark) {
    return DividerThemeData(
      color: isDark 
          ? TailwindDesignTokens.colorGray[800]!
          : TailwindDesignTokens.colorGray[200]!,
      thickness: 1,
      space: 1,
    );
  }

  /// 获取统一的 Tailwind 颜色系统
  static TailwindDesignTokens get tokens => const TailwindDesignTokens();
  
  /// 获取语义颜色系统
  static TailwindSemanticTokens get semanticTokens => const TailwindSemanticTokens();
}

/// 快捷访问器 - 便于在组件中使用 Tailwind 样式
extension TailwindExtensions on BuildContext {
  /// 获取 Tailwind 设计令牌 - 等同于 tw 工具类
  TailwindDesignTokens get tw => TailwindDesignTokens();
  
  /// 获取语义令牌 - 等同于 semantic 工具类
  TailwindSemanticTokens get semantic => TailwindSemanticTokens();
  
  /// 检查是否为暗色主题
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
