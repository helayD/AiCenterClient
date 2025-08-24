/// Flutter科技商务风格UI使用规范
/// 完全符合Tailwind CSS官方标准的企业级UI设计系统
/// 
/// 本规范提供完整的设计系统使用指南，包括：
/// - 科技商务风格设计原理
/// - 明暗双主题系统
/// - 组件库使用规范
/// - 实现最佳实践

library ui_specification;

import 'package:flutter/material.dart';
import '../theme/tech_theme_system.dart';
import '../components/tech_components.dart';

/// # 科技商务风格UI设计规范
/// 
/// ## 设计理念
/// 
/// ### 1. 核心原则
/// - **简约至上**: 去除装饰性元素，专注内容表达
/// - **功能导向**: 每个设计元素都有明确的功能目的
/// - **数据为王**: 突出数据展示和业务指标
/// - **专业可信**: 体现企业级应用的专业性和可靠性
/// 
/// ### 2. 视觉特征
/// - 扁平化设计，无过度装饰
/// - 清晰的层次结构和信息架构
/// - 高对比度确保可读性
/// - 一致的间距和排版系统
class UISpecificationGuide {
  
  /// ## 主题系统使用指南
  /// 
  /// ### 配置主题
  /// ```dart
  /// MaterialApp(
  ///   theme: TechThemeSystem.lightTheme,
  ///   darkTheme: TechThemeSystem.darkTheme,
  ///   themeMode: ThemeMode.system, // 跟随系统 / ThemeMode.light / ThemeMode.dark
  /// )
  /// ```
  /// 
  /// ### 获取主题色彩
  /// ```dart
  /// // 推荐方式：使用语义色彩
  /// Widget build(BuildContext context) {
  ///   final colors = Theme.of(context).colorScheme;
  ///   
  ///   return Container(
  ///     color: colors.surface,
  ///     child: Text('示例', style: TextStyle(color: colors.onSurface)),
  ///   );
  /// }
  /// 
  /// // 直接使用Tailwind标准色彩
  /// Widget build(BuildContext context) {
  ///   return Container(
  ///     color: TailwindColors.blue500,  // 标准蓝色-500
  ///     child: Text('示例', style: TextStyle(color: TailwindColors.white)),
  ///   );
  /// }
  /// ```
  static void themeUsageExample() {}
  
  /// ## 颜色系统规范
  /// 
  /// ### 主要色彩分类
  /// - **主色调**: 品牌识别色，用于关键交互元素
  /// - **中性色**: 文本、边框、背景的基础色彩
  /// - **语义色**: 成功、警告、错误、信息状态色彩
  /// - **功能色**: 特定业务功能的识别色彩
  /// 
  /// ### 使用规则
  /// ```dart
  /// // ✅ 最佳实践：使用语义色彩
  /// Container(color: Theme.of(context).colorScheme.primary)
  /// 
  /// // ✅ 推荐：使用Tailwind语义色彩
  /// Container(color: TailwindSemanticColors.primary)
  /// 
  /// // ✅ 可以：使用标准Tailwind色彩
  /// Container(color: TailwindColors.blue600)
  /// 
  /// // ❌ 避免：硬编码颜色值
  /// Container(color: Color(0xFF2563EB))
  /// 
  /// // ❌ 废弃：旧的配色系统
  /// Container(color: VividBusinessColors.businessBlue)
  /// ```
  static void colorSystemGuide() {}
  
  /// ## 间距系统规范
  /// 
  /// ### 4px基准间距系统
  /// - **4px**: 最小间距，用于紧密相关元素
  /// - **8px**: 小间距，组件内部元素间距
  /// - **16px**: 标准间距，最常用的元素间距
  /// - **24px**: 大间距，区块之间的间距
  /// - **32px**: 超大间距，页面区域间距
  /// - **48px**: 最大间距，页面级别间距
  /// 
  /// ### 使用示例
  /// ```dart
  /// // 使用设计系统间距
  /// Padding(
  ///   padding: EdgeInsets.all(TechThemeSystem.spacing.lg), // 24px
  ///   child: Column(
  ///     children: [
  ///       widget1,
  ///       SizedBox(height: TechThemeSystem.spacing.md), // 16px
  ///       widget2,
  ///     ],
  ///   ),
  /// )
  /// ```
  static void spacingSystemGuide() {}
  
  /// ## 组件使用规范
  /// 
  /// ### TechCard - 内容容器组件
  /// 
  /// #### 使用场景
  /// - 数据展示卡片
  /// - 功能模块容器
  /// - 内容分组容器
  /// 
  /// #### 使用示例
  /// ```dart
  /// // 基础使用
  /// TechCard(
  ///   child: Text('内容'),
  /// )
  /// 
  /// // 自定义样式
  /// TechCard(
  ///   padding: EdgeInsets.all(24),
  ///   showBorder: true,
  ///   elevation: 2,
  ///   child: Column(children: [...]),
  /// )
  /// ```
  /// 
  /// #### 设计规则
  /// - 默认无边框，体现扁平化设计
  /// - 可选择性添加边框和阴影
  /// - 支持响应式内边距调整
  static void techCardGuide() {}
  
  /// ### MetricDisplay - 数据指标展示组件
  /// 
  /// #### 使用场景
  /// - KPI指标展示
  /// - 数据统计卡片
  /// - 业务指标监控
  /// 
  /// #### 使用示例
  /// ```dart
  /// MetricDisplay(
  ///   title: '总营收',
  ///   value: '¥2,847,392',
  ///   change: '+12.5%',
  ///   trend: TrendType.up,
  ///   icon: Icons.trending_up,
  /// )
  /// ```
  /// 
  /// #### 设计规则
  /// - 数值突出显示，使用大字体
  /// - 变化趋势用颜色和图标表示
  /// - 简洁布局，突出数据本身
  static void metricDisplayGuide() {}
  
  /// ### TechButton - 按钮组件
  /// 
  /// #### 按钮层次
  /// - **Primary**: 主要操作按钮，页面中最重要的操作
  /// - **Secondary**: 次要操作按钮，辅助功能
  /// - **Outline**: 轮廓按钮，较低优先级操作
  /// - **Ghost**: 幽灵按钮，最低视觉权重
  /// 
  /// #### 使用示例
  /// ```dart
  /// // 按钮层次使用
  /// Row(children: [
  ///   TechButton.primary(
  ///     onPressed: () => save(),
  ///     child: Text('保存'),
  ///   ),
  ///   SizedBox(width: 16),
  ///   TechButton.outline(
  ///     onPressed: () => cancel(),
  ///     child: Text('取消'),
  ///   ),
  /// ])
  /// ```
  /// 
  /// #### 设计规则
  /// - 一个界面中只有一个主要按钮
  /// - 按钮文字简洁明确，动词导向
  /// - 禁用状态要有明确的视觉反馈
  static void techButtonGuide() {}
  
  /// ### StatusIndicator - 状态指示器
  /// 
  /// #### 状态类型
  /// - **Success**: 成功状态，使用绿色
  /// - **Warning**: 警告状态，使用橙色
  /// - **Error**: 错误状态，使用红色
  /// - **Info**: 信息状态，使用蓝色
  /// 
  /// #### 使用示例
  /// ```dart
  /// StatusIndicator(
  ///   status: StatusType.success,
  ///   text: '在线',
  ///   showDot: true,
  /// )
  /// ```
  static void statusIndicatorGuide() {}
  
  /// ## 布局规范
  /// 
  /// ### 响应式断点
  /// - **移动端**: < 768px
  /// - **平板端**: 768px - 1024px
  /// - **桌面端**: > 1024px
  /// 
  /// ### 网格系统
  /// ```dart
  /// // 响应式网格布局
  /// TechResponsiveGrid(
  ///   mobile: 1,    // 移动端1列
  ///   tablet: 2,    // 平板端2列
  ///   desktop: 3,   // 桌面端3列
  ///   children: [...],
  /// )
  /// ```
  /// 
  /// ### 内容区域规划
  /// - **页面边距**: 16px (移动端) / 24px (桌面端)
  /// - **内容最大宽度**: 1200px
  /// - **区块间距**: 32px (主要区块) / 24px (次要区块)
  static void layoutGuide() {}
  
  /// ## 字体排版规范
  /// 
  /// ### 字体层次
  /// ```dart
  /// // 标题层次
  /// Text('页面标题', style: Theme.of(context).textTheme.headlineLarge)      // 28px
  /// Text('区块标题', style: Theme.of(context).textTheme.headlineMedium)     // 24px
  /// Text('组件标题', style: Theme.of(context).textTheme.headlineSmall)      // 20px
  /// 
  /// // 正文层次
  /// Text('正文内容', style: Theme.of(context).textTheme.bodyLarge)         // 16px
  /// Text('辅助信息', style: Theme.of(context).textTheme.bodyMedium)        // 14px
  /// Text('说明文字', style: Theme.of(context).textTheme.bodySmall)         // 12px
  /// ```
  /// 
  /// ### 使用规则
  /// - 标题使用半粗体 (fontWeight: 600)
  /// - 正文使用常规体 (fontWeight: 400)
  /// - 重要信息使用中粗体 (fontWeight: 500)
  /// - 行高保持1.5倍，确保可读性
  static void typographyGuide() {}
  
  /// ## 动画与交互规范
  /// 
  /// ### 动画时长
  /// ```dart
  /// // 设计系统预定义时长
  /// Duration.short    // 150ms - 微交互
  /// Duration.medium   // 250ms - 标准交互
  /// Duration.long     // 350ms - 复杂交互
  /// ```
  /// 
  /// ### 动画曲线
  /// - **ease**: 标准缓动，适用于大部分交互
  /// - **easeOut**: 快进慢出，适用于出现动画
  /// - **easeIn**: 慢进快出，适用于消失动画
  /// 
  /// ### 交互反馈
  /// ```dart
  /// // 悬停效果
  /// AnimatedContainer(
  ///   duration: Duration(milliseconds: 150),
  ///   decoration: BoxDecoration(
  ///     color: isHovered ? colors.surfaceVariant : colors.surface,
  ///   ),
  /// )
  /// ```
  static void animationGuide() {}
  
  /// ## 可访问性规范
  /// 
  /// ### 颜色对比度
  /// - **正文文字**: 4.5:1 最小对比度
  /// - **大字体**: 3:1 最小对比度
  /// - **图标按钮**: 3:1 最小对比度
  /// 
  /// ### 语义化设计
  /// ```dart
  /// // 使用Semantics包装重要元素
  /// Semantics(
  ///   label: '保存文档',
  ///   hint: '点击保存当前文档',
  ///   child: TechButton.primary(...),
  /// )
  /// ```
  /// 
  /// ### 键盘导航
  /// - 所有交互元素支持键盘访问
  /// - 清晰的焦点指示器
  /// - 逻辑的Tab顺序
  static void accessibilityGuide() {}
  
  /// ## 最佳实践
  /// 
  /// ### 组件组合原则
  /// 1. **单一职责**: 每个组件只负责一个功能
  /// 2. **可组合性**: 组件可以灵活组合成复杂界面
  /// 3. **一致性**: 同类组件行为和样式保持一致
  /// 4. **可扩展性**: 组件设计要便于扩展和定制
  /// 
  /// ### 性能优化
  /// ```dart
  /// // 使用const构造函数
  /// const TechCard(child: Text('静态内容'))
  /// 
  /// // 避免不必要的rebuild
  /// Consumer<DataModel>(
  ///   builder: (context, data, child) => TechCard(
  ///     child: child, // 静态child，避免重建
  ///   ),
  ///   child: StaticWidget(),
  /// )
  /// ```
  /// 
  /// ### 代码组织
  /// ```dart
  /// // 推荐的导入顺序
  /// import 'package:flutter/material.dart';         // Flutter核心
  /// import 'package:provider/provider.dart';        // 第三方包
  /// import '../theme/tech_theme_system.dart';       // 设计系统
  /// import '../components/tech_components.dart';    // 组件库
  /// import 'local_widgets.dart';                    // 本地组件
  /// ```
  static void bestPracticesGuide() {}
  
  /// ## 实施指南
  /// 
  /// ### 迁移步骤
  /// 1. **引入主题系统**: 配置TechThemeSystem
  /// 2. **替换基础组件**: Card → TechCard, Button → TechButton
  /// 3. **统一间距系统**: 使用TechSpacing替代硬编码数值
  /// 4. **应用色彩规范**: 使用主题色彩替代自定义颜色
  /// 5. **优化排版**: 使用主题文字样式
  /// 
  /// ### 质量检查清单
  /// - [ ] 所有硬编码颜色已替换为主题色彩
  /// - [ ] 间距使用设计系统规范值
  /// - [ ] 字体样式符合排版层次
  /// - [ ] 组件响应式适配正常
  /// - [ ] 深色模式显示正常
  /// - [ ] 可访问性对比度达标
  /// - [ ] 动画流畅且时长合适
  /// 
  /// ### 维护更新
  /// - 定期review设计系统使用情况
  /// - 收集用户反馈，持续改进
  /// - 保持设计系统文档更新
  /// - 新增组件要符合现有设计原则
  static void implementationGuide() {}
}

/// ## 使用示例: 完整页面实现
/// 
/// 以下是一个使用设计系统的完整页面示例：
class TechDashboardExample extends StatelessWidget {
  const TechDashboardExample({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        title: Text('科技商务仪表板'),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TechThemeSystem.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 页面标题
            Text(
              '业务概览',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(height: TechThemeSystem.spacing.lg),
            
            // KPI指标网格
            TechResponsiveGrid(
              mobile: 1,
              tablet: 2,
              desktop: 4,
              spacing: TechThemeSystem.spacing.md,
              children: [
                MetricDisplay(
                  title: '总营收',
                  value: '¥2,847,392',
                  change: '+12.5%',
                  trend: TrendType.up,
                  icon: Icons.trending_up,
                ),
                MetricDisplay(
                  title: '活跃用户',
                  value: '34,567',
                  change: '+8.2%',
                  trend: TrendType.up,
                  icon: Icons.people,
                ),
                MetricDisplay(
                  title: '订单数量',
                  value: '1,234',
                  change: '-2.1%',
                  trend: TrendType.down,
                  icon: Icons.shopping_cart,
                ),
                MetricDisplay(
                  title: '转化率',
                  value: '3.24%',
                  change: '+0.5%',
                  trend: TrendType.up,
                  icon: Icons.percent,
                ),
              ],
            ),
            
            SizedBox(height: TechThemeSystem.spacing.xl),
            
            // 内容区域
            TechCard(
              padding: EdgeInsets.all(TechThemeSystem.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '近期活动',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      StatusIndicator(
                        status: StatusType.success,
                        text: '系统正常',
                        showDot: true,
                      ),
                    ],
                  ),
                  SizedBox(height: TechThemeSystem.spacing.md),
                  
                  // 列表内容
                  ...List.generate(3, (index) => Padding(
                    padding: EdgeInsets.only(bottom: TechThemeSystem.spacing.sm),
                    child: TechListItem(
                      leading: CircleAvatar(
                        backgroundColor: colorScheme.primary,
                        child: Icon(Icons.event, color: colorScheme.onPrimary),
                      ),
                      title: '活动 ${index + 1}',
                      subtitle: '活动详细描述信息',
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {/* 处理点击 */},
                    ),
                  )),
                  
                  SizedBox(height: TechThemeSystem.spacing.md),
                  
                  // 操作按钮
                  Row(
                    children: [
                      TechButton.primary(
                        onPressed: () {/* 主要操作 */},
                        child: Text('创建活动'),
                      ),
                      SizedBox(width: TechThemeSystem.spacing.sm),
                      TechButton.outline(
                        onPressed: () {/* 次要操作 */},
                        child: Text('查看全部'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ## 响应式网格组件实现示例
class TechResponsiveGrid extends StatelessWidget {
  final int mobile;
  final int tablet;
  final int desktop;
  final double spacing;
  final List<Widget> children;

  const TechResponsiveGrid({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.spacing = 16.0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount;
        
        if (constraints.maxWidth < 768) {
          crossAxisCount = mobile;
        } else if (constraints.maxWidth < 1024) {
          crossAxisCount = tablet;
        } else {
          crossAxisCount = desktop;
        }
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}