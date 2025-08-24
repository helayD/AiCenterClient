import 'package:flutter/material.dart';

/// 导航页面管理控制器
/// 管理底部导航栏的状态和页面切换
class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;

  /// 当前选中的页面索引
  int get selectedIndex => _selectedIndex;

  /// 页面列表定义
  /// 0: Dashboard (仪表板)
  /// 1: Task (任务) 
  /// 2: Documents (文档)
  /// 3: Profile (个人资料)
  /// 4: More (更多)
  static const List<NavigationItem> navigationItems = [
    NavigationItem(
      index: 0,
      icon: 'assets/icons/menu_dashboard.svg',
      labelKey: 'dashboard',
    ),
    NavigationItem(
      index: 1,
      icon: 'assets/icons/menu_task.svg', 
      labelKey: 'task',
    ),
    NavigationItem(
      index: 2,
      icon: 'assets/icons/menu_doc.svg',
      labelKey: 'documents',
    ),
    NavigationItem(
      index: 3,
      icon: 'assets/icons/menu_profile.svg',
      labelKey: 'profile',
    ),
    NavigationItem(
      index: 4,
      icon: 'assets/icons/menu_setting.svg',
      labelKey: 'more',
    ),
  ];

  /// 切换页面
  void setSelectedIndex(int index) {
    if (index >= 0 && index < navigationItems.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// 重置到首页
  void resetToHome() {
    setSelectedIndex(0);
  }

  /// 检查是否是指定页面
  bool isCurrentPage(int index) {
    return _selectedIndex == index;
  }

  /// 获取当前页面标题键
  String get currentPageLabelKey {
    return navigationItems[_selectedIndex].labelKey;
  }
}

/// 导航项数据模型
class NavigationItem {
  final int index;
  final String icon;
  final String labelKey;

  const NavigationItem({
    required this.index,
    required this.icon,
    required this.labelKey,
  });
}