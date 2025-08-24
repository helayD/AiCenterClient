import 'package:flutter/material.dart';
import '../theme/tailwind_design_tokens.dart';

/// Tailwind CSS 符合规范的组件库
/// 完全基于官方设计令牌和 utility-first 设计理念
/// 
/// 特性:
/// - 使用官方 Tailwind 设计令牌
/// - 遵循 utility-first 设计原则
/// - 支持明暗主题自动适配
/// - OKLCH 色彩空间确保视觉一致性
/// - 4px 基准间距系统

// ==================== 容器组件 ====================

/// TailwindCard - 符合 Tailwind CSS 规范的卡片组件
/// 等同于传统的 Card 组件，但使用 Tailwind 设计令牌
class TailwindCard extends StatelessWidget {
  final Widget child;
  final String padding;
  final String margin;
  final String shadow;
  final String rounded;
  final Color? backgroundColor;
  final bool showBorder;
  final VoidCallback? onTap;

  const TailwindCard({
    super.key,
    required this.child,
    this.padding = '6',         // p-6 = 24px
    this.margin = '0',          // m-0 = 0px
    this.shadow = 'sm',         // shadow-sm
    this.rounded = 'lg',        // rounded-lg
    this.backgroundColor,
    this.showBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: EdgeInsets.all(TailwindDesignTokens.space(margin)),
      child: Material(
        color: backgroundColor ?? (isDark 
            ? TailwindSemanticTokens.darkSurface 
            : TailwindSemanticTokens.surface),
        borderRadius: BorderRadius.circular(TailwindDesignTokens.radius(rounded)),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TailwindDesignTokens.radius(rounded)),
            border: showBorder ? Border.all(
              color: isDark 
                  ? TailwindSemanticTokens.darkBorder.withOpacity(0.6)
                  : TailwindSemanticTokens.border,
              width: 1,
            ) : null,
            boxShadow: TailwindDesignTokens.shadow(shadow),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TailwindDesignTokens.radius(rounded)),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(TailwindDesignTokens.radius(rounded)),
              child: Container(
                padding: EdgeInsets.all(TailwindDesignTokens.space(padding)),
                width: double.infinity,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// TailwindButton - 符合 Tailwind CSS 规范的按钮组件
/// 支持多种 variant 和 size
class TailwindButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final String variant;
  final String size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;

  const TailwindButton({
    super.key,
    required this.child,
    this.onPressed,
    this.variant = 'primary',   // primary, secondary, outline, ghost
    this.size = 'md',          // sm, md, lg
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  });

  /// 主要按钮 - 等同于 bg-blue-600 hover:bg-blue-700
  const TailwindButton.primary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    String size = 'md',
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    variant: 'primary',
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  /// 次要按钮 - 等同于 bg-gray-200 hover:bg-gray-300
  const TailwindButton.secondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    String size = 'md',
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    variant: 'secondary',
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  /// 轮廓按钮 - 等同于 border border-blue-600 text-blue-600
  const TailwindButton.outline({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    String size = 'md',
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    variant: 'outline',
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  /// 透明按钮 - 等同于 bg-transparent hover:bg-gray-100
  const TailwindButton.ghost({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    String size = 'md',
    IconData? icon,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    variant: 'ghost',
    size: size,
    icon: icon,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: _getButtonHeight(),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _getBackgroundColor(isDark, context),
          foregroundColor: _getForegroundColor(isDark, context),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')),
            side: variant == 'outline' ? BorderSide(
              color: TailwindSemanticTokens.primary,
              width: 1,
            ) : BorderSide.none,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: TailwindDesignTokens.space(_getHorizontalPadding()),
            vertical: TailwindDesignTokens.space(_getVerticalPadding()),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getForegroundColor(isDark, context),
                  ),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _getIconSize()),
                    SizedBox(width: TailwindDesignTokens.space('2')),
                  ],
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: TailwindDesignTokens.textSize(_getTextSize()),
                      fontWeight: TailwindDesignTokens.fontWeight('medium'),
                    ),
                    child: child,
                  ),
                ],
              ),
      ),
    );
  }

  double _getButtonHeight() {
    switch (size) {
      case 'sm': return TailwindDesignTokens.space('9');  // h-9 = 36px
      case 'md': return TailwindDesignTokens.space('10'); // h-10 = 40px
      case 'lg': return TailwindDesignTokens.space('11'); // h-11 = 44px
      default: return TailwindDesignTokens.space('10');
    }
  }
  
  String _getHorizontalPadding() {
    switch (size) {
      case 'sm': return '3';  // px-3
      case 'md': return '4';  // px-4
      case 'lg': return '6';  // px-6
      default: return '4';
    }
  }
  
  String _getVerticalPadding() {
    switch (size) {
      case 'sm': return '1.5'; // py-1.5
      case 'md': return '2';   // py-2
      case 'lg': return '2.5'; // py-2.5
      default: return '2';
    }
  }
  
  String _getTextSize() {
    switch (size) {
      case 'sm': return 'sm';   // text-sm
      case 'md': return 'base'; // text-base
      case 'lg': return 'lg';   // text-lg
      default: return 'base';
    }
  }
  
  double _getIconSize() {
    switch (size) {
      case 'sm': return 14.0;
      case 'md': return 16.0;
      case 'lg': return 18.0;
      default: return 16.0;
    }
  }

  Color _getBackgroundColor(bool isDark, BuildContext context) {
    switch (variant) {
      case 'primary':
        return TailwindSemanticTokens.getColor(context,
            lightColor: TailwindSemanticTokens.primary,
            darkColor: TailwindSemanticTokens.darkPrimary);
      case 'secondary':
        return isDark 
            ? TailwindSemanticTokens.darkSurfaceVariant
            : TailwindSemanticTokens.surfaceVariant;
      case 'outline':
      case 'ghost':
        return Colors.transparent;
      default:
        return TailwindSemanticTokens.primary;
    }
  }

  Color _getForegroundColor(bool isDark, BuildContext context) {
    switch (variant) {
      case 'primary':
        return isDark 
            ? TailwindDesignTokens.colorBlue[900]!
            : TailwindDesignTokens.colorGray[50]!;
      case 'secondary':
        return isDark
            ? TailwindSemanticTokens.darkOnSurface
            : TailwindSemanticTokens.onSurface;
      case 'outline':
      case 'ghost':
        return TailwindSemanticTokens.getColor(context,
            lightColor: TailwindSemanticTokens.primary,
            darkColor: TailwindSemanticTokens.darkPrimary);
      default:
        return TailwindDesignTokens.colorGray[50]!;
    }
  }
}

/// TailwindMetricCard - Tailwind 风格的指标展示组件
/// 用于显示 KPI 和数据指标
class TailwindMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final String? changeType; // 'positive', 'negative', 'neutral'
  final IconData? icon;
  final VoidCallback? onTap;
  final String padding;
  final String rounded;

  const TailwindMetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.changeType,
    this.icon,
    this.onTap,
    this.padding = '6',       // p-6
    this.rounded = 'lg',      // rounded-lg
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return TailwindCard(
      padding: padding,
      rounded: rounded,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题行
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(TailwindDesignTokens.space('2')), // p-2
                  decoration: BoxDecoration(
                    color: TailwindSemanticTokens.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('')),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: TailwindSemanticTokens.getColor(context,
                        lightColor: TailwindSemanticTokens.primary,
                        darkColor: TailwindSemanticTokens.darkPrimary),
                  ),
                ),
                SizedBox(width: TailwindDesignTokens.space('3')), // w-3
              ],
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: TailwindDesignTokens.textSize('sm'), // text-sm
                    fontWeight: TailwindDesignTokens.fontWeight('medium'), // font-medium
                    color: isDark
                        ? TailwindSemanticTokens.darkOnSurfaceVariant
                        : TailwindSemanticTokens.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TailwindDesignTokens.space('4')), // mt-4
          
          // 数值显示
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: TailwindDesignTokens.textSize('2xl'), // text-2xl
                    fontWeight: TailwindDesignTokens.fontWeight('bold'), // font-bold
                    color: isDark
                        ? TailwindSemanticTokens.darkOnSurface
                        : TailwindSemanticTokens.onSurface,
                  ),
                ),
              ),
              if (change != null && changeType != null) ..._buildChangeIndicator(isDark, context),
            ],
          ),
          
          if (subtitle != null) ...[
            SizedBox(height: TailwindDesignTokens.space('2')), // mt-2
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: TailwindDesignTokens.textSize('xs'), // text-xs
                color: isDark
                    ? TailwindSemanticTokens.darkOnSurfaceVariant
                    : TailwindSemanticTokens.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildChangeIndicator(bool isDark, BuildContext context) {
    Color changeColor;
    IconData changeIcon;
    
    switch (changeType) {
      case 'positive':
        changeColor = TailwindSemanticTokens.getColor(
          context,
          lightColor: TailwindSemanticTokens.success,
          darkColor: TailwindSemanticTokens.darkSuccess,
        );
        changeIcon = Icons.trending_up;
        break;
      case 'negative':
        changeColor = TailwindSemanticTokens.getColor(
          context,
          lightColor: TailwindSemanticTokens.error,
          darkColor: TailwindSemanticTokens.darkError,
        );
        changeIcon = Icons.trending_down;
        break;
      default:
        changeColor = isDark
            ? TailwindSemanticTokens.darkOnSurfaceVariant
            : TailwindSemanticTokens.onSurfaceVariant;
        changeIcon = Icons.trending_flat;
    }

    return [
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: TailwindDesignTokens.space('2'),
          vertical: TailwindDesignTokens.space('1'),
        ),
        decoration: BoxDecoration(
          color: changeColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(TailwindDesignTokens.radius('sm')),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(changeIcon, size: 12, color: changeColor),
            SizedBox(width: TailwindDesignTokens.space('1')),
            Text(
              change!,
              style: TextStyle(
                fontSize: TailwindDesignTokens.textSize('xs'),
                fontWeight: TailwindDesignTokens.fontWeight('semibold'),
                color: changeColor,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}

/// TailwindListItem - Tailwind 风格的列表项组件
class TailwindListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final String padding;

  const TailwindListItem({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.padding = '4',       // p-4
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(TailwindDesignTokens.space(padding)),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: TailwindDesignTokens.space('3')),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: TailwindDesignTokens.textSize('base'),
                          fontWeight: TailwindDesignTokens.fontWeight('medium'),
                          color: isDark
                              ? TailwindSemanticTokens.darkOnSurface
                              : TailwindSemanticTokens.onSurface,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: TailwindDesignTokens.space('1')),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: TailwindDesignTokens.textSize('sm'),
                            color: isDark
                                ? TailwindSemanticTokens.darkOnSurfaceVariant
                                : TailwindSemanticTokens.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: TailwindDesignTokens.space('3')),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: (isDark
                ? TailwindSemanticTokens.darkBorder
                : TailwindSemanticTokens.border).withOpacity(0.5),
          ),
      ],
    );
  }
}

/// TailwindStatusBadge - 状态指示器组件
class TailwindStatusBadge extends StatelessWidget {
  final String status; // 'success', 'warning', 'error', 'info'
  final String? label;
  final double size;
  final bool showDot;

  const TailwindStatusBadge({
    super.key,
    required this.status,
    this.label,
    this.size = 8.0,
    this.showDot = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(isDark);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        if (label != null) ...[
          if (showDot) SizedBox(width: TailwindDesignTokens.space('2')),
          Text(
            label!,
            style: TextStyle(
              fontSize: TailwindDesignTokens.textSize('sm'),
              fontWeight: TailwindDesignTokens.fontWeight('medium'),
              color: statusColor,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(bool isDark) {
    switch (status) {
      case 'success':
        return isDark 
            ? TailwindSemanticTokens.darkSuccess
            : TailwindSemanticTokens.success;
      case 'warning':
        return isDark
            ? TailwindSemanticTokens.darkWarning
            : TailwindSemanticTokens.warning;
      case 'error':
        return isDark
            ? TailwindSemanticTokens.darkError
            : TailwindSemanticTokens.error;
      case 'info':
        return isDark
            ? TailwindSemanticTokens.info  // 使用同一颜色，因为cyan在暗色主题下也很好
            : TailwindSemanticTokens.info;
      default:
        return isDark
            ? TailwindSemanticTokens.darkOnSurfaceVariant
            : TailwindSemanticTokens.onSurfaceVariant;
    }
  }
}

// ==================== 工具类 ====================

/// TailwindUtils - Tailwind 样式工具类
class TailwindUtils {
  /// 获取响应式列数
  static int getResponsiveColumns(BuildContext context, {
    int sm = 1,    // 小屏幕
    int md = 2,    // 中屏幕
    int lg = 3,    // 大屏幕
    int xl = 4,    // 超大屏幕
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= TailwindDesignTokens.breakpoint('xl')) return xl;
    if (width >= TailwindDesignTokens.breakpoint('lg')) return lg;
    if (width >= TailwindDesignTokens.breakpoint('md')) return md;
    return sm;
  }
  
  /// 获取响应式间距
  static double getResponsiveSpacing(BuildContext context, {
    String sm = '4',    // 小屏幕间距
    String md = '6',    // 中屏幕间距
    String lg = '8',    // 大屏幕间距
  }) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= TailwindDesignTokens.breakpoint('lg')) return TailwindDesignTokens.space(lg);
    if (width >= TailwindDesignTokens.breakpoint('md')) return TailwindDesignTokens.space(md);
    return TailwindDesignTokens.space(sm);
  }
  
  /// 检查是否为移动端
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < TailwindDesignTokens.breakpoint('md');
  }
  
  /// 检查是否为平板
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= TailwindDesignTokens.breakpoint('md') && 
           width < TailwindDesignTokens.breakpoint('lg');
  }
  
  /// 检查是否为桌面端
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= TailwindDesignTokens.breakpoint('lg');
  }
}
