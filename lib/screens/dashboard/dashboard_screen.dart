import 'package:admin/responsive.dart';
import 'package:admin/screens/dashboard/components/my_files.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'components/header.dart';

import 'components/recent_files.dart';
import 'components/storage_details.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header(),
            SizedBox(height: defaultPadding),
            _buildResponsiveLayout(context),
          ],
        ),
      ),
    );
  }

  /// 构建响应式流动布局
  Widget _buildResponsiveLayout(BuildContext context) {
    return Responsive(
      // 移动端：垂直堆叠布局
      mobile: _buildMobileLayout(context),
      // 平板端：平衡布局
      tablet: _buildTabletLayout(context),
      // 桌面端：左右分栏布局
      desktop: _buildDesktopLayout(context),
    );
  }

  /// 移动端布局 - 垂直堆叠，优化触摸交互
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        MyFiles(),
        SizedBox(height: defaultPadding),
        RecentFiles(),
        SizedBox(height: defaultPadding),
        StorageDetails(),
      ],
    );
  }

  /// 平板端布局 - 平衡的两栏布局
  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3, // 主内容区域占更多空间
          child: Column(
            children: [
              MyFiles(),
              SizedBox(height: defaultPadding),
              RecentFiles(),
            ],
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          flex: 2, // 侧边栏适中空间
          child: StorageDetails(),
        ),
      ],
    );
  }

  /// 桌面端布局 - 经典左右分栏，主内容区域占主导
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5, // 主内容区域
          child: Column(
            children: [
              MyFiles(),
              SizedBox(height: defaultPadding),
              RecentFiles(),
            ],
          ),
        ),
        SizedBox(width: defaultPadding * 1.5), // 桌面端更大的间距
        Expanded(
          flex: 2, // 侧边栏
          child: StorageDetails(),
        ),
      ],
    );
  }
}
