import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants.dart';
import '../../responsive.dart';
import '../../controllers/auth_controller.dart';
import '../../components/theme_selector.dart';
import '../../components/b2b_modern_container.dart';
import '../../theme/tailwind_colors.dart';

/// 更多页面 - 容纳次要功能和系统设置
class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题
              Text(
                l10n.more,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
              SizedBox(height: defaultPadding),
              
              // 用户信息卡片
              _buildUserInfoCard(context),
              SizedBox(height: defaultPadding),
              
              // 功能网格
              Expanded(
                child: _buildFunctionGrid(context, l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建用户信息卡片
  Widget _buildUserInfoCard(BuildContext context) {
    return Consumer<AuthController>(
      builder: (context, authController, child) {
        final l10n = AppLocalizations.of(context)!;
        
        return B2BModernContainer(
          statusColor: TailwindColors.green500,  // Tailwind绿色 - 账户信息
          showStatusBar: true,
          showHoverEffect: true,
          padding: EdgeInsets.all(defaultPadding),
          child: Row(
            children: [
              // 用户头像容器 - 使用渐变背景
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [TailwindColors.green500, TailwindColors.cyan500],
                  ),
                  borderRadius: BorderRadius.circular(TechRadius.sm),
                  boxShadow: [
                    BoxShadow(
                      color: TailwindColors.green500.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(TechSpacing.sm),
                  child: Image.asset("assets/images/logo.png"),
                ),
              ),
              SizedBox(width: TechSpacing.md),
              
              // 用户信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authController.userEmail ?? l10n.administrator,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: TechSpacing.xs),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: TechSpacing.sm,
                        vertical: TechSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: TailwindColors.green500.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(TechRadius.xs),
                      ),
                      child: Text(
                        l10n.administrator,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: TailwindColors.green500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 构建功能网格 - 智能响应式布局
  Widget _buildFunctionGrid(BuildContext context, AppLocalizations l10n) {
    final functions = _getFunctions(context, l10n);
    final screenSize = MediaQuery.of(context).size;
    
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getFunctionGridCrossAxisCount(screenSize.width),
        crossAxisSpacing: TechSpacing.md,
        mainAxisSpacing: TechSpacing.md,
        childAspectRatio: _getFunctionGridChildAspectRatio(screenSize.width),
      ),
      itemCount: functions.length,
      itemBuilder: (context, index) {
        final function = functions[index];
        return _buildFunctionCard(context, function);
      },
    );
  }

  /// 动态计算功能网格列数
  int _getFunctionGridCrossAxisCount(double width) {
    if (width < 400) return 1;      // 超小移动屏：1列，大卡片
    if (width < 600) return 2;      // 移动屏：2列
    if (width < 900) return 3;      // 平板屏：3列  
    if (width < 1200) return 3;     // 小桌面：3列
    return 4;                       // 大桌面：4列
  }

  /// 动态计算功能网格宽高比
  double _getFunctionGridChildAspectRatio(double width) {
    if (width < 400) return 1.6;    // 超小屏：高卡片，更好的可读性
    if (width < 600) return 1.3;    // 移动屏：平衡比例
    if (width < 900) return 1.2;    // 平板屏：紧凑
    return 1.1;                     // 桌面屏：方形趋势
  }

  /// 构建功能卡片 - 使用Tailwind设计
  Widget _buildFunctionCard(BuildContext context, MoreFunction function) {
    final tailwindColor = _mapToTailwindColor(function.color);
    
    return B2BModernContainer(
      statusColor: tailwindColor,
      showStatusBar: true,
      showHoverEffect: true,
      padding: EdgeInsets.all(TechSpacing.md),
      onTap: function.onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 图标容器 - 使用渐变背景
          Container(
            padding: EdgeInsets.all(TechSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tailwindColor,
                  tailwindColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(TechRadius.sm),
              boxShadow: [
                BoxShadow(
                  color: tailwindColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: function.isAsset
                ? SvgPicture.asset(
                    function.icon,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    function.iconData,
                    size: 24,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: TechSpacing.md),
          
          // 标题
          Text(
            function.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// 将传统颜色映射到Tailwind色彩
  Color _mapToTailwindColor(Color originalColor) {
    if (originalColor == Colors.blue) {
      return TailwindColors.blue500;      // 蓝色功能 -> Tailwind蓝
    } else if (originalColor == Colors.green) {
      return TailwindColors.green500;     // 绿色功能 -> Tailwind绿
    } else if (originalColor == Colors.orange) {
      return TailwindColors.orange500;    // 橙色功能 -> Tailwind橙
    } else if (originalColor == Colors.grey) {
      return TailwindColors.slate500;     // 灰色功能 -> Tailwind灰
    } else if (originalColor == primaryColor) {
      return TailwindColors.cyan500;      // 主色功能 -> Tailwind青
    } else if (originalColor == Colors.red || originalColor == Colors.redAccent) {
      return TailwindColors.red500;       // 红色功能 -> Tailwind红
    } else {
      return TailwindColors.blue600;      // 默认 -> Tailwind深蓝
    }
  }

  /// 获取功能列表
  List<MoreFunction> _getFunctions(BuildContext context, AppLocalizations l10n) {
    return [
      // 次要功能
      MoreFunction(
        title: l10n.transaction,
        icon: "assets/icons/menu_tran.svg",
        color: Colors.blue,
        onTap: () => _showDevelopmentMessage(context, l10n.transaction),
        isAsset: true,
      ),
      MoreFunction(
        title: l10n.store,
        icon: "assets/icons/menu_store.svg", 
        color: Colors.green,
        onTap: () => _showDevelopmentMessage(context, l10n.store),
        isAsset: true,
      ),
      MoreFunction(
        title: l10n.notification,
        icon: "assets/icons/menu_notification.svg",
        color: Colors.orange,
        onTap: () => _showDevelopmentMessage(context, l10n.notification),
        isAsset: true,
      ),
      MoreFunction(
        title: l10n.settings,
        icon: "assets/icons/menu_setting.svg",
        color: Colors.grey,
        onTap: () => _showDevelopmentMessage(context, l10n.settings),
        isAsset: true,
      ),
      
      // 系统功能
      MoreFunction(
        title: l10n.themeMode,
        iconData: Icons.palette_outlined,
        color: primaryColor,
        onTap: () => _showThemeSelector(context),
        isAsset: false,
      ),
      MoreFunction(
        title: l10n.logout,
        iconData: Icons.logout_outlined,
        color: Colors.red,
        onTap: () => _showLogoutDialog(context),
        isAsset: false,
      ),
    ];
  }

  /// 显示开发中提示
  void _showDevelopmentMessage(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature功能开发中...'),
        backgroundColor: primaryColor,
      ),
    );
  }

  /// 显示主题选择器
  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ThemeSelector(),
            SizedBox(height: defaultPadding),
          ],
        ),
      ),
    );
  }

  /// 显示退出登录对话框
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
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                l10n.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity( 0.7),
                ),
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

/// 更多功能数据模型
class MoreFunction {
  final String title;
  final String icon;
  final IconData? iconData;
  final Color color;
  final VoidCallback onTap;
  final bool isAsset;

  const MoreFunction({
    required this.title,
    this.icon = '',
    this.iconData,
    required this.color,
    required this.onTap,
    this.isAsset = true,
  });
}