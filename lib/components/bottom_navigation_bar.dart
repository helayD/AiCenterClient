import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../controllers/navigation_controller.dart';

/// 自定义底部导航栏组件
/// 基于Google Nav Bar实现现代化设计
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 获取本地化文本
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<NavigationController>(
      builder: (context, navigationController, child) {
        return Container(
          // 响应式边距调整 - MD3样式
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) 
                ? TW.space('2') 
                : TW.space('4'),
            vertical: TW.space('2'),
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity( 0.08),
                spreadRadius: 0,
                blurRadius: 4.0,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: SafeArea(
            child: GNav(
              // 基础配置
              selectedIndex: navigationController.selectedIndex,
              onTabChange: (index) => navigationController.setSelectedIndex(index),
              
              // 样式配置 - Material 3
              rippleColor: Theme.of(context).colorScheme.primary.withOpacity( 0.12),
              hoverColor: Theme.of(context).colorScheme.primary.withOpacity( 0.08),
              haptic: true,
              tabBorderRadius: TW.radius('md'),
              tabActiveBorder: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity( 0.2),
                width: 1,
              ),
              tabShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity( 0.15),
                  blurRadius: 2.0,
                  spreadRadius: 0,
                ),
              ],
              
              // 动画配置 - Material 3 标准动画
              curve: Curves.easeInOutCubicEmphasized,
              duration: const Duration(milliseconds: 200),
              
              // 外观配置 - MD3 设计规范
              gap: Responsive.isMobile(context) ? TW.space('1') : TW.space('2'),
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              activeColor: Theme.of(context).colorScheme.primary,
              iconSize: Responsive.isMobile(context) ? 20 : 24,
              textSize: Responsive.isMobile(context) ? 12 : 14,
              tabBackgroundColor: Theme.of(context).colorScheme.primaryContainer.withOpacity( 0.12),
              padding: EdgeInsets.symmetric(
                horizontal: Responsive.isMobile(context) ? TW.space('2') : TW.space('4'),
                vertical: TW.space('2'),
              ),
              
              // 导航项配置
              tabs: _buildNavigationTabs(context, l10n),
            ),
          ),
        );
      },
    );
  }

  /// 构建导航标签页
  List<GButton> _buildNavigationTabs(BuildContext context, AppLocalizations l10n) {
    return NavigationController.navigationItems.map((item) {
      return GButton(
        icon: Icons.home, // 占位图标，实际使用SVG
        leading: _buildTabIcon(context, item.icon),
        text: _getLocalizedLabel(l10n, item.labelKey),
        textStyle: TextStyle(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).colorScheme.onSurface,
          letterSpacing: 0.1,
        ),
      );
    }).toList();
  }

  /// 构建标签图标
  Widget _buildTabIcon(BuildContext context, String iconPath) {
    return SvgPicture.asset(
      iconPath,
      height: Responsive.isMobile(context) ? 18 : 22,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.onSurfaceVariant,
        BlendMode.srcIn,
      ),
    );
  }

  /// 获取本地化标签文本
  String _getLocalizedLabel(AppLocalizations l10n, String labelKey) {
    switch (labelKey) {
      case 'dashboard':
        return l10n.dashboard;
      case 'task':
        return l10n.task;
      case 'documents':
        return l10n.documents;
      case 'profile':
        return l10n.profile;
      case 'more':
        return l10n.more;
      default:
        return labelKey;
    }
  }
}