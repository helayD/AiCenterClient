import 'package:admin/controllers/auth_controller.dart';
import 'package:admin/components/theme_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../components/b2b_modern_container.dart';
import '../../../theme/tailwind_colors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: Column(
        children: [
          // 现代化B2B头部区域
          Container(
            height: 180,
            padding: EdgeInsets.all(TechSpacing.xl),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  TailwindSemanticColors.primary,
                  TailwindSemanticColors.primary.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 现代化logo容器
                Container(
                  height: 64,
                  width: 64,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity( 0.2),
                        Colors.white.withOpacity( 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(TechRadius.lg),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(TechSpacing.md),
                    child: Image.asset(
                      "assets/images/logo.png",
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: TechSpacing.md),
                
                // 用户信息显示区域
                Consumer<AuthController>(
                  builder: (context, authController, child) {
                    final l10n = AppLocalizations.of(context)!;
                    return Column(
                      children: [
                        Text(
                          authController.userEmail ?? l10n.administrator,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: TechSpacing.xs),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: TechSpacing.md,
                            vertical: TechSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(TechRadius.sm),
                          ),
                          child: Text(
                            "企业管理员",
                            style: TextStyle(
                              color: Colors.white.withOpacity( 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItems(context),
                SizedBox(height: defaultPadding),
                // Theme selector
                ThemeSelector(),
                SizedBox(height: defaultPadding),
              ],
            ),
          ),
          // 现代化注销区域
          Container(
            padding: EdgeInsets.all(TechSpacing.lg),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor.withOpacity( 0.2),
                  width: 1,
                ),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.surface,
                  theme.colorScheme.surfaceVariant.withOpacity( 0.3),
                ],
              ),
            ),
            child: DrawerListTile(
              title: AppLocalizations.of(context)!.logout,
              svgSrc: "assets/icons/menu_setting.svg",
              press: () => _showLogoutDialog(context),
              isLogout: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        DrawerListTile(
          title: l10n.dashboard,
          svgSrc: "assets/icons/menu_dashboard.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.transaction,
          svgSrc: "assets/icons/menu_tran.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.task,
          svgSrc: "assets/icons/menu_task.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.documents,
          svgSrc: "assets/icons/menu_doc.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.store,
          svgSrc: "assets/icons/menu_store.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.notification,
          svgSrc: "assets/icons/menu_notification.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.profile,
          svgSrc: "assets/icons/menu_profile.svg",
          press: () {},
        ),
        DrawerListTile(
          title: l10n.settings,
          svgSrc: "assets/icons/menu_setting.svg",
          press: () {},
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            l10n.confirmLogout,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          content: Text(
            l10n.logoutConfirmation,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<AuthController>().logout();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.logoutSuccess),
                    backgroundColor: primaryColor,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.logout),
            ),
          ],
        );
      },
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.press,
    this.isLogout = false,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isLogout ? TailwindColors.red500 : TailwindSemanticColors.primary;
    
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TechSpacing.md,
        vertical: TechSpacing.xs,
      ),
      child: B2BModernContainer(
        onTap: press,
        statusColor: color,
        showStatusBar: false,
        padding: EdgeInsets.symmetric(
          horizontal: TechSpacing.lg,
          vertical: TechSpacing.md,
        ),
        elevation: 1.0,
        child: Row(
          children: [
            // 现代化图标容器
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity( 0.15),
                    color.withOpacity( 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(TechRadius.sm),
                border: Border.all(
                  color: color.withOpacity( 0.2),
                  width: 1,
                ),
              ),
              child: _buildMenuIcon(color),
            ),
            
            SizedBox(width: TechSpacing.lg),
            
            // 菜单标题
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isLogout 
                      ? TailwindColors.red500
                      : theme.colorScheme.onSurface,
                  letterSpacing: -0.1,
                ),
              ),
            ),
            
            // 指示箭头
            Container(
              padding: EdgeInsets.all(TechSpacing.xs),
              decoration: BoxDecoration(
                color: color.withOpacity( 0.1),
                borderRadius: BorderRadius.circular(TechRadius.xs),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuIcon(Color color) {
    // 根据不同菜单项返回对应的现代图标
    IconData iconData;
    switch (title.toLowerCase()) {
      case '仪表板':
      case 'dashboard':
        iconData = Icons.dashboard_outlined;
        break;
      case '交易':
      case 'transaction':
        iconData = Icons.account_balance_wallet_outlined;
        break;
      case '任务':
      case 'task':
        iconData = Icons.task_alt_outlined;
        break;
      case '文档':
      case 'documents':
        iconData = Icons.description_outlined;
        break;
      case '商店':
      case 'store':
        iconData = Icons.storefront_outlined;
        break;
      case '通知':
      case 'notification':
        iconData = Icons.notifications_outlined;
        break;
      case '个人资料':
      case 'profile':
        iconData = Icons.person_outline;
        break;
      case '设置':
      case 'settings':
        iconData = Icons.settings_outlined;
        break;
      case '登出':
      case 'logout':
        iconData = Icons.logout_outlined;
        break;
      default:
        iconData = Icons.menu_outlined;
    }
    
    return Icon(
      iconData,
      color: color,
      size: 20,
    );
  }
}
