import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/font_config.dart';
import '../constants.dart';
import '../theme/tailwind_theme_system.dart';

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
  
  // Get light theme data - 使用 Tailwind CSS v4 设计系统
  ThemeData get lightTheme {
    final tailwindTheme = TailwindThemeSystem.lightTheme;
    
    // 保持平台感知字体配置的兼容性
    return tailwindTheme.copyWith(
      textTheme: _getPlatformTextTheme().apply(
        bodyColor: tailwindTheme.colorScheme.onSurface,
        displayColor: tailwindTheme.colorScheme.onSurface,
      ),
    );
  }
  
  // Get dark theme data - 使用 Tailwind CSS v4 设计系统
  ThemeData get darkTheme {
    final tailwindTheme = TailwindThemeSystem.darkTheme;
    
    // 保持平台感知字体配置的兼容性
    return tailwindTheme.copyWith(
      textTheme: _getPlatformTextTheme().apply(
        bodyColor: tailwindTheme.colorScheme.onSurface,
        displayColor: tailwindTheme.colorScheme.onSurface,
      ),
    );
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