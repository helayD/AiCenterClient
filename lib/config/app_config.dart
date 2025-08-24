import 'api_config.dart';

class AppConfig {
  // App information
  static const String appName = 'Flutter Admin Panel';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';
  
  // Database/Storage settings
  static const String databaseName = 'admin_app.db';
  static const int databaseVersion = 1;
  
  // Session settings
  static const Duration sessionTimeout = Duration(hours: 8);
  static const Duration tokenRefreshThreshold = Duration(minutes: 5);
  static const bool autoRefreshToken = true;
  
  // UI settings
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const bool enableHapticFeedback = true;
  static const bool enableAnimations = true;
  
  // Feature flags
  static const bool enableBiometricAuth = false;
  static const bool enableRememberMe = true;
  static const bool enableOfflineMode = false;
  static const bool enablePushNotifications = false;
  
  // Debugging
  static bool get isDebugMode => ApiConfig.isDevelopment;
  static bool get enableDebugLogs => ApiConfig.enableLogging;
  
  // Network settings
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  static const bool enableCaching = true;
  static const Duration cacheValidityDuration = Duration(minutes: 15);
  
  // File upload settings
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'pdf', 'doc', 'docx', 'xls', 'xlsx'
  ];
  
  // Pagination settings
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Security settings
  static const int maxLoginAttempts = 5;
  static const Duration loginCooldownDuration = Duration(minutes: 15);
  static const bool enableAutoLogout = true;
  static const Duration autoLogoutDuration = Duration(minutes: 30);
  
  // Theme settings
  static const bool enableSystemTheme = true;
  static const bool enableDynamicTheme = true;
  
  // Localization settings
  static const String defaultLocale = 'zh';
  static const List<String> supportedLocales = ['zh', 'en'];
  static const bool enableRTL = false;
  
  // Performance settings
  static const bool enablePerformanceMonitoring = true;
  static const Duration performanceMetricsInterval = Duration(seconds: 30);
  
  // Error handling settings
  static const bool enableErrorReporting = true;
  static const bool enableUserFeedback = true;
  static const String supportEmail = 'support@example.com';
  
  // Development tools
  static bool get showPerformanceOverlay => isDebugMode;
  static bool get showDebugBanner => isDebugMode;
  
  // Helper methods
  static String getUserAgent() {
    return '${ApiConfig.userAgent} ($appName $appVersion+$buildNumber)';
  }
  
  static Map<String, dynamic> getAppInfo() {
    return {
      'name': appName,
      'version': appVersion,
      'buildNumber': buildNumber,
      'environment': ApiConfig.environment,
      'baseUrl': ApiConfig.baseUrl,
      'platform': 'Flutter',
    };
  }
  
  static bool isFeatureEnabled(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'biometric_auth':
        return enableBiometricAuth;
      case 'remember_me':
        return enableRememberMe;
      case 'offline_mode':
        return enableOfflineMode;
      case 'push_notifications':
        return enablePushNotifications;
      case 'auto_refresh_token':
        return autoRefreshToken;
      case 'haptic_feedback':
        return enableHapticFeedback;
      case 'animations':
        return enableAnimations;
      case 'caching':
        return enableCaching;
      case 'auto_logout':
        return enableAutoLogout;
      case 'system_theme':
        return enableSystemTheme;
      case 'dynamic_theme':
        return enableDynamicTheme;
      case 'error_reporting':
        return enableErrorReporting;
      case 'user_feedback':
        return enableUserFeedback;
      case 'performance_monitoring':
        return enablePerformanceMonitoring;
      default:
        return false;
    }
  }
}