import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_config.dart';
import '../config/app_config.dart';
import '../models/api_response.dart';
import '../utils/logger.dart';

class HttpService {
  static HttpService? _instance;
  late Dio _dio;
  CookieJar? _cookieJar;

  HttpService._() {
    _initializeDio();
  }

  static HttpService get instance {
    _instance ??= HttpService._();
    return _instance!;
  }

  Future<void> _initializeDio() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        ...ApiConfig.defaultHeaders,
        // Note: User-Agent cannot be set in Web environment
        if (!kIsWeb) 'User-Agent': AppConfig.getUserAgent(),
      },
      validateStatus: (status) => status != null && status < 500,
    ));

    // Initialize cookie management (only for non-web platforms)
    if (!kIsWeb) {
      await _initializeCookieJar();
    }

    // Add interceptors
    _addInterceptors();

    // Configure for development
    if (ApiConfig.isDevelopment) {
      _configureDevelopment();
    }
  }

  Future<void> _initializeCookieJar() async {
    try {
      // For mobile platforms, use persistent cookie jar
      final dir = await getApplicationDocumentsDirectory();
      final cookiePath = '${dir.path}/.cookies/';
      _cookieJar = PersistCookieJar(
        storage: FileStorage(cookiePath),
      );
      
      _dio.interceptors.add(CookieManager(_cookieJar!));
      AppLogger.info('Cookie jar initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize cookie jar: $e');
      // Fallback to default cookie jar for mobile
      _cookieJar = CookieJar();
      _dio.interceptors.add(CookieManager(_cookieJar!));
    }
  }

  void _addInterceptors() {
    // Request interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        AppLogger.info('Request: ${options.method} ${options.uri}');
        if (ApiConfig.enableLogging && options.data != null) {
          AppLogger.debug('Request Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        AppLogger.info('Response: ${response.statusCode} ${response.requestOptions.uri}');
        if (ApiConfig.enableLogging) {
          AppLogger.debug('Response Data: ${response.data}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        AppLogger.error('HTTP Error: ${error.message}');
        if (error.response != null) {
          AppLogger.error('Error Response: ${error.response?.data}');
        }
        handler.next(error);
      },
    ));

    // Auth interceptor (will be added later when we have token management)
    _dio.interceptors.add(AuthInterceptor());

    // Retry interceptor
    _dio.interceptors.add(RetryInterceptor());
  }

  void _configureDevelopment() {
    // macOS平台专门配置
    if (ApiConfig.isMacOSApp) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        // 创建新的HttpClient，不继承系统代理设置
        final client = HttpClient();
        
        // macOS开发模式：允许自签名证书
        if (ApiConfig.allowSelfSignedCertificates) {
          client.badCertificateCallback = (cert, host, port) => true;
        }
        
        // macOS专门的网络配置  
        client.connectionTimeout = const Duration(seconds: 30);
        client.idleTimeout = const Duration(seconds: 15);
        
        // 多重代理禁用策略
        client.findProxy = (uri) {
          AppLogger.debug('Proxy lookup for ${uri}: DIRECT (forced)');
          return 'DIRECT';
        };
        
        // 禁用自动解压缩避免额外网络层
        client.autoUncompress = false;
        
        return client;
      };
      AppLogger.info('macOS Development mode: Direct API connection configured');
    }
    // 其他移动平台配置
    else if (!kIsWeb && ApiConfig.allowSelfSignedCertificates) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
      AppLogger.info('Mobile Development mode: Self-signed certificates allowed');
    } 
    // Web环境保持不变
    else if (kIsWeb) {
      AppLogger.info('Web environment: Certificate handling managed by browser, using CORS proxy');
    }
  }

  // Generic request method
  Future<ApiResponse<T>> request<T>(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) async {
    try {
      final options = Options(
        method: method,
        headers: headers,
      );

      final response = await _dio.request(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      return _handleError<T>(e);
    }
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      endpoint,
      method: 'GET',
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      endpoint,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      endpoint,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    CancelToken? cancelToken,
  }) {
    return request<T>(
      endpoint,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      headers: headers,
      fromJson: fromJson,
      cancelToken: cancelToken,
    );
  }

  // Handle successful response
  ApiResponse<T> _handleResponse<T>(Response response, T Function(dynamic)? fromJson) {
    try {
      if (response.statusCode! >= 200 && response.statusCode! < 300) {
        dynamic data = response.data;
        
        // Try to parse JSON if data is string
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (e) {
            // If parsing fails, use string as is
          }
        }

        // Handle different response structures
        if (data is Map<String, dynamic>) {
          // If response has standard structure
          if (data.containsKey('success') || data.containsKey('status') || data.containsKey('data')) {
            return ApiResponse.fromJson(data, fromJson);
          } else {
            // If response is just the data
            final parsedData = fromJson != null ? fromJson(data) : data as T;
            return ApiResponse.success(parsedData, statusCode: response.statusCode);
          }
        } else {
          // If response is not a map, treat as direct data
          final parsedData = fromJson != null ? fromJson(data) : data as T;
          return ApiResponse.success(parsedData, statusCode: response.statusCode);
        }
      } else {
        return ApiResponse.error(
          'Server error: ${response.statusMessage}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }

  // Handle errors
  ApiResponse<T> _handleError<T>(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return ApiResponse.error('Connection timeout', statusCode: -1);
        case DioExceptionType.sendTimeout:
          return ApiResponse.error('Send timeout', statusCode: -2);
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error('Receive timeout', statusCode: -3);
        case DioExceptionType.badResponse:
          final response = error.response;
          if (response?.data != null) {
            try {
              final errorData = response!.data;
              String errorMessage = 'Server error';
              
              if (errorData is Map<String, dynamic>) {
                errorMessage = errorData['message']?.toString() ?? 
                              errorData['error']?.toString() ?? 
                              'Server error';
              } else if (errorData is String) {
                errorMessage = errorData;
              }
              
              return ApiResponse.error(errorMessage, statusCode: response.statusCode);
            } catch (e) {
              return ApiResponse.error('Server error', statusCode: response?.statusCode ?? 500);
            }
          }
          return ApiResponse.error('Server error', statusCode: error.response?.statusCode ?? 500);
        case DioExceptionType.cancel:
          return ApiResponse.error('Request cancelled', statusCode: -4);
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return ApiResponse.error('No internet connection', statusCode: -5);
          }
          return ApiResponse.error('Network error: ${error.message}', statusCode: -6);
        default:
          return ApiResponse.error('Unknown error occurred', statusCode: -7);
      }
    }
    return ApiResponse.error('Unexpected error: $error', statusCode: -8);
  }

  // Clear cookies
  Future<void> clearCookies() async {
    try {
      if (_cookieJar != null) {
        await _cookieJar!.deleteAll();
      }
    } catch (e) {
      AppLogger.error('Failed to clear cookies: $e');
    }
  }

  // Get current cookies
  Future<List<Cookie>> getCookies(String url) async {
    try {
      if (_cookieJar != null) {
        return await _cookieJar!.loadForRequest(Uri.parse(url));
      }
      return [];
    } catch (e) {
      AppLogger.error('Failed to get cookies: $e');
      return [];
    }
  }

  // Cancel all requests
  void cancelRequests() {
    _dio.interceptors.clear();
  }
}

// Auth interceptor for adding tokens to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      // Skip auth for login and other public endpoints
      final publicEndpoints = [
        ApiConfig.endpoints['login']!,
        ApiConfig.endpoints['refresh']!,
      ];
      
      final isPublicEndpoint = publicEndpoints.any((endpoint) => 
        options.path.contains(endpoint));
      
      if (!isPublicEndpoint) {
        // Get token from SharedPreferences directly to avoid circular dependency
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(ApiConfig.tokenKey);
        
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
          AppLogger.debug('Added auth token to request: ${options.path}');
        } else {
          AppLogger.warning('No auth token available for request: ${options.path}');
        }
      }
    } catch (e) {
      AppLogger.error('Error adding auth token: $e');
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized responses
    if (err.response?.statusCode == 401) {
      try {
        AppLogger.warning('Received 401, attempting token refresh');
        
        // Get refresh token directly from SharedPreferences to avoid circular dependency
        final prefs = await SharedPreferences.getInstance();
        final refreshToken = prefs.getString(ApiConfig.refreshTokenKey);
        
        if (refreshToken != null && refreshToken.isNotEmpty) {
          // Attempt token refresh
          final refreshResponse = await HttpService.instance._dio.post(
            ApiConfig.endpoints['refresh']!,
            data: {'refresh_token': refreshToken},
          );
          
          if (refreshResponse.statusCode == 200 && refreshResponse.data != null) {
            final responseData = refreshResponse.data;
            String? newToken;
            
            // Extract token from response (handle different response formats)
            if (responseData is Map<String, dynamic>) {
              newToken = responseData['token']?.toString() ?? 
                        responseData['access_token']?.toString();
              
              // Store new token
              if (newToken != null) {
                await prefs.setString(ApiConfig.tokenKey, newToken);
                
                // Retry original request with new token
                final requestOptions = err.requestOptions;
                requestOptions.headers['Authorization'] = 'Bearer $newToken';
                
                AppLogger.info('Retrying request with new token');
                
                final response = await HttpService.instance._dio.fetch(requestOptions);
                handler.resolve(response);
                return;
              }
            }
          }
        }
        
        AppLogger.error('Token refresh failed, forwarding 401 error');
      } catch (e) {
        AppLogger.error('Error during token refresh: $e');
      }
    }
    
    super.onError(err, handler);
  }
}

// Retry interceptor for handling failed requests
class RetryInterceptor extends Interceptor {
  final int maxRetries = AppConfig.maxRetryAttempts;
  final Duration retryDelay = AppConfig.retryDelay;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;
    
    // Get current retry count from extra data
    final retryCount = requestOptions.extra['retryCount'] ?? 0;
    
    // Only retry for certain types of errors
    final shouldRetry = _shouldRetry(err, retryCount);
    
    if (shouldRetry) {
      AppLogger.info('Retrying request (${retryCount + 1}/$maxRetries): ${requestOptions.path}');
      
      // Wait before retrying
      await Future.delayed(retryDelay * (retryCount + 1));
      
      // Update retry count
      requestOptions.extra['retryCount'] = retryCount + 1;
      
      try {
        // Retry the request
        final response = await HttpService.instance._dio.fetch(requestOptions);
        handler.resolve(response);
        return;
      } catch (e) {
        // If retry fails, continue with original error handling
        AppLogger.warning('Retry ${retryCount + 1} failed: $e');
      }
    }
    
    super.onError(err, handler);
  }
  
  bool _shouldRetry(DioException err, int retryCount) {
    // Don't retry if we've reached max attempts
    if (retryCount >= maxRetries) {
      return false;
    }
    
    // Don't retry for certain error types
    switch (err.type) {
      case DioExceptionType.cancel:
        return false; // Don't retry cancelled requests
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        // Don't retry client errors (4xx), but retry server errors (5xx)
        return statusCode != null && statusCode >= 500;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.unknown:
        return true; // Retry network-related errors
      default:
        return false;
    }
  }
}