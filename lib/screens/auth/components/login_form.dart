import 'package:admin/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../utils/md3_accessibility.dart';
import '../../../components/md3_enhanced_buttons.dart';
import '../../../theme/tailwind_colors.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Semantics(
            label: MD3Accessibility.createSemanticLabel(
              baseText: l10n.login,
              role: "登录表单",
              description: "填写邮箱和密码进行登录",
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Email field
                _buildEmailField(authController),
                SizedBox(height: defaultPadding),
                
                // Password field
                _buildPasswordField(authController),
                SizedBox(height: defaultPadding / 2),
                
                // Forgot password
                _buildForgotPasswordButton(),
                SizedBox(height: defaultPadding),
                
                // Error message
                if (authController.errorMessage != null)
                  _buildErrorMessage(authController.errorMessage!),
                
                // Login button
                _buildLoginButton(authController),
                SizedBox(height: defaultPadding),
                
                // Demo credentials info
                _buildDemoInfo(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmailField(AuthController authController) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return MD3AccessibleTextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) => authController.validateEmail(value, context),
      onChanged: (_) => authController.clearError(),
      semanticLabel: MD3Accessibility.createSemanticLabel(
        baseText: l10n.emailAddress,
        role: "邮箱输入框",
        description: "输入您的邮箱地址",
      ),
      hint: "填写完整的邮箱地址，例如 admin@example.com",
      decoration: InputDecoration(
        labelText: l10n.emailAddress,
        hintText: l10n.emailHint,
        prefixIcon: Icon(
          Icons.email_outlined, 
          color: theme.colorScheme.primary,
          semanticLabel: "邮箱图标",
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: MD3Accessibility.getAccessibleTextColor(
            theme.colorScheme.surfaceContainer,
            preferredColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildPasswordField(AuthController authController) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return MD3AccessibleTextField(
      controller: _passwordController,
      obscureText: authController.obscurePassword,
      textInputAction: TextInputAction.done,
      validator: (value) => authController.validatePassword(value, context),
      onChanged: (_) => authController.clearError(),
      onSubmitted: (_) => _handleLogin(),
      semanticLabel: MD3Accessibility.createSemanticLabel(
        baseText: l10n.password,
        role: "密码输入框",
        description: authController.obscurePassword ? "密码已隐藏" : "密码可见",
      ),
      hint: "输入您的登录密码",
      decoration: InputDecoration(
        labelText: l10n.password,
        hintText: l10n.passwordHint,
        prefixIcon: Icon(
          Icons.lock_outline, 
          color: theme.colorScheme.primary,
          semanticLabel: "密码图标",
        ),
        suffixIcon: MD3AccessibleButton(
          onPressed: authController.togglePasswordVisibility,
          semanticLabel: authController.obscurePassword 
              ? "显示密码" 
              : "隐藏密码",
          tooltip: authController.obscurePassword 
              ? "点击显示密码" 
              : "点击隐藏密码",
          child: Icon(
            authController.obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: theme.colorScheme.onSurfaceVariant,
            semanticLabel: authController.obscurePassword 
                ? "显示密码图标" 
                : "隐藏密码图标",
          ),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(TechRadius.md),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(
          color: MD3Accessibility.getAccessibleTextColor(
            theme.colorScheme.surfaceContainer,
            preferredColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    final l10n = AppLocalizations.of(context)!;
    
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          // TODO: Implement forgot password
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.forgotPasswordDevelopment),
              backgroundColor: primaryColor,
            ),
          );
        },
        child: Text(
          l10n.forgotPassword,
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Container(
      margin: EdgeInsets.only(bottom: defaultPadding),
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
          SizedBox(width: defaultPadding / 2),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton(AuthController authController) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 56,
      child: MD3ElevatedButton(
        onPressed: authController.isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: MD3Accessibility.getAccessibleTextColor(
            theme.colorScheme.primary,
            preferredColor: theme.colorScheme.onPrimary,
          ),
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TechRadius.full),
          ),
          shadowColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          padding: EdgeInsets.symmetric(
            horizontal: TechSpacing.lg,
            vertical: TechSpacing.md,
          ),
        ),
        child: Semantics(
          label: authController.isLoading 
              ? MD3Accessibility.createSemanticLabel(
                  baseText: l10n.loggingIn,
                  state: "正在加载",
                  description: "请等待登录处理完成",
                )
              : MD3Accessibility.createSemanticLabel(
                  baseText: l10n.login,
                  role: "主要操作按钮",
                  description: "点击进行登录",
                ),
          child: authController.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          MD3Accessibility.getAccessibleTextColor(
                            theme.colorScheme.primary,
                            preferredColor: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: defaultPadding),
                    Text(
                      l10n.loggingIn,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      semanticsLabel: "正在登录，请稍候",
                    ),
                  ],
                )
              : Text(
                  l10n.login,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: "登录按钮",
                ),
        ),
      ),
    );
  }

  Widget _buildDemoInfo() {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: primaryColor, size: 18),
              SizedBox(width: defaultPadding / 2),
              Text(
                AppLocalizations.of(context)!.demoAccount,
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding / 2),
          Text(
            AppLocalizations.of(context)!.demoEmail,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          Text(
            AppLocalizations.of(context)!.demoPassword,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authController = context.read<AuthController>();
      
      final success = await authController.login(
        _emailController.text.trim(),
        _passwordController.text,
        context,
        rememberMe: false, // You can add a checkbox for this if needed
      );

      // 登录成功后AuthWrapper会自动处理导航跳转
    }
  }
}