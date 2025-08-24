import 'cors_config.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class ApiConfig {
  // Environment settings
  static const String environment = String.fromEnvironment('ENV', defaultValue: 'development');
  
  // Base URLs for different environments (使用CORS配置)
  static const Map<String, String> _baseUrls = {
    'development': 'http://47.106.218.81:20080',
    'staging': 'http://47.106.218.81:20080',
    'production': 'http://47.106.218.81:20080',
  };
  
  // CORS代理配置 - Web环境自动使用代理
  static const Map<String, String> _proxyUrls = {
    'development': 'http://127.0.0.1:3001',
    'staging': 'http://127.0.0.1:3001',
    'production': 'https://api-proxy.your-domain.com', // 生产环境代理服务器
  };
  
  // API endpoints
  static const Map<String, String> endpoints = {
    'login': '/api/v1/auth/login',
    'logout': '/api/v1/auth/logout',
    'refresh': '/api/v1/auth/refresh',
    'profile': '/api/v1/user/profile',
    'dashboard': '/api/v1/dashboard',
  };
  
  // Request timeout settings
  static const Map<String, Duration> _timeouts = {
    'connect': Duration(seconds: 15),
    'receive': Duration(seconds: 30),
    'send': Duration(seconds: 30),
  };
  
  // Storage keys for SharedPreferences
  static const Map<String, String> _storageKeys = {
    'token': 'auth_token',
    'refresh_token': 'refresh_token',
    'user_data': 'user_data',
    'cookies': 'session_cookies',
    'login_timestamp': 'login_timestamp',
  };
  
  // Common headers (Web-safe only)
  static const Map<String, String> _defaultHeaders = {
    'Accept': 'application/json, text/plain, */*',
    'Content-Type': 'application/json',
  };
  
  // Getters - 智能选择基础URL
  static String get baseUrl {
    // Web环境优先使用代理服务器避免CORS问题
    if (kIsWeb) {
      const useProxy = String.fromEnvironment('USE_PROXY', defaultValue: 'true');
      if (useProxy.toLowerCase() == 'true') {
        return _proxyUrls[environment] ?? _proxyUrls['development']!;
      }
    }
    
    // macOS桌面应用 - 直连API，避免代理依赖
    if (!kIsWeb && Platform.isMacOS) {
      return _baseUrls[environment] ?? _baseUrls['development']!;
    }
    
    // 其他平台直连API服务器
    return _baseUrls[environment] ?? _baseUrls['development']!;
  }
  
  // 获取直连API URL (用于健康检查等)
  static String get directApiUrl => _baseUrls[environment] ?? _baseUrls['development']!;
  
  // 获取代理服务器URL
  static String get proxyUrl => _proxyUrls[environment] ?? _proxyUrls['development']!;
  
  // 检查是否使用代理模式
  static bool get isUsingProxy {
    // 只有Web平台需要代理
    if (!kIsWeb) return false;
    const useProxy = String.fromEnvironment('USE_PROXY', defaultValue: 'true');
    return useProxy.toLowerCase() == 'true';
  }
  
  // 平台识别
  static bool get isMacOSApp => !kIsWeb && Platform.isMacOS;
  static bool get isWebApp => kIsWeb;
  
  static String get loginEndpoint => baseUrl + endpoints['login']!;
  static String get logoutEndpoint => baseUrl + endpoints['logout']!;
  static String get refreshEndpoint => baseUrl + endpoints['refresh']!;
  static String get profileEndpoint => baseUrl + endpoints['profile']!;
  static String get dashboardEndpoint => baseUrl + endpoints['dashboard']!;
  
  static Duration get connectTimeout => _timeouts['connect']!;
  static Duration get receiveTimeout => _timeouts['receive']!;
  static Duration get sendTimeout => _timeouts['send']!;
  
  static String get tokenKey => _storageKeys['token']!;
  static String get refreshTokenKey => _storageKeys['refresh_token']!;
  static String get userDataKey => _storageKeys['user_data']!;
  static String get cookiesKey => _storageKeys['cookies']!;
  static String get loginTimestampKey => _storageKeys['login_timestamp']!;
  
  static Map<String, String> get defaultHeaders => Map.from(_defaultHeaders);
  
  // Helper methods
  static String getFullUrl(String endpoint) {
    if (endpoint.startsWith('http')) {
      return endpoint;
    }
    return baseUrl + (endpoint.startsWith('/') ? endpoint : '/$endpoint');
  }
  
  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  
  // Debug settings
  static bool get enableLogging => isDevelopment || isStaging;
  static bool get enableCrashReporting => isProduction;
  
  // API Version
  static const String apiVersion = 'v1';
  
  // User Agent for requests
  static const String userAgent = 'Flutter-Admin-Panel/1.0.0';
  
  // Cookie domain for session management
  static String get cookieDomain {
    final uri = Uri.parse(baseUrl);
    return uri.host;
  }
  
  // Security settings
  static const bool enableCertificatePinning = false; // Set to true in production
  static const bool allowSelfSignedCertificates = true; // Set to false in production
}