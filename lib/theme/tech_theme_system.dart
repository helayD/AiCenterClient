import 'package:flutter/material.dart';
import 'tailwind_colors.dart';
import '../constants.dart';

/// 统一主题系统 - 完全基于Tailwind CSS标准
/// 
/// 特性:
/// - 完全基于Tailwind官方OKLCH色彩数值
/// - 统一的明暗双主题支持
/// - Material 3设计规范兼容
/// - 科技商务风格优化

class TechThemeSystem {
  /// 创建明亮主题
  static ThemeData createLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 配色方案 - 直接使用Tailwind语义颜色
      colorScheme: ColorScheme.light(
        primary: TailwindSemanticColors.primary,
        onPrimary: TailwindColors.white,
        primaryContainer: TailwindSemanticColors.primaryLight,
        onPrimaryContainer: TailwindSemanticColors.primary,
        
        secondary: TailwindColors.slate600,
        onSecondary: TailwindColors.white,
        secondaryContainer: TailwindColors.slate100,
        onSecondaryContainer: TailwindColors.slate900,
        
        error: TailwindSemanticColors.error,
        onError: TailwindColors.white,
        errorContainer: TailwindSemanticColors.errorLight,
        onErrorContainer: TailwindSemanticColors.error,
        
        surface: TailwindSemanticColors.surface,
        onSurface: TailwindSemanticColors.onSurface,
        surfaceContainerHighest: TailwindSemanticColors.surfaceVariant,
        onSurfaceVariant: TailwindSemanticColors.onSurfaceVariant,
        
        outline: TailwindSemanticColors.border,
        outlineVariant: TailwindSemanticColors.borderVariant,
        
        shadow: TailwindColors.black,
        scrim: TailwindColors.black,
        
        inverseSurface: TailwindColors.gray900,
        onInverseSurface: TailwindColors.gray50,
        inversePrimary: TailwindColors.blue400,
      ),
      
      // 文字主题
      textTheme: _buildTextTheme(false),
      
      // 组件主题
      cardTheme: CardTheme(
        color: TailwindSemanticColors.surface,
        shadowColor: TailwindColors.black.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TailwindSemanticColors.primary,
          foregroundColor: TailwindColors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TechRadius.sm),
          ),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: TailwindSemanticColors.surface,
        foregroundColor: TailwindSemanticColors.onSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      
      scaffoldBackgroundColor: TailwindSemanticColors.background,
    );
  }

  /// 创建暗色主题
  static ThemeData createDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // 配色方案 - 直接使用Tailwind暗色语义颜色
      colorScheme: ColorScheme.dark(
        primary: TailwindSemanticColors.darkPrimary,
        onPrimary: TailwindColors.black,
        primaryContainer: TailwindColors.blue800,
        onPrimaryContainer: TailwindColors.blue100,
        
        secondary: TailwindColors.slate400,
        onSecondary: TailwindColors.slate900,
        secondaryContainer: TailwindColors.slate800,
        onSecondaryContainer: TailwindColors.slate200,
        
        error: TailwindSemanticColors.darkError,
        onError: TailwindColors.black,
        errorContainer: TailwindColors.red900,
        onErrorContainer: TailwindColors.red200,
        
        surface: TailwindSemanticColors.darkSurface,
        onSurface: TailwindSemanticColors.darkOnSurface,
        surfaceContainerHighest: TailwindSemanticColors.darkSurfaceVariant,
        onSurfaceVariant: TailwindSemanticColors.darkOnSurfaceVariant,
        
        outline: TailwindSemanticColors.darkBorder,
        outlineVariant: TailwindSemanticColors.darkBorderVariant,
        
        shadow: TailwindColors.black,
        scrim: TailwindColors.black,
        
        inverseSurface: TailwindColors.gray100,
        onInverseSurface: TailwindColors.gray900,
        inversePrimary: TailwindColors.blue600,
      ),
      
      // 文字主题
      textTheme: _buildTextTheme(true),
      
      // 组件主题
      cardTheme: CardTheme(
        color: TailwindSemanticColors.darkSurface,
        shadowColor: TailwindColors.black.withOpacity(0.3),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TailwindSemanticColors.darkPrimary,
          foregroundColor: TailwindColors.black,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TechRadius.sm),
          ),
        ),
      ),
      
      appBarTheme: AppBarTheme(
        backgroundColor: TailwindSemanticColors.darkSurface,
        foregroundColor: TailwindSemanticColors.darkOnSurface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      
      scaffoldBackgroundColor: TailwindSemanticColors.darkBackground,
    );
  }

  /// 构建文字主题
  static TextTheme _buildTextTheme(bool isDark) {
    final Color textColor = isDark 
        ? TailwindSemanticColors.darkOnSurface 
        : TailwindSemanticColors.onSurface;
    final Color headlineColor = isDark 
        ? TailwindSemanticColors.darkOnBackground 
        : TailwindSemanticColors.onBackground;
    final Color bodyColor = isDark 
        ? TailwindSemanticColors.darkOnSurfaceVariant 
        : TailwindSemanticColors.onSurfaceVariant;
    
    return TextTheme(
      // 展示级文字
      displayLarge: TextStyle(
        fontSize: TechTypography.displayLarge,
        fontWeight: TechTypography.bold,
        letterSpacing: TechTypography.letterSpacingTight,
        color: headlineColor,
      ),
      displayMedium: TextStyle(
        fontSize: TechTypography.displayMedium,
        fontWeight: TechTypography.bold,
        letterSpacing: TechTypography.letterSpacingTight,
        color: headlineColor,
      ),
      displaySmall: TextStyle(
        fontSize: TechTypography.displaySmall,
        fontWeight: TechTypography.semiBold,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: headlineColor,
      ),
      
      // 标题级文字
      headlineLarge: TextStyle(
        fontSize: TechTypography.headlineLarge,
        fontWeight: TechTypography.semiBold,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: TechTypography.headlineMedium,
        fontWeight: TechTypography.semiBold,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: TechTypography.headlineSmall,
        fontWeight: TechTypography.medium,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: textColor,
      ),
      
      // 正文级文字
      bodyLarge: TextStyle(
        fontSize: TechTypography.bodyLarge,
        fontWeight: TechTypography.normal,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: textColor,
      ),
      bodyMedium: TextStyle(
        fontSize: TechTypography.bodyMedium,
        fontWeight: TechTypography.normal,
        letterSpacing: TechTypography.letterSpacingNormal,
        color: bodyColor,
      ),
      bodySmall: TextStyle(
        fontSize: TechTypography.bodySmall,
        fontWeight: TechTypography.normal,
        letterSpacing: TechTypography.letterSpacingWide,
        color: bodyColor,
      ),
    );
  }

  /// 获取统一的Tailwind颜色系统
  static TailwindColors get colors => const TailwindColors();
  
  /// 获取语义颜色系统
  static TailwindSemanticColors get semanticColors => const TailwindSemanticColors();
}