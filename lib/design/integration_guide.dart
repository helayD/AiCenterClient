/// 设计系统集成指南
/// 展示如何将TailwindThemeSystem和TechComponents应用到现有项目中
/// 
/// 本指南提供：
/// - 现有组件的升级示例
/// - 主题系统集成步骤
/// - 迁移最佳实践

library integration_guide;

import 'package:flutter/material.dart';
import '../theme/tailwind_theme_system.dart';
import '../components/tailwind_components.dart';

/// # 集成步骤指南
/// 
/// ## 第1步: 在main.dart中配置主题系统
class TechAppIntegration {
  /// 在MaterialApp中配置主题
  /// 
  /// ```dart
  /// import 'theme/tech_theme_system.dart';
  /// 
  /// MaterialApp(
  ///   title: 'AiCenterClient',
  ///   theme: TailwindThemeSystem.lightTheme,
  ///   darkTheme: TailwindThemeSystem.darkTheme,
  ///   themeMode: ThemeMode.system,
  ///   home: MainScreen(),
  /// )
  /// ```
  static void configureThemes() {}
}

/// ## 第2步: 升级现有仪表板组件
/// 
/// ### 原文件: storage_details.dart 升级示例
class StorageDetailsUpgrade extends StatelessWidget {
  const StorageDetailsUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 使用主题文字样式替代自定义样式
        Text(
          "存储分析",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TW.space("lg),
        
        // 保持原有图表组件
        const Chart(),
        
        SizedBox(height: TW.space("lg),
        
        // 使用TailwindCard替代原有的扁平容器
        TailwindCard(
          padding: EdgeInsets.all(TW.space("lg),
          child: Column(
            children: [
              _buildStorageMetric(context, "文档文件", "1.3GB", 1328),
              _buildStorageMetric(context, "媒体文件", "15.3GB", 1328),
              _buildStorageMetric(context, "其他文件", "1.3GB", 1328),
              _buildStorageMetric(context, "未知文件", "1.3GB", 140),
            ],
          ),
        ),
      ],
    );
  }

  /// 升级后的存储项构建方法
  Widget _buildStorageMetric(BuildContext context, String title, String amount, int numOfFiles) {
    return Padding(
      padding: EdgeInsets.only(bottom: TW.space("md),
      child: TailwindListItem(
        title: title,
        subtitle: '$numOfFiles 个文件',
        trailing: Text(
          amount,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

/// ### 原文件: my_files.dart 升级示例
class MyFilesUpgrade extends StatelessWidget {
  const MyFilesUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 头部区域使用新的设计系统
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "我的文件",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TailwindButton.primary(
              onPressed: () {/* 添加文件逻辑 */},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: TW.space("xs),
                  Text("添加新文件"),
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: TW.space("lg),
        
        // 使用响应式网格替代原有Wrap布局
        _buildResponsiveFileGrid(context),
      ],
    );
  }

  /// 响应式文件网格
  Widget _buildResponsiveFileGrid(BuildContext context) {
    // 这里应该使用实际的文件数据
    final files = [
      {'title': 'Documents', 'storage': '1.3GB', 'count': 123, 'icon': Icons.description},
      {'title': 'Media', 'storage': '15.3GB', 'count': 456, 'icon': Icons.perm_media},
      {'title': 'Images', 'storage': '3.2GB', 'count': 789, 'icon': Icons.image},
      {'title': 'Others', 'storage': '2.1GB', 'count': 234, 'icon': Icons.folder},
    ];
    
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 1;
        if (constraints.maxWidth > 1024) {
          crossAxisCount = 4;
        } else if (constraints.maxWidth > 768) {
          crossAxisCount = 3;
        } else if (constraints.maxWidth > 480) {
          crossAxisCount = 2;
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: TW.space("md,
            crossAxisSpacing: TW.space("md,
            childAspectRatio: 1.2,
          ),
          itemCount: files.length,
          itemBuilder: (context, index) {
            final file = files[index];
            return FileMetricCard(
              title: file['title'] as String,
              storage: file['storage'] as String,
              fileCount: file['count'] as int,
              icon: file['icon'] as IconData,
            );
          },
        );
      },
    );
  }
}

/// 文件指标卡片组件
class FileMetricCard extends StatelessWidget {
  final String title;
  final String storage;
  final int fileCount;
  final IconData icon;

  const FileMetricCard({
    super.key,
    required this.title,
    required this.storage,
    required this.fileCount,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TailwindCard(
      padding: EdgeInsets.all(TW.space("lg),
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 图标和标题
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(TW.space("sm),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(TW.radius("md),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: TW.space("md),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TW.space("md),
          
          // 统计数据
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$fileCount 个文件',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              SizedBox(height: TW.space("xs),
              Text(
                storage,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ## 第3步: 升级仪表板主页面
class DashboardScreenUpgrade extends StatelessWidget {
  const DashboardScreenUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(TW.space("lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 页面标题和用户信息
              _buildDashboardHeader(context),
              
              SizedBox(height: TW.space("xl),
              
              // KPI指标概览
              _buildKPIOverview(context),
              
              SizedBox(height: TW.space("xl),
              
              // 主要内容区域
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1024) {
                    // 桌面端: 两列布局
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: MyFilesUpgrade()),
                        SizedBox(width: TW.space("xl),
                        Expanded(flex: 1, child: StorageDetailsUpgrade()),
                      ],
                    );
                  } else {
                    // 移动端/平板端: 单列布局
                    return Column(
                      children: [
                        MyFilesUpgrade(),
                        SizedBox(height: TW.space("xl),
                        StorageDetailsUpgrade(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 仪表板头部
  Widget _buildDashboardHeader(BuildContext context) {
    return TailwindCard(
      padding: EdgeInsets.all(TW.space("lg),
      child: Row(
        children: [
          // 用户头像
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(
              Icons.person,
              size: 32,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          
          SizedBox(width: TW.space("lg),
          
          // 用户信息
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "欢迎回来！",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: TW.space("xs),
                Text(
                  "管理员",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          
          // 状态指示器
          StatusIndicator(
            status: StatusType.success,
            text: '在线',
            showDot: true,
          ),
        ],
      ),
    );
  }

  /// KPI概览区域
  Widget _buildKPIOverview(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "业务概览",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TW.space("lg),
        
        // KPI网格
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = 1;
            if (constraints.maxWidth > 1024) {
              crossAxisCount = 4;
            } else if (constraints.maxWidth > 768) {
              crossAxisCount = 2;
            }
            
            return GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: TW.space("md,
                crossAxisSpacing: TW.space("md,
                childAspectRatio: 1.8,
              ),
              children: [
                MetricDisplay(
                  title: '总用户数',
                  value: '12,847',
                  change: '+12.5%',
                  trend: TrendType.up,
                  icon: Icons.people,
                ),
                MetricDisplay(
                  title: '活跃用户',
                  value: '8,392',
                  change: '+8.2%',
                  trend: TrendType.up,
                  icon: Icons.trending_up,
                ),
                MetricDisplay(
                  title: '存储使用',
                  value: '67.3%',
                  change: '+2.1%',
                  trend: TrendType.up,
                  icon: Icons.storage,
                ),
                MetricDisplay(
                  title: '系统负载',
                  value: '23.4%',
                  change: '-5.3%',
                  trend: TrendType.down,
                  icon: Icons.memory,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// ## 第4步: 更新侧边栏导航
class SideMenuUpgrade extends StatelessWidget {
  const SideMenuUpgrade({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Logo区域
          Container(
            padding: EdgeInsets.all(TW.space("lg),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(TW.space("sm),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(TW.radius("md),
                  ),
                  child: Icon(
                    Icons.dashboard,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                SizedBox(width: TW.space("md),
                Text(
                  'AI Center',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Divider(color: Theme.of(context).colorScheme.outline.withOpacity(0.2)),
          
          // 导航项
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: TW.space("sm),
              children: [
                _buildNavItem(context, Icons.dashboard, '仪表板', true),
                _buildNavItem(context, Icons.folder, '文件管理', false),
                _buildNavItem(context, Icons.analytics, '数据分析', false),
                _buildNavItem(context, Icons.settings, '系统设置', false),
                _buildNavItem(context, Icons.help, '帮助中心', false),
              ],
            ),
          ),
          
          // 底部用户区域
          Container(
            padding: EdgeInsets.all(TW.space("md),
            child: TailwindButton.outline(
              onPressed: () {/* 退出登录 */},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.logout, size: 16),
                  SizedBox(width: TW.space("xs),
                  Text('退出登录'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, IconData icon, String title, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: TW.space("sm,
        vertical: TW.space("xs,
      ),
      child: TailwindListItem(
        leading: Icon(
          icon,
          color: isSelected 
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
        ),
        title: title,
        selected: isSelected,
        onTap: () {/* 导航逻辑 */},
      ),
    );
  }
}

/// ## 第5步: 实际应用指南
/// 
/// ### 快速迁移checklist:
/// ```
/// □ 1. 在main.dart配置TailwindThemeSystem主题
/// □ 2. 替换所有Card组件为TailwindCard
/// □ 3. 使用Theme.of(context).textTheme替代自定义文字样式
/// □ 4. 用TailwindButton替代所有Button组件
/// □ 5. 使用TailwindThemeSystem.spacing替代硬编码间距
/// □ 6. 应用MetricDisplay组件展示KPI数据
/// □ 7. 用StatusIndicator显示状态信息
/// □ 8. 测试深色模式显示效果
/// □ 9. 验证响应式布局适配
/// □ 10. 检查可访问性对比度
/// ```

/// ### 常见问题和解决方案
class MigrationTips {
  /// Q: 如何处理现有的自定义颜色？
  /// A: 将自定义颜色映射到主题色彩系统
  static void handleCustomColors() {
    // 旧代码
    // Container(color: Color(0xFF2563EB))
    
    // 新代码
    // Container(color: Theme.of(context).colorScheme.primary)
  }

  /// Q: 原有的padding和margin如何迁移？
  /// A: 使用TailwindThemeSystem.spacing标准化间距
  static void migrateSpacing() {
    // 旧代码
    // Padding(padding: EdgeInsets.all(16))
    
    // 新代码  
    // Padding(padding: EdgeInsets.all(TW.space("md))
  }

  /// Q: 如何保持现有功能的同时升级UI？
  /// A: 渐进式迁移，先替换样式，后优化功能
  static void progressiveMigration() {
    // 1. 先保持功能不变，只替换视觉组件
    // 2. 然后优化交互和用户体验  
    // 3. 最后添加新的设计系统特性
  }
}