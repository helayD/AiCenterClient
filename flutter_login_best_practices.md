# Flutter登录页面最佳实践指南

## 1. 安全的登录表单设计模式

### 基础登录页面结构

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _buildLoginForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 32),
                _buildEmailField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                const SizedBox(height: 8),
                _buildForgotPasswordLink(),
                const SizedBox(height: 24),
                _buildLoginButton(),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],
                const SizedBox(height: 16),
                _buildSignUpLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            size: 40,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '欢迎回来',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '请输入您的凭据以登录',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      decoration: InputDecoration(
        labelText: '邮箱地址',
        prefixIcon: const Icon(Icons.email_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: _validateEmail,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: '密码',
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: _validatePassword,
      onFieldSubmitted: (_) => _handleLogin(),
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _handleForgotPassword,
        child: Text(
          '忘记密码？',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _handleLogin,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              '登录',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '还没有账户？',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: _handleSignUp,
          child: Text(
            '立即注册',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // 验证方法
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入邮箱地址';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return '请输入有效的邮箱地址';
    }
    
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return '请输入密码';
    }
    
    if (value.length < 6) {
      return '密码至少需要6个字符';
    }
    
    return null;
  }

  // 事件处理方法
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 使用Provider进行登录
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        // 登录成功，导航到主页
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
      });
      
      // 震动反馈
      HapticFeedback.lightImpact();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleForgotPassword() {
    Navigator.of(context).pushNamed('/forgot-password');
  }

  void _handleSignUp() {
    Navigator.of(context).pushNamed('/signup');
  }

  String _getErrorMessage(dynamic error) {
    // 根据错误类型返回用户友好的错误消息
    if (error.toString().contains('invalid-email')) {
      return '邮箱地址无效';
    } else if (error.toString().contains('user-not-found')) {
      return '用户不存在';
    } else if (error.toString().contains('wrong-password')) {
      return '密码错误';
    } else if (error.toString().contains('network')) {
      return '网络连接错误，请检查网络设置';
    } else {
      return '登录失败，请稍后重试';
    }
  }
}
```

## 2. Provider状态管理

### AuthProvider实现

```dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _token;
  User? _user;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  User? get user => _user;
  bool get isLoading => _isLoading;

  // 登录方法
  Future<void> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    
    try {
      // 调用API进行登录验证
      final response = await _authService.login(email, password);
      
      if (response.success) {
        _token = response.token;
        _user = response.user;
        _isAuthenticated = true;
        
        // 保存到本地存储
        await _saveToLocal();
        
        notifyListeners();
      } else {
        throw Exception(response.message);
      }
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
    
    _setLoading(false);
  }

  // 登出方法
  Future<void> logout() async {
    try {
      // 调用API登出
      await _authService.logout();
    } catch (e) {
      // 即使API调用失败，也要清除本地状态
      debugPrint('Logout API failed: $e');
    }
    
    // 清除状态
    _token = null;
    _user = null;
    _isAuthenticated = false;
    
    // 清除本地存储
    await _clearLocal();
    
    notifyListeners();
  }

  // 自动登录检查
  Future<void> checkAuthStatus() async {
    _setLoading(true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      if (token != null) {
        // 验证token是否有效
        final isValid = await _authService.validateToken(token);
        
        if (isValid) {
          _token = token;
          _isAuthenticated = true;
          
          // 获取用户信息
          _user = await _authService.getUserInfo();
        } else {
          // Token无效，清除本地存储
          await _clearLocal();
        }
      }
    } catch (e) {
      debugPrint('Auto login check failed: $e');
      await _clearLocal();
    }
    
    _setLoading(false);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> _saveToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    if (_token != null) {
      await prefs.setString('auth_token', _token!);
    }
    if (_user != null) {
      await prefs.setString('user_data', jsonEncode(_user!.toJson()));
    }
  }

  Future<void> _clearLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }
}
```

## 3. 响应式设计实现

### 响应式登录布局

```dart
class ResponsiveLoginPage extends StatelessWidget {
  const ResponsiveLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // 移动端布局
            return const MobileLoginLayout();
          } else if (constraints.maxWidth < 1200) {
            // 平板布局
            return const TabletLoginLayout();
          } else {
            // 桌面端布局
            return const DesktopLoginLayout();
          }
        },
      ),
    );
  }
}

class MobileLoginLayout extends StatelessWidget {
  const MobileLoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Spacer(),
            const LoginForm(),
            const Spacer(),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          '或使用社交账号登录',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _SocialLoginButton(
              icon: Icons.g_mobiledata,
              label: 'Google',
              onPressed: () {},
            ),
            _SocialLoginButton(
              icon: Icons.apple,
              label: 'Apple',
              onPressed: () {},
            ),
            _SocialLoginButton(
              icon: Icons.facebook,
              label: 'Facebook',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class DesktopLoginLayout extends StatelessWidget {
  const DesktopLoginLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧品牌区域
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: const Center(
              child: BrandSection(),
            ),
          ),
        ),
        // 右侧登录表单
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: LoginForm(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

## 4. 动画效果和用户体验

### 高级动画实现

```dart
class AnimatedLoginForm extends StatefulWidget {
  const AnimatedLoginForm({Key? key}) : super(key: key);

  @override
  State<AnimatedLoginForm> createState() => _AnimatedLoginFormState();
}

class _AnimatedLoginFormState extends State<AnimatedLoginForm>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // 启动动画
    _fadeController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: const LoginForm(),
      ),
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
}

// 交互式按钮动画
class AnimatedLoginButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String text;

  const AnimatedLoginButton({
    Key? key,
    this.onPressed,
    required this.isLoading,
    required this.text,
  }) : super(key: key);

  @override
  State<AnimatedLoginButton> createState() => _AnimatedLoginButtonState();
}

class _AnimatedLoginButtonState extends State<AnimatedLoginButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: widget.isLoading ? 0 : 4,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: widget.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    widget.text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

## 5. 安全性最佳实践

### 安全配置和实现

```dart
class SecureAuthService {
  static const String _baseUrl = 'https://api.yourapp.com';
  final Dio _dio = Dio();

  SecureAuthService() {
    _configureDio();
  }

  void _configureDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    // 添加拦截器
    _dio.interceptors.add(LogInterceptor(
      requestBody: false, // 不记录请求体，避免敏感信息泄露
      responseBody: false,
    ));

    // 证书固定（在生产环境中）
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (cert, host, port) {
        // 在生产环境中验证证书
        return _isValidCertificate(cert, host);
      };
      return client;
    };
  }

  bool _isValidCertificate(cert, String host) {
    // 实现证书验证逻辑
    // 这里应该验证证书的指纹或公钥
    return true; // 简化示例
  }

  // 安全的登录方法
  Future<AuthResponse> login(String email, String password) async {
    try {
      // 1. 输入验证
      _validateInput(email, password);

      // 2. 密码哈希（可选，通常在服务端进行）
      final hashedPassword = _hashPassword(password);

      // 3. 发送请求
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email.toLowerCase().trim(),
          'password': hashedPassword,
          'device_info': await _getDeviceInfo(),
        },
      );

      // 4. 验证响应
      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        
        // 5. 存储token（使用安全存储）
        await _secureStorage.write(
          key: 'auth_token',
          value: authResponse.token,
        );

        return authResponse;
      } else {
        throw AuthException('登录失败');
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AuthException('未知错误：$e');
    }
  }

  void _validateInput(String email, String password) {
    // 邮箱验证
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw AuthException('邮箱格式无效');
    }

    // 密码强度验证
    if (password.length < 8) {
      throw AuthException('密码至少需要8个字符');
    }

    // 检查常见弱密码
    final weakPasswords = ['12345678', 'password', 'qwerty123'];
    if (weakPasswords.contains(password.toLowerCase())) {
      throw AuthException('密码过于简单，请使用更强的密码');
    }
  }

  String _hashPassword(String password) {
    // 客户端密码哈希（可选）
    // 注意：主要的密码哈希应该在服务端进行
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> _getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();
    final packageInfo = await PackageInfo.fromPlatform();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return {
        'platform': 'android',
        'device_id': androidInfo.id,
        'model': androidInfo.model,
        'app_version': packageInfo.version,
      };
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return {
        'platform': 'ios',
        'device_id': iosInfo.identifierForVendor,
        'model': iosInfo.model,
        'app_version': packageInfo.version,
      };
    }

    return {
      'platform': 'unknown',
      'app_version': packageInfo.version,
    };
  }

  AuthException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return AuthException('网络连接超时');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) {
          return AuthException('邮箱或密码错误');
        } else if (statusCode == 429) {
          return AuthException('登录尝试过于频繁，请稍后再试');
        } else {
          return AuthException('服务器错误');
        }
      default:
        return AuthException('网络连接失败');
    }
  }
}

// 生物识别登录
class BiometricAuthService {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      
      return isAvailable && availableBiometrics.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticateWithBiometric() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: '请使用生物识别验证身份',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      return false;
    }
  }
}
```

## 6. 错误处理和用户体验

### 全面的错误处理

```dart
class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message;
    IconData icon;
    Color color;

    if (error is AuthException) {
      message = error.message;
      icon = Icons.error_outline;
      color = Colors.red;
    } else if (error is NetworkException) {
      message = '网络连接失败，请检查网络设置';
      icon = Icons.wifi_off;
      color = Colors.orange;
    } else {
      message = '发生未知错误，请稍后重试';
      icon = Icons.warning;
      color = Colors.grey;
    }

    _showErrorSnackBar(context, message, icon, color);
  }

  static void _showErrorSnackBar(
    BuildContext context,
    String message,
    IconData icon,
    Color color,
  ) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: '关闭',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

// 自定义异常类
class AuthException implements Exception {
  final String message;
  final String? code;

  AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException: $message';
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}
```

## 7. 完整的应用入口配置

### main.dart配置

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化Firebase（如果使用）
  // await Firebase.initializeApp();
  
  // 设置系统UI样式
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flutter登录示例',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/signup': (context) => const SignUpPage(),
              '/home': (context) => const HomePage(),
              '/forgot-password': (context) => const ForgotPasswordPage(),
            },
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const SplashScreen();
        }

        if (authProvider.isAuthenticated) {
          return const HomePage();
        } else {
          return const LoginPage();
        }
      },
    );
  }
}
```

这个完整的Flutter登录页面最佳实践包含了：

✅ **安全设计** - 输入验证、密码哈希、HTTPS通信
✅ **响应式布局** - 适配手机、平板、桌面端
✅ **Provider状态管理** - 清晰的状态管理模式
✅ **优雅动画** - 流畅的用户体验
✅ **错误处理** - 全面的异常处理机制
✅ **生物识别** - 现代认证方式
✅ **可维护性** - 清晰的代码结构和文档

这些实践遵循了Flutter官方推荐的模式，并结合了现代移动应用开发的最佳实践。