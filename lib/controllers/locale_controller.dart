import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const String _localeKey = 'selected_locale';
  
  // 支持的语言列表
  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'), // 中文简体
    Locale('en', 'US'), // 英文
  ];
  
  // 默认语言
  static const Locale defaultLocale = Locale('zh', 'CN');
  
  Locale _currentLocale = defaultLocale;
  
  Locale get currentLocale => _currentLocale;
  
  // 获取当前语言的显示名称
  String get currentLanguageName {
    switch (_currentLocale.languageCode) {
      case 'zh':
        return '中文简体';
      case 'en':
        return 'English';
      default:
        return '中文简体';
    }
  }
  
  // 获取语言显示名称
  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return '中文简体';
      case 'en':
        return 'English';
      default:
        return '中文简体';
    }
  }
  
  // 初始化，从本地存储读取语言设置
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeString = prefs.getString(_localeKey);
      
      if (localeString != null) {
        final parts = localeString.split('_');
        if (parts.length == 2) {
          final locale = Locale(parts[0], parts[1]);
          if (supportedLocales.contains(locale)) {
            _currentLocale = locale;
            notifyListeners();
          }
        }
      }
    } catch (e) {
      // 如果读取失败，使用默认语言
      _currentLocale = defaultLocale;
    }
  }
  
  // 切换语言
  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales.contains(locale)) {
      return;
    }
    
    if (_currentLocale == locale) {
      return;
    }
    
    _currentLocale = locale;
    
    // 保存到本地存储
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, '${locale.languageCode}_${locale.countryCode}');
    } catch (e) {
      // 忽略存储错误
    }
    
    notifyListeners();
  }
  
  // 切换到下一个语言
  Future<void> toggleLanguage() async {
    final currentIndex = supportedLocales.indexOf(_currentLocale);
    final nextIndex = (currentIndex + 1) % supportedLocales.length;
    await setLocale(supportedLocales[nextIndex]);
  }
  
  // 获取系统语言
  Locale getSystemLocale() {
    final systemLocale = PlatformDispatcher.instance.locale;
    
    // 检查系统语言是否在支持列表中
    for (final supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == systemLocale.languageCode) {
        return supportedLocale;
      }
    }
    
    // 如果系统语言不在支持列表中，返回默认语言
    return defaultLocale;
  }
  
  // 使用系统语言
  Future<void> useSystemLocale() async {
    final systemLocale = getSystemLocale();
    await setLocale(systemLocale);
  }
}