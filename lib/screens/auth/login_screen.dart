import 'package:admin/controllers/auth_controller.dart';
import 'package:admin/responsive.dart';
import 'package:admin/screens/auth/components/login_form.dart';
import 'package:admin/screens/auth/components/login_header.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../components/b2b_modern_container.dart';
import '../../theme/tailwind_colors.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  TailwindSemanticColors.background,
                  TailwindSemanticColors.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Responsive(
                mobile: _buildMobileLayout(context),
                tablet: _buildTabletLayout(context),
                desktop: _buildDesktopLayout(context),
              ),
            ),
          ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(defaultPadding),
      child: Column(
        children: [
          SizedBox(height: defaultPadding * 2),
          LoginHeader(),
          SizedBox(height: defaultPadding * 3),
          Container(
            constraints: BoxConstraints(maxWidth: 400),
            child: LoginForm(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding * 2),
        child: Container(
          constraints: BoxConstraints(maxWidth: 500),
          child: B2BModernContainer(
            statusColor: TailwindColors.blue600,  // Tailwind蓝色 - 登录认证
            showStatusBar: true,
            showHoverEffect: true,
            padding: EdgeInsets.all(defaultPadding * 2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LoginHeader(),
                SizedBox(height: defaultPadding * 2),
                LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Row(
      children: [
        // Left side - Branding/Welcome
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.welcomeBack,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: defaultPadding),
                Text(
                  l10n.manageDataAndAnalytics,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                SizedBox(height: defaultPadding * 2),
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/logo.png",
                      height: 120,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Right side - Login Form
        Expanded(
          flex: 2,
          child: Container(
            color: TailwindSemanticColors.surface,
            padding: EdgeInsets.all(defaultPadding * 3),
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginHeader(showLogo: false),
                    SizedBox(height: defaultPadding * 2),
                    LoginForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}