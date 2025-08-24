import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/api_response.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isInitialized = false;
  String? _errorMessage;
  UserData? _userData;
  bool _obscurePassword = true;

  // Getters
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  UserData? get userData => _userData;
  String? get userEmail => _userData?.email;
  String? get userName => _userData?.name ?? _userData?.username;
  String? get userAvatar => _userData?.avatar;
  String? get userRole => _userData?.role;
  bool get obscurePassword => _obscurePassword;

  // Initialize controller
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      AppLogger.info('Initializing AuthController');
      _setLoading(true);
      
      // Initialize auth service
      await _authService.initialize();
      
      // Check if user is already authenticated
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final userData = await _authService.getUserData();
        if (userData != null) {
          _userData = userData;
          _isAuthenticated = true;
          AppLogger.info('User already authenticated: ${userData.email}');
        }
      }
      
      _isInitialized = true;
      AppLogger.info('AuthController initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize AuthController: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Login method
  Future<bool> login(String identifier, String password, BuildContext context, {bool rememberMe = false}) async {
    _setLoading(true);
    _clearError();

    try {
      AppLogger.info('Attempting login for: $identifier');
      
      final response = await _authService.login(
        identifier: identifier,
        password: password,
        rememberMe: rememberMe,
      );

      if (response.success && response.data != null) {
        final loginData = response.data!;
        _userData = loginData.user;
        _isAuthenticated = true;
        
        AppLogger.info('Login successful for: ${_userData?.email}');
        _setLoading(false);
        return true;
      } else {
        final l10n = AppLocalizations.of(context)!;
        String errorMessage;
        
        // Map specific error messages
        if (response.statusCode == 401) {
          errorMessage = l10n.invalidCredentials;
        } else if (response.statusCode == 429) {
          errorMessage = 'Too many login attempts. Please try again later.';
        } else if (response.statusCode == -5) { // No internet
          errorMessage = l10n.loginFailedNetwork;
        } else {
          errorMessage = response.error ?? l10n.loginFailedNetwork;
        }
        
        _setError(errorMessage);
        _setLoading(false);
        return false;
      }
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      AppLogger.error('Login error: $e');
      _setError(l10n.loginFailedNetwork);
      _setLoading(false);
      return false;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out user: ${_userData?.email}');
      _setLoading(true);
      
      await _authService.logout();
      
      _isAuthenticated = false;
      _userData = null;
      _clearError();
      
      AppLogger.info('Logout completed');
    } catch (e) {
      AppLogger.error('Logout error: $e');
      // Still clear local state even if API call fails
      _isAuthenticated = false;
      _userData = null;
      _clearError();
    } finally {
      _setLoading(false);
    }
  }

  // Refresh token
  Future<bool> refreshToken() async {
    try {
      AppLogger.info('Refreshing token');
      
      final response = await _authService.refreshToken();
      
      if (response.success && response.data != null) {
        final loginData = response.data!;
        _userData = loginData.user ?? _userData;
        _isAuthenticated = true;
        
        AppLogger.info('Token refresh successful');
        notifyListeners();
        return true;
      } else {
        AppLogger.warning('Token refresh failed: ${response.error}');
        await logout(); // Clear auth state if refresh fails
        return false;
      }
    } catch (e) {
      AppLogger.error('Token refresh error: $e');
      await logout();
      return false;
    }
  }

  // Check authentication status
  Future<bool> checkAuthStatus() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      final isAuth = await _authService.isAuthenticated();
      if (isAuth != _isAuthenticated) {
        _isAuthenticated = isAuth;
        if (!isAuth) {
          _userData = null;
        }
        notifyListeners();
      }
      
      return isAuth;
    } catch (e) {
      AppLogger.error('Error checking auth status: $e');
      return false;
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> profileData, BuildContext context) async {
    try {
      _setLoading(true);
      
      final response = await _authService.updateProfile(profileData);
      
      if (response.success && response.data != null) {
        _userData = response.data!;
        notifyListeners();
        return true;
      } else {
        _setError(response.error ?? 'Failed to update profile');
        return false;
      }
    } catch (e) {
      AppLogger.error('Profile update error: $e');
      _setError('Failed to update profile');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get fresh user profile from server
  Future<void> refreshProfile() async {
    try {
      final response = await _authService.getProfile();
      
      if (response.success && response.data != null) {
        _userData = response.data!;
        notifyListeners();
      }
    } catch (e) {
      AppLogger.error('Profile refresh error: $e');
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Form validation methods
  String? validateEmail(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }
    // Allow both email and username for identifier
    if (value.contains('@')) {
      // Validate as email
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
        return l10n.emailInvalid;
      }
    } else {
      // Validate as username (basic validation)
      if (value.length < 3) {
        return 'Username must be at least 3 characters';
      }
    }
    return null;
  }

  String? validatePassword(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 6) {
      return l10n.passwordTooShort;
    }
    return null;
  }

  // Auto-login check (for app startup)
  Future<bool> tryAutoLogin() async {
    try {
      if (!_isInitialized) {
        await initialize();
      }
      
      final canAutoLogin = await _authService.canAutoLogin();
      if (canAutoLogin) {
        final userData = await _authService.getUserData();
        if (userData != null) {
          _userData = userData;
          _isAuthenticated = true;
          notifyListeners();
          
          AppLogger.info('Auto-login successful for: ${userData.email}');
          return true;
        }
      }
      
      return false;
    } catch (e) {
      AppLogger.error('Auto-login error: $e');
      return false;
    }
  }
}