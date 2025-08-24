import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';

/// 占位页面组件 - 用于尚未实现的功能页面
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color? iconColor;

  const PlaceholderScreen({
    Key? key,
    required this.title,
    required this.iconPath,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 大图标
              Container(
                width: Responsive.isMobile(context) ? 120 : 150,
                height: Responsive.isMobile(context) ? 120 : 150,
                padding: EdgeInsets.all(defaultPadding * 2),
                decoration: BoxDecoration(
                  color: (iconColor ?? primaryColor).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    iconColor ?? primaryColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              
              SizedBox(height: defaultPadding * 2),
              
              // 标题
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: defaultPadding),
              
              // 描述文本
              Text(
                '${title}功能正在开发中...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
              
              SizedBox(height: defaultPadding * 2),
              
              // 开发中指示器
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: (iconColor ?? primaryColor).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          iconColor ?? primaryColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '开发中',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: iconColor ?? primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 任务页面
class TaskScreen extends StatelessWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderScreen(
      title: l10n.task,
      iconPath: "assets/icons/menu_task.svg",
      iconColor: Colors.blue,
    );
  }
}

/// 文档页面
class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderScreen(
      title: l10n.documents,
      iconPath: "assets/icons/menu_doc.svg",
      iconColor: Colors.green,
    );
  }
}

/// 个人资料页面
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PlaceholderScreen(
      title: l10n.profile,
      iconPath: "assets/icons/menu_profile.svg",
      iconColor: Colors.purple,
    );
  }
}