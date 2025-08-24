import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../controllers/navigation_controller.dart';
import '../controllers/auth_controller.dart';
import '../utils/md3_accessibility.dart';

/// 自定义顶部AppBar组件
/// 支持响应式设计和动态标题显示
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer2<NavigationController, AuthController>(
      builder: (context, navigationController, authController, child) {
        return Semantics(
          container: true,
          header: true,
          label: MD3Accessibility.createSemanticLabel(
            baseText: "应用顶部导航栏",
            role: "导航标题栏",
            description: "包含页面标题和用户信息",
          ),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: MD3Accessibility.getAccessibleTextColor(
              Theme.of(context).colorScheme.surface,
              preferredColor: Theme.of(context).colorScheme.onSurface,
            ),
            elevation: 0.0,
            scrolledUnderElevation: 2.0,
            surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
            
            // 标题配置
            title: _buildTitle(context, navigationController, l10n),
            centerTitle: Responsive.isMobile(context),
            
            // 左侧图标 - 仅在移动端显示
            leading: Responsive.isMobile(context) ? _buildLeading(context, l10n) : null,
            
            // 右侧操作按钮
            actions: _buildActions(context, authController),
            
            // 底部分割线 - Material 3样式
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(
                height: 1,
                thickness: 1,
                color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建标题
  Widget _buildTitle(
    BuildContext context,
    NavigationController navigationController,
    AppLocalizations l10n,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo - 仅在桌面端显示 - MD3样式
        if (!Responsive.isMobile(context)) ...[
          Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(TW.radius('sm')),
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: Image.asset("assets/images/logo.png"),
            ),
          ),
          SizedBox(width: TW.space('2')),
        ],
        
        // 当前页面标题
        Text(
          _getCurrentPageTitle(navigationController, l10n),
          style: TextStyle(
            fontSize: Responsive.isMobile(context) ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// 构建左侧图标（移动端）
  Widget _buildLeading(BuildContext context, AppLocalizations l10n) {
    return Semantics(
      label: MD3Accessibility.createSemanticLabel(
        baseText: "管理面板",
        role: "应用图标",
        description: "点击返回主页",
      ),
      button: true,
      child: Container(
        margin: EdgeInsets.all(TW.space('2')),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(TW.radius('sm')),
        ),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Image.asset(
            "assets/images/logo.png",
            semanticLabel: "管理面板标志",
          ),
        ),
      ),
    );
  }

  /// 构建右侧操作按钮
  List<Widget> _buildActions(BuildContext context, AuthController authController) {
    return [
      // 桌面端显示用户信息
      if (!Responsive.isMobile(context))
        _buildUserInfo(context, authController),
      
      SizedBox(width: defaultPadding / 2),
    ];
  }

  /// 构建用户信息（桌面端）
  Widget _buildUserInfo(BuildContext context, AuthController authController) {
    final l10n = AppLocalizations.of(context)!;
    final userName = authController.userEmail?.split('@').first ?? l10n.administrator;
    
    return Semantics(
      label: MD3Accessibility.createSemanticLabel(
        baseText: "当前用户: $userName",
        role: "用户信息",
        description: "点击查看用户菜单",
      ),
      button: true,
      child: Tooltip(
        message: "用户: $userName\n邮箱: ${authController.userEmail ?? '未知'}",
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: TW.space('2'),
            vertical: TW.space('1'),
          ),
          margin: EdgeInsets.symmetric(vertical: TW.space('2')),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(TW.radius('xl')),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant,
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 用户头像
              Semantics(
                label: "$userName 的头像",
                image: true,
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    (authController.userEmail?.substring(0, 1).toUpperCase()) ?? 'A',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: MD3Accessibility.getAccessibleTextColor(
                        Theme.of(context).colorScheme.primary,
                        preferredColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    semanticsLabel: "$userName 用户头像字母",
                  ),
                ),
              ),
              SizedBox(width: TW.space('1') + 2),
              
              // 用户名
              Text(
                userName,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: MD3Accessibility.getAccessibleTextColor(
                    Theme.of(context).colorScheme.surfaceContainer,
                    preferredColor: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                semanticsLabel: "用户名: $userName",
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 获取当前页面标题
  String _getCurrentPageTitle(
    NavigationController navigationController,
    AppLocalizations l10n,
  ) {
    switch (navigationController.selectedIndex) {
      case 0:
        return l10n.dashboard;
      case 1:
        return l10n.task;
      case 2:
        return l10n.documents;
      case 3:
        return l10n.profile;
      case 4:
        return l10n.more;
      default:
        return l10n.dashboard;
    }
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 1);
}