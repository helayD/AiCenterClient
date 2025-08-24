import 'package:flutter/material.dart';

/// Tailwind CSS风格的Flutter实用工具系统
/// 完全扁平化设计 - 无边框、无阴影、无圆角、无背景装饰
/// 仅通过间距、排版、颜色对比创建视觉层次

class TW {
  // ==================== SPACING SYSTEM ====================
  // Tailwind间距系统 - rem * 16px
  static const double sp1 = 4.0;    // 0.25rem
  static const double sp2 = 8.0;    // 0.5rem  
  static const double sp3 = 12.0;   // 0.75rem
  static const double sp4 = 16.0;   // 1rem
  static const double sp5 = 20.0;   // 1.25rem
  static const double sp6 = 24.0;   // 1.5rem
  static const double sp8 = 32.0;   // 2rem
  static const double sp10 = 40.0;  // 2.5rem
  static const double sp12 = 48.0;  // 3rem
  static const double sp16 = 64.0;  // 4rem
  static const double sp20 = 80.0;  // 5rem
  static const double sp24 = 96.0;  // 6rem
  
  // ==================== TYPOGRAPHY SYSTEM ====================
  // Tailwind文字大小系统
  static const double textXs = 12.0;   // text-xs
  static const double textSm = 14.0;   // text-sm
  static const double textBase = 16.0; // text-base
  static const double textLg = 18.0;   // text-lg
  static const double textXl = 20.0;   // text-xl
  static const double text2Xl = 24.0;  // text-2xl
  static const double text3Xl = 30.0;  // text-3xl
  static const double text4Xl = 36.0;  // text-4xl
  static const double text5Xl = 48.0;  // text-5xl
  
  // 文字权重
  static const FontWeight thin = FontWeight.w100;       // font-thin
  static const FontWeight light = FontWeight.w300;     // font-light
  static const FontWeight normal = FontWeight.w400;    // font-normal
  static const FontWeight medium = FontWeight.w500;    // font-medium
  static const FontWeight semibold = FontWeight.w600;  // font-semibold
  static const FontWeight bold = FontWeight.w700;      // font-bold
  static const FontWeight extrabold = FontWeight.w800; // font-extrabold
  static const FontWeight black = FontWeight.w900;     // font-black

  // ==================== COLOR SYSTEM ====================
  // Tailwind语义颜色 - 仅用于文字对比度，不用于装饰
  static Color text900(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFFF9FAFB) : const Color(0xFF111827);
      
  static Color text800(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFFF3F4F6) : const Color(0xFF1F2937);
      
  static Color text700(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFFE5E7EB) : const Color(0xFF374151);
      
  static Color text600(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFFD1D5DB) : const Color(0xFF4B5563);
      
  static Color text500(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
      
  static Color text400(BuildContext context) => 
    Theme.of(context).brightness == Brightness.dark 
      ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF);

  // 功能色彩 - 最小化使用
  static const Color blue600 = Color(0xFF2563EB);   // 仅用于链接/交互
  static const Color green600 = Color(0xFF059669); // 仅用于成功状态
  static const Color red600 = Color(0xFFDC2626);   // 仅用于错误状态
  static const Color yellow600 = Color(0xFFD97706); // 仅用于警告状态

  // ==================== LAYOUT UTILITIES ====================
  
  /// 完全扁平的内容容器 - 无任何视觉装饰
  /// 仅提供padding，不提供背景、边框、阴影
  static Widget contentBox({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: null, // 明确不使用任何装饰
      child: child,
    );
  }
  
  /// 扁平网格容器 - 使用gap而不是padding分隔
  static Widget gridFlat({
    required List<Widget> children,
    int crossAxisCount = 1,
    double gap = TW.sp4,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      padding: padding,
      child: Wrap(
        spacing: gap,
        runSpacing: gap,
        children: children,
      ),
    );
  }
  
  /// 扁平分栏布局 - 使用gap分隔
  static Widget rowFlat({
    required List<Widget> children,
    double gap = TW.sp4,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(width: gap));
      }
    }
    
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacedChildren,
    );
  }
  
  /// 扁平列布局 - 使用gap分隔
  static Widget colFlat({
    required List<Widget> children,
    double gap = TW.sp4,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: gap));
      }
    }
    
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacedChildren,
    );
  }

  // ==================== TEXT UTILITIES ====================
  
  /// Tailwind文字样式快速构建器
  static TextStyle textStyle(
    BuildContext context, {
    double? size,
    FontWeight? weight,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: size ?? TW.textBase,
      fontWeight: weight ?? TW.normal,
      color: color ?? TW.text700(context),
      height: height,
      letterSpacing: letterSpacing,
    );
  }
  
  // 预设文字样式 - 对应Tailwind类
  static TextStyle heading1(BuildContext context) => textStyle(
    context, 
    size: TW.text5Xl, 
    weight: TW.bold,
    color: TW.text900(context),
  );
  
  static TextStyle heading2(BuildContext context) => textStyle(
    context, 
    size: TW.text4Xl, 
    weight: TW.bold,
    color: TW.text900(context),
  );
  
  static TextStyle heading3(BuildContext context) => textStyle(
    context, 
    size: TW.text3Xl, 
    weight: TW.semibold,
    color: TW.text900(context),
  );
  
  static TextStyle heading4(BuildContext context) => textStyle(
    context, 
    size: TW.text2Xl, 
    weight: TW.semibold,
    color: TW.text800(context),
  );
  
  static TextStyle body(BuildContext context) => textStyle(
    context, 
    size: TW.textBase,
    color: TW.text700(context),
  );
  
  static TextStyle bodySmall(BuildContext context) => textStyle(
    context, 
    size: TW.textSm,
    color: TW.text600(context),
  );
  
  static TextStyle caption(BuildContext context) => textStyle(
    context, 
    size: TW.textXs,
    color: TW.text500(context),
  );

  // ==================== RESPONSIVE UTILITIES ====================
  
  /// 响应式断点 - 对应Tailwind断点
  static bool isSm(BuildContext context) => MediaQuery.of(context).size.width >= 640;
  static bool isMd(BuildContext context) => MediaQuery.of(context).size.width >= 768;
  static bool isLg(BuildContext context) => MediaQuery.of(context).size.width >= 1024;
  static bool isXl(BuildContext context) => MediaQuery.of(context).size.width >= 1280;
  static bool is2Xl(BuildContext context) => MediaQuery.of(context).size.width >= 1536;
  
  /// 响应式网格列数计算
  static int responsiveCols(BuildContext context, {
    int mobile = 1,
    int tablet = 2, 
    int desktop = 3,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return desktop;  // lg+
    if (width >= 768) return tablet;    // md+
    return mobile;                      // sm
  }
  
  /// 响应式间距计算
  static double responsiveGap(BuildContext context, {
    double mobile = TW.sp4,
    double tablet = TW.sp6,
    double desktop = TW.sp8,
  }) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return desktop;
    if (width >= 768) return tablet;
    return mobile;
  }
}

/// Tailwind风格的扁平内容组件 - 替代所有Card类型组件
/// 完全无视觉装饰，仅提供内容结构和间距
class FlatContent extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  const FlatContent({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TW.contentBox(
      padding: padding ?? EdgeInsets.all(TW.sp6),
      margin: margin,
      child: child,
    );
  }
}

/// 扁平数据展示组件 - 替代所有数据卡片
class FlatDataDisplay extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final VoidCallback? onTap;
  
  const FlatDataDisplay({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TW.contentBox(
        padding: EdgeInsets.all(TW.sp6),
        child: TW.colFlat(
          gap: TW.sp3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TW.bodySmall(context)),
            Text(value, style: TW.heading3(context)),
            if (subtitle != null)
              Text(subtitle!, style: TW.caption(context)),
          ],
        ),
      ),
    );
  }
}

/// 扁平列表项 - 替代所有ListTile和卡片列表项
class FlatListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  const FlatListItem({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TW.contentBox(
        padding: EdgeInsets.symmetric(
          vertical: TW.sp4,
          horizontal: TW.sp6,
        ),
        child: TW.rowFlat(
          gap: TW.sp4,
          children: [
            if (leading != null) leading!,
            Expanded(
              child: TW.colFlat(
                gap: TW.sp1,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TW.body(context)),
                  if (subtitle != null)
                    Text(subtitle!, style: TW.bodySmall(context)),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}