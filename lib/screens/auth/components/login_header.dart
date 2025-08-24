import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants.dart';

class LoginHeader extends StatelessWidget {
  final bool showLogo;

  const LoginHeader({
    Key? key,
    this.showLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        if (showLogo) ...[
          Container(
            height: Responsive.isMobile(context) ? 80 : 100,
            width: Responsive.isMobile(context) ? 80 : 100,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: Image.asset(
                "assets/images/logo.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: defaultPadding),
        ],
        Text(
          l10n.adminLogin,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: defaultPadding / 2),
        Text(
          l10n.loginDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white70,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}