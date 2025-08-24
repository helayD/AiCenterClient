import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class AppLogger {
  static const String _prefix = '[AdminApp]';
  
  static void debug(String message) {
    if (ApiConfig.enableLogging && kDebugMode) {
      debugPrint('$_prefix [DEBUG] $message');
    }
  }
  
  static void info(String message) {
    if (ApiConfig.enableLogging && kDebugMode) {
      debugPrint('$_prefix [INFO] $message');
    }
  }
  
  static void warning(String message) {
    if (ApiConfig.enableLogging && kDebugMode) {
      debugPrint('$_prefix [WARNING] $message');
    }
  }
  
  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      debugPrint('$_prefix [ERROR] $message');
      if (error != null) {
        debugPrint('$_prefix [ERROR] Error: $error');
      }
      if (stackTrace != null && ApiConfig.enableLogging) {
        debugPrint('$_prefix [ERROR] StackTrace: $stackTrace');
      }
    }
  }
  
  static void network(String message) {
    if (ApiConfig.enableLogging && kDebugMode) {
      debugPrint('$_prefix [NETWORK] $message');
    }
  }
}