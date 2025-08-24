import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../services/http_service.dart';
import '../utils/logger.dart';

class AuthService {
  static AuthService? _instance;
  final HttpService _httpService = HttpService.instance;
  SharedPreferences? _prefs;

  AuthService._();

  static AuthService get instance {
    _instance ??= AuthService._();
    return _instance!;
  }

  // Initialize service
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Login method
  Future<ApiResponse<LoginResponse>> login({
    required String identifier,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      AppLogger.info('Attempting login for identifier: $identifier');

      final loginRequest = LoginRequest(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );

      final response = await _httpService.post<LoginResponse>(
        ApiConfig.endpoints['login']!,
        data: loginRequest.toJson(),
        fromJson: (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        final loginData = response.data!;
        
        // Store authentication data
        await _storeAuthData(loginData, rememberMe);
        
        AppLogger.info('Login successful for user: ${loginData.user?.email}');
        return response;
      } else {
        AppLogger.warning('Login failed: ${response.error}');
        return response;
      }
    } catch (e) {
      AppLogger.error('Login error: $e');
      return ApiResponse.error('Login failed: $e');
    }
  }

  // Logout method
  Future<ApiResponse<void>> logout() async {
    try {
      AppLogger.info('Attempting logout');

      // Call logout endpoint (optional, depends on backend)
      await _httpService.post<void>(
        ApiConfig.endpoints['logout']!,
      );

      // Clear local auth data regardless of API response
      await _clearAuthData();
      
      AppLogger.info('Logout completed');
      return ApiResponse.success(null, message: 'Logout successful');
    } catch (e) {
      AppLogger.error('Logout error: $e');
      // Still clear local data even if API call fails
      await _clearAuthData();
      return ApiResponse.success(null, message: 'Logout completed locally');
    }
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }

      // Check if token is expired
      final loginTimestamp = await getLoginTimestamp();
      if (loginTimestamp != null) {
        final tokenAge = DateTime.now().difference(loginTimestamp);
        if (tokenAge > AppConfig.sessionTimeout) {
          AppLogger.info('Token expired, clearing auth data');
          await _clearAuthData();
          return false;
        }
      }

      return true;
    } catch (e) {
      AppLogger.error('Error checking authentication: $e');
      return false;
    }
  }

  // Get stored token
  Future<String?> getToken() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs?.getString(ApiConfig.tokenKey);
    } catch (e) {
      AppLogger.error('Error getting token: $e');
      return null;
    }
  }

  // Get stored user data
  Future<UserData?> getUserData() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final userDataJson = _prefs?.getString(ApiConfig.userDataKey);
      if (userDataJson != null) {
        final userMap = jsonDecode(userDataJson) as Map<String, dynamic>;
        return UserData.fromJson(userMap);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting user data: $e');
      return null;
    }
  }

  // Get login timestamp
  Future<DateTime?> getLoginTimestamp() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      final timestamp = _prefs?.getInt(ApiConfig.loginTimestampKey);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    } catch (e) {
      AppLogger.error('Error getting login timestamp: $e');
      return null;
    }
  }

  // Refresh token
  Future<ApiResponse<LoginResponse>> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) {
        return ApiResponse.error('No refresh token available');
      }

      AppLogger.info('Attempting token refresh');

      final response = await _httpService.post<LoginResponse>(
        ApiConfig.endpoints['refresh']!,
        data: {'refresh_token': refreshToken},
        fromJson: (data) => LoginResponse.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        final loginData = response.data!;
        await _storeAuthData(loginData, true); // Keep remember me setting
        
        AppLogger.info('Token refresh successful');
        return response;
      } else {
        AppLogger.warning('Token refresh failed: ${response.error}');
        await _clearAuthData(); // Clear invalid tokens
        return response;
      }
    } catch (e) {
      AppLogger.error('Token refresh error: $e');
      await _clearAuthData();
      return ApiResponse.error('Token refresh failed: $e');
    }
  }

  // Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      return _prefs?.getString(ApiConfig.refreshTokenKey);
    } catch (e) {
      AppLogger.error('Error getting refresh token: $e');
      return null;
    }
  }

  // Store authentication data
  Future<void> _storeAuthData(LoginResponse loginData, bool rememberMe) async {
    try {
      _prefs ??= await SharedPreferences.getInstance();

      // Store token
      if (loginData.token != null) {
        await _prefs!.setString(ApiConfig.tokenKey, loginData.token!);
      }

      // Store refresh token
      if (loginData.refreshToken != null) {
        await _prefs!.setString(ApiConfig.refreshTokenKey, loginData.refreshToken!);
      }

      // Store user data
      if (loginData.user != null) {
        final userDataJson = jsonEncode(loginData.user!.toJson());
        await _prefs!.setString(ApiConfig.userDataKey, userDataJson);
      }

      // Store login timestamp
      await _prefs!.setInt(
        ApiConfig.loginTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );

      AppLogger.info('Auth data stored successfully');
    } catch (e) {
      AppLogger.error('Error storing auth data: $e');
      throw e;
    }
  }

  // Clear authentication data
  Future<void> _clearAuthData() async {
    try {
      _prefs ??= await SharedPreferences.getInstance();
      
      await Future.wait([
        _prefs!.remove(ApiConfig.tokenKey),
        _prefs!.remove(ApiConfig.refreshTokenKey),
        _prefs!.remove(ApiConfig.userDataKey),
        _prefs!.remove(ApiConfig.loginTimestampKey),
      ]);

      // Clear cookies
      await _httpService.clearCookies();

      AppLogger.info('Auth data cleared successfully');
    } catch (e) {
      AppLogger.error('Error clearing auth data: $e');
    }
  }

  // Check if auto-login is possible
  Future<bool> canAutoLogin() async {
    try {
      if (!AppConfig.isFeatureEnabled('remember_me')) {
        return false;
      }

      final token = await getToken();
      if (token == null || token.isEmpty) {
        return false;
      }

      // Check token expiration
      return await isAuthenticated();
    } catch (e) {
      AppLogger.error('Error checking auto-login: $e');
      return false;
    }
  }

  // Update user profile
  Future<ApiResponse<UserData>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _httpService.put<UserData>(
        ApiConfig.endpoints['profile']!,
        data: profileData,
        fromJson: (data) => UserData.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Update stored user data
        final userDataJson = jsonEncode(response.data!.toJson());
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs!.setString(ApiConfig.userDataKey, userDataJson);
      }

      return response;
    } catch (e) {
      AppLogger.error('Error updating profile: $e');
      return ApiResponse.error('Profile update failed: $e');
    }
  }

  // Get user profile from server
  Future<ApiResponse<UserData>> getProfile() async {
    try {
      final response = await _httpService.get<UserData>(
        ApiConfig.endpoints['profile']!,
        fromJson: (data) => UserData.fromJson(data as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        // Update stored user data
        final userDataJson = jsonEncode(response.data!.toJson());
        _prefs ??= await SharedPreferences.getInstance();
        await _prefs!.setString(ApiConfig.userDataKey, userDataJson);
      }

      return response;
    } catch (e) {
      AppLogger.error('Error getting profile: $e');
      return ApiResponse.error('Failed to get profile: $e');
    }
  }
}