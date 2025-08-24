import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class FontConfig {
  // 平台感知字体配置
  static TextTheme getTextTheme(BuildContext context) {
    // macOS桌面应用使用系统字体避免网络问题
    if (!kIsWeb && Platform.isMacOS) {
      return getMacOSSystemTextTheme();
    }
    
    // 其他平台尝试使用Google Fonts，失败时回退到系统字体
    try {
      return GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      );
    } catch (e) {
      debugPrint('Failed to load Google Fonts, using system fonts: $e');
      return getSystemTextTheme();
    }
  }

  // macOS系统字体主题
  static TextTheme getMacOSSystemTextTheme() {
    const fontFamily = '.AppleSystemUIFont';
    return const TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.w500),
    );
  }

  // 通用系统字体主题（回退方案）
  static TextTheme getSystemTextTheme() {
    return const TextTheme(
      displayLarge: TextStyle(fontWeight: FontWeight.w300),
      displayMedium: TextStyle(fontWeight: FontWeight.w400),
      displaySmall: TextStyle(fontWeight: FontWeight.w400),
      headlineLarge: TextStyle(fontWeight: FontWeight.w400),
      headlineMedium: TextStyle(fontWeight: FontWeight.w400),
      headlineSmall: TextStyle(fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontWeight: FontWeight.w500),
      titleMedium: TextStyle(fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontWeight: FontWeight.w400),
      labelLarge: TextStyle(fontWeight: FontWeight.w500),
      labelMedium: TextStyle(fontWeight: FontWeight.w500),
      labelSmall: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  // 检查是否应该使用网络字体
  static bool get shouldUseNetworkFonts {
    // Web环境可以使用网络字体
    if (kIsWeb) return true;
    
    // macOS桌面应用避免网络字体
    if (Platform.isMacOS) return false;
    
    // 其他平台默认尝试使用网络字体
    return true;
  }

  // 平台感知的字体样式获取
  static TextStyle getTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: !kIsWeb && Platform.isMacOS ? '.AppleSystemUIFont' : null,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}