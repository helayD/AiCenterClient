import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/navigation_controller.dart';
import '../../components/custom_app_bar.dart';
import '../../components/bottom_navigation_bar.dart';
import '../dashboard/dashboard_screen.dart';
import '../placeholder/placeholder_screen.dart';
import '../more/more_screen.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationController>(
      builder: (context, navigationController, child) {
        return Scaffold(
          // 顶部AppBar
          appBar: CustomAppBar(),
          
          // 主体内容区域
          body: SafeArea(
            child: _getPage(navigationController.selectedIndex),
          ),
          
          // 底部导航栏
          bottomNavigationBar: CustomBottomNavigationBar(),
        );
      },
    );
  }

  /// 根据索引获取对应页面
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return DashboardScreen();
      case 1:
        return TaskScreen();
      case 2:
        return DocumentsScreen();
      case 3:
        return ProfileScreen();
      case 4:
        return MoreScreen();
      default:
        return DashboardScreen();
    }
  }
}
