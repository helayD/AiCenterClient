import 'package:admin/config/font_config.dart';
import 'package:admin/controllers/auth_controller.dart';
import 'package:admin/controllers/locale_controller.dart';
import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/controllers/navigation_controller.dart';
import 'package:admin/controllers/theme_controller.dart';
import 'package:admin/screens/auth/login_screen.dart';
import 'package:admin/screens/main/main_screen.dart';
import 'package:admin/components/md3_page_transitions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocaleController()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeController()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => MenuAppController(),
        ),
        ChangeNotifierProvider(
          create: (context) => NavigationController(),
        ),
      ],
      child: AppWrapper(),
    );
  }
}

class AppWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleController, ThemeController>(
      builder: (context, localeController, themeController, child) {
        return MD3ThemeTransition(
          themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          child: MD3LocaleTransition(
            locale: localeController.currentLocale,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Admin Panel',
              
              // Internationalization configuration
              locale: localeController.currentLocale,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: LocaleController.supportedLocales,
              
              // Theme configuration
              theme: themeController.lightTheme,
              darkTheme: themeController.darkTheme,
              themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              
              home: AuthWrapper(),
            ),
          ),
        );
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        if (authController.isAuthenticated) {
          return MainScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }
}
