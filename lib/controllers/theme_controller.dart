import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/font_config.dart';
import '../constants.dart';

enum AppThemeMode {
  light,
  dark,
  auto,
}

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  
  AppThemeMode _themeMode = AppThemeMode.auto;
  bool _isSystemDark = false;
  
  AppThemeMode get themeMode => _themeMode;
  bool get isSystemDark => _isSystemDark;
  
  // Get current effective theme (resolving auto mode)
  bool get isDarkMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return false;
      case AppThemeMode.dark:
        return true;
      case AppThemeMode.auto:
        return _isSystemDark;
    }
  }
  
  // Initialize theme controller
  Future<void> initialize() async {
    await _loadThemePreference();
    _detectSystemTheme();
  }
  
  // Load theme preference from storage
  Future<void> _loadThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? AppThemeMode.auto.index;
      _themeMode = AppThemeMode.values[themeIndex];
    } catch (e) {
      _themeMode = AppThemeMode.auto;
    }
  }
  
  // Save theme preference to storage
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, _themeMode.index);
    } catch (e) {
      // Handle error silently
    }
  }
  
  // Detect system theme
  void _detectSystemTheme() {
    final window = WidgetsBinding.instance.platformDispatcher;
    _isSystemDark = window.platformBrightness == Brightness.dark;
    
    // Listen for system theme changes
    window.onPlatformBrightnessChanged = () {
      final newSystemDark = window.platformBrightness == Brightness.dark;
      if (_isSystemDark != newSystemDark) {
        _isSystemDark = newSystemDark;
        if (_themeMode == AppThemeMode.auto) {
          notifyListeners();
        }
      }
    };
  }
  
  // Change theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _saveThemePreference();
      notifyListeners();
    }
  }
  
  // Get light theme data
  ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ).copyWith(
      // MD3 增强配色 - 更柔和的表面色
      surface: const Color(0xFFF4FBFA),
      onSurface: const Color(0xFF161D1D),
      surfaceContainer: const Color(0xFFECF3F2),
      surfaceContainerHigh: const Color(0xFFE5EDEC),
      surfaceContainerHighest: const Color(0xFFDFE7E6),
      surfaceContainerLow: const Color(0xFFF2F9F8),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
    );
    
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surfaceContainer,
      canvasColor: colorScheme.surface,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      
      // Text theme - 平台感知字体配置
      textTheme: _getPlatformTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      
      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      
      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      
      // Card theme - Material 3样式
      cardTheme: CardTheme(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          shadowColor: colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
  
  // Get dark theme data
  ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      // MD3 暗色主题增强配色 - 更深邃的表面色
      surface: const Color(0xFF0F1514),
      onSurface: const Color(0xFFE0E3E2),
      surfaceContainer: const Color(0xFF1A2120),
      surfaceContainerHigh: const Color(0xFF252B2A),
      surfaceContainerHighest: const Color(0xFF303635),
      surfaceContainerLow: const Color(0xFF161D1C),
      surfaceContainerLowest: const Color(0xFF0A0F0E),
    );
    
    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      cardColor: colorScheme.surfaceContainer,
      canvasColor: colorScheme.surface,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 2,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
      ),
      
      // Text theme - 平台感知字体配置
      textTheme: _getPlatformTextTheme().apply(
        bodyColor: colorScheme.onSurface,
        displayColor: colorScheme.onSurface,
      ),
      
      // Icon theme
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      
      // Drawer theme
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      
      // Card theme - Material 3样式
      cardTheme: CardTheme(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: colorScheme.surfaceTint,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: colorScheme.outlineVariant,
            width: 1,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6)),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 1,
          shadowColor: colorScheme.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      
      // List tile theme
      listTileTheme: ListTileThemeData(
        textColor: colorScheme.onSurface,
        iconColor: colorScheme.onSurfaceVariant,
      ),
    );
  }
  
  // Material 3 动态配色生成器
  ColorScheme _generateColorScheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    
    // 根据明暗模式应用MD3增强配色
    if (brightness == Brightness.light) {
      return baseScheme.copyWith(
        surface: const Color(0xFFF4FBFA),
        onSurface: const Color(0xFF161D1D),
        surfaceContainer: const Color(0xFFECF3F2),
        surfaceContainerHigh: const Color(0xFFE5EDEC),
        surfaceContainerHighest: const Color(0xFFDFE7E6),
        surfaceContainerLow: const Color(0xFFF2F9F8),
        surfaceContainerLowest: const Color(0xFFFFFFFF),
      );
    } else {
      return baseScheme.copyWith(
        surface: const Color(0xFF0F1514),
        onSurface: const Color(0xFFE0E3E2),
        surfaceContainer: const Color(0xFF1A2120),
        surfaceContainerHigh: const Color(0xFF252B2A),
        surfaceContainerHighest: const Color(0xFF303635),
        surfaceContainerLow: const Color(0xFF161D1C),
        surfaceContainerLowest: const Color(0xFF0A0F0E),
      );
    }
  }
  
  // MD3 颜色验证器 - 检查对比度和可访问性
  bool _isColorContrastCompliant(Color foreground, Color background) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    final contrast = (fgLuminance > bgLuminance
        ? fgLuminance + 0.05
        : bgLuminance + 0.05) / 
        (fgLuminance > bgLuminance 
        ? bgLuminance + 0.05 
        : fgLuminance + 0.05);
    return contrast >= 4.5; // WCAG AA 标准
  }

  // 平台感知字体主题
  TextTheme _getPlatformTextTheme() {
    try {
      if (FontConfig.shouldUseNetworkFonts) {
        return GoogleFonts.poppinsTextTheme();
      } else {
        // macOS使用系统字体
        return FontConfig.getMacOSSystemTextTheme();
      }
    } catch (e) {
      // 回退到基本系统字体
      return FontConfig.getSystemTextTheme();
    }
  }
  
  // Get theme display name for UI (requires context for localization)
  String getThemeDisplayName(AppThemeMode mode, BuildContext context) {
    switch (mode) {
      case AppThemeMode.light:
        return AppLocalizations.of(context)!.lightMode;
      case AppThemeMode.dark:
        return AppLocalizations.of(context)!.darkMode;
      case AppThemeMode.auto:
        return AppLocalizations.of(context)!.autoMode;
    }
  }
  
  // Get theme icon for UI
  IconData getThemeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.auto:
        return Icons.brightness_auto;
    }
  }
}