// Helper function to safely parse integers
int? _parseToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

// API Response models
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;
  final int? statusCode;
  final Map<String, dynamic>? meta;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
    this.statusCode,
    this.meta,
  });

  factory ApiResponse.success(T data, {String? message, int? statusCode, Map<String, dynamic>? meta}) {
    return ApiResponse(
      success: true,
      data: data,
      message: message,
      statusCode: statusCode,
      meta: meta,
    );
  }

  factory ApiResponse.error(String error, {int? statusCode, Map<String, dynamic>? meta}) {
    return ApiResponse(
      success: false,
      error: error,
      statusCode: statusCode,
      meta: meta,
    );
  }

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic)? fromJsonT) {
    try {
      return ApiResponse(
        success: json['success'] ?? json['status'] == 'success' ?? false,
        data: fromJsonT != null && json['data'] != null ? fromJsonT(json['data']) : json['data'],
        message: json['message']?.toString(),
        error: json['error']?.toString() ?? json['message']?.toString(),
        statusCode: _parseToInt(json['status_code']) ?? _parseToInt(json['code']),
        meta: json['meta'] as Map<String, dynamic>?,
      );
    } catch (e) {
      return ApiResponse.error('Failed to parse response: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data,
      'message': message,
      'error': error,
      'status_code': statusCode,
      'meta': meta,
    };
  }

  @override
  String toString() {
    return 'ApiResponse(success: $success, data: $data, message: $message, error: $error)';
  }
}

// Login request model
class LoginRequest {
  final String identifier;
  final String password;
  final bool rememberMe;

  const LoginRequest({
    required this.identifier,
    required this.password,
    this.rememberMe = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'identifier': identifier,
      'password': password,
      'remember_me': rememberMe,
    };
  }
}

// Login response model
class LoginResponse {
  final String? token;
  final String? refreshToken;
  final UserData? user;
  final Map<String, dynamic>? permissions;
  final int? expiresIn;

  const LoginResponse({
    this.token,
    this.refreshToken,
    this.user,
    this.permissions,
    this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token']?.toString() ?? json['access_token']?.toString(),
      refreshToken: json['refresh_token']?.toString(),
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      permissions: json['permissions'] as Map<String, dynamic>?,
      expiresIn: _parseToInt(json['expires_in']) ?? _parseToInt(json['expire']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': user?.toJson(),
      'permissions': permissions,
      'expires_in': expiresIn,
    };
  }
}

// User data model
class UserData {
  final int? id;
  final String? email;
  final String? username;
  final String? name;
  final String? avatar;
  final String? role;
  final Map<String, dynamic>? profile;
  final DateTime? lastLogin;
  final DateTime? createdAt;

  const UserData({
    this.id,
    this.email,
    this.username,
    this.name,
    this.avatar,
    this.role,
    this.profile,
    this.lastLogin,
    this.createdAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: _parseToInt(json['id']) ?? _parseToInt(json['user_id']),
      email: json['email']?.toString(),
      username: json['username']?.toString() ?? json['identifier']?.toString(),
      name: json['name']?.toString() ?? json['display_name']?.toString(),
      avatar: json['avatar']?.toString() ?? json['avatar_url']?.toString(),
      role: json['role']?.toString() ?? json['user_role']?.toString(),
      profile: json['profile'] as Map<String, dynamic>?,
      lastLogin: json['last_login'] != null ? DateTime.tryParse(json['last_login']) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'name': name,
      'avatar': avatar,
      'role': role,
      'profile': profile,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'UserData(id: $id, email: $email, username: $username, name: $name)';
  }
}