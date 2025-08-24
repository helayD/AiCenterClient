import 'package:flutter/material.dart';
import '../constants.dart';
import '../theme/tech_theme_system.dart';
import '../theme/tailwind_colors.dart';

/// 科技商务风格核心组件库
/// 基于扁平化设计理念，结合科技商务美学
/// 所有组件支持明暗双主题自动适配

// ==================== 容器组件 ====================

/// 科技风格卡片 - 替代传统Card的扁平化设计
class TechCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final VoidCallback? onTap;
  final bool showBorder;
  final bool showShadow;

  const TechCard({
    Key? key,
    required this.child,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.onTap,
    this.showBorder = true,
    this.showShadow = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      margin: margin ?? EdgeInsets.all(TechSpacing.sm),
      child: Material(
        color: backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(TechRadius.md),
        elevation: showShadow ? 2 : 0,
        shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TechRadius.md),
            border: showBorder ? Border.all(
              color: borderColor ?? (isDark 
                ? TailwindSemanticColors.darkBorderVariant.withOpacity(0.6)
                : TailwindSemanticColors.border),
              width: borderWidth ?? TechSpacing.px,
            ) : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(TechRadius.md),
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(TechRadius.md),
              splashColor: theme.colorScheme.primary.withOpacity(0.1),
              highlightColor: theme.colorScheme.primary.withOpacity(0.05),
              child: Container(
                padding: padding ?? EdgeInsets.all(TechSpacing.lg),
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

/// 指标展示组件 - 用于显示KPI和数据指标
class MetricDisplay extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? change;
  final TrendType? trend;
  final Color? accentColor;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showTrend;

  const MetricDisplay({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.change,
    this.trend,
    this.accentColor,
    this.icon,
    this.onTap,
    this.showTrend = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return TechCard(
      onTap: onTap,
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 标题行
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(TechSpacing.sm),
                  decoration: BoxDecoration(
                    color: (accentColor ?? theme.colorScheme.primary).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TechRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: accentColor ?? theme.colorScheme.primary,
                  ),
                ),
                SizedBox(width: TechSpacing.md),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: TechTypography.medium,
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: TechSpacing.lg),
          
          // 数值显示
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: TechTypography.bold,
                    letterSpacing: TechTypography.letterSpacingTight,
                  ),
                ),
              ),
              if (showTrend && change != null) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: TechSpacing.sm,
                    vertical: TechSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: _getTrendColor(context, change!).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TechRadius.sm),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getTrendIcon(change!),
                        size: 16,
                        color: _getTrendColor(context, change!),
                      ),
                      SizedBox(width: TechSpacing.xs),
                      Text(
                        change!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getTrendColor(context, change!),
                          fontWeight: TechTypography.semiBold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          
          if (subtitle != null) ...[
            SizedBox(height: TechSpacing.sm),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _getTrendColor(BuildContext context, String trend) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    if (trend.startsWith('+')) {
      return isDark 
        ? TailwindSemanticColors.darkSuccess
        : TailwindSemanticColors.success;
    } else if (trend.startsWith('-')) {
      return isDark
        ? TailwindSemanticColors.darkError
        : TailwindSemanticColors.error;
    } else {
      return theme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getTrendIcon(String trend) {
    if (trend.startsWith('+')) {
      return Icons.trending_up;
    } else if (trend.startsWith('-')) {
      return Icons.trending_down;
    } else {
      return Icons.trending_flat;
    }
  }
}

/// 科技风格按钮
class TechButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final IconData? icon;
  final TechButtonVariant variant;
  final TechButtonSize size;
  final bool isLoading;
  final bool isFullWidth;

  const TechButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.icon,
    this.variant = TechButtonVariant.primary,
    this.size = TechButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
  }) : super(key: key);

  /// 创建主要按钮
  const TechButton.primary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    IconData? icon,
    TechButtonSize size = TechButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    icon: icon,
    variant: TechButtonVariant.primary,
    size: size,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  /// 创建次要按钮
  const TechButton.secondary({
    Key? key,
    required Widget child,
    VoidCallback? onPressed,
    IconData? icon,
    TechButtonSize size = TechButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
  }) : this(
    key: key,
    child: child,
    onPressed: onPressed,
    icon: icon,
    variant: TechButtonVariant.secondary,
    size: size,
    isLoading: isLoading,
    isFullWidth: isFullWidth,
  );

  @override
  State<TechButton> createState() => _TechButtonState();
}

class _TechButtonState extends State<TechButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: TechDuration.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: TechCurves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            width: widget.isFullWidth ? double.infinity : null,
            height: _getButtonHeight(),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: _getBackgroundColor(theme, isDark),
                foregroundColor: _getForegroundColor(theme, isDark),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TechRadius.sm),
                  side: widget.variant == TechButtonVariant.outline
                      ? BorderSide(
                          color: theme.colorScheme.primary,
                          width: TechSpacing.px,
                        )
                      : BorderSide.none,
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getForegroundColor(theme, isDark),
                        ),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.icon != null) ...[
                          Icon(
                            widget.icon,
                            size: _getIconSize(),
                          ),
                          SizedBox(width: TechSpacing.sm),
                        ],
                        widget.child,
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case TechButtonSize.small:
        return 36.0;
      case TechButtonSize.medium:
        return 44.0;
      case TechButtonSize.large:
        return 52.0;
    }
  }

  double _getFontSize() {
    switch (widget.size) {
      case TechButtonSize.small:
        return TechTypography.bodySmall;
      case TechButtonSize.medium:
        return TechTypography.bodyMedium;
      case TechButtonSize.large:
        return TechTypography.bodyLarge;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case TechButtonSize.small:
        return 16.0;
      case TechButtonSize.medium:
        return 20.0;
      case TechButtonSize.large:
        return 24.0;
    }
  }

  Color _getBackgroundColor(ThemeData theme, bool isDark) {
    switch (widget.variant) {
      case TechButtonVariant.primary:
        return theme.colorScheme.primary;
      case TechButtonVariant.secondary:
        return isDark 
          ? TailwindSemanticColors.darkSurfaceVariant
          : TailwindSemanticColors.surfaceVariant;
      case TechButtonVariant.outline:
      case TechButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor(ThemeData theme, bool isDark) {
    switch (widget.variant) {
      case TechButtonVariant.primary:
        return theme.colorScheme.onPrimary;
      case TechButtonVariant.secondary:
        return theme.colorScheme.onSurfaceVariant;
      case TechButtonVariant.outline:
      case TechButtonVariant.ghost:
        return theme.colorScheme.primary;
    }
  }
}

/// 按钮变体枚举
enum TechButtonVariant { 
  primary,   // 实心主色
  secondary, // 实心次色
  outline,   // 描边
  ghost,     // 透明
}

/// 按钮尺寸枚举
enum TechButtonSize { 
  small,   // 小按钮
  medium,  // 中按钮
  large,   // 大按钮
}

/// 趋势类型枚举
enum TrendType {
  up,      // 上升趋势
  down,    // 下降趋势
  neutral, // 平稳趋势
}

// ==================== 列表组件 ====================

/// 科技风格列表项
class TechListItem extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const TechListItem({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          splashColor: theme.colorScheme.primary.withOpacity(0.1),
          highlightColor: theme.colorScheme.primary.withOpacity(0.05),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: TechSpacing.lg,
              vertical: TechSpacing.md,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: TechSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: TechTypography.medium,
                        ),
                      ),
                      if (subtitle != null) ...[
                        SizedBox(height: TechSpacing.xs),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  SizedBox(width: TechSpacing.md),
                  trailing!,
                ],
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: TechSpacing.px,
            thickness: TechSpacing.px,
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
      ],
    );
  }
}

// ==================== 状态组件 ====================

/// 状态指示器
class StatusIndicator extends StatelessWidget {
  final StatusType status;
  final String? label;
  final double size;

  const StatusIndicator({
    Key? key,
    required this.status,
    this.label,
    this.size = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: _getStatusColor(isDark),
            shape: BoxShape.circle,
          ),
        ),
        if (label != null) ...[
          SizedBox(width: TechSpacing.sm),
          Text(
            label!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: _getStatusColor(isDark),
              fontWeight: TechTypography.medium,
            ),
          ),
        ],
      ],
    );
  }

  Color _getStatusColor(bool isDark) {
    switch (status) {
      case StatusType.success:
        return isDark 
          ? TailwindSemanticColors.darkSuccess
          : TailwindSemanticColors.success;
      case StatusType.warning:
        return isDark
          ? TailwindSemanticColors.darkWarning
          : TailwindSemanticColors.warning;
      case StatusType.error:
        return isDark
          ? TailwindSemanticColors.darkError
          : TailwindSemanticColors.error;
      case StatusType.info:
        return isDark
          ? TailwindSemanticColors.darkInfo
          : TailwindSemanticColors.info;
      case StatusType.inactive:
        return isDark
          ? TailwindSemanticColors.darkOnSurfaceDisabled
          : TailwindSemanticColors.onSurfaceDisabled;
    }
  }
}

/// 状态类型枚举
enum StatusType { 
  success,  // 成功
  warning,  // 警告
  error,    // 错误
  info,     // 信息
  inactive, // 非活跃
}

// ==================== 工具类 ====================

/// 科技主题工具类
class TechThemeUtils {
  /// 获取当前主题的Tailwind语义色彩
  static Map<String, Color> getTechColors(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (isDark) {
      return {
        'primary': TailwindSemanticColors.darkPrimary,
        'success': TailwindSemanticColors.darkSuccess,
        'warning': TailwindSemanticColors.darkWarning,
        'error': TailwindSemanticColors.darkError,
        'info': TailwindSemanticColors.darkInfo,
      };
    } else {
      return {
        'primary': TailwindSemanticColors.primary,
        'success': TailwindSemanticColors.success,
        'warning': TailwindSemanticColors.warning,
        'error': TailwindSemanticColors.error,
        'info': TailwindSemanticColors.info,
      };
    }
  }

  /// 响应式断点检查
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < TechBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= TechBreakpoints.mobile &&
           width < TechBreakpoints.laptop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= TechBreakpoints.laptop;
  }

  /// 获取响应式列数
  static int getResponsiveColumns(BuildContext context, {
    int mobile = 1,
    int tablet = 2,
    int desktop = 3,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }

  /// 获取响应式间距
  static double getResponsiveSpacing(BuildContext context, {
    double mobile = TechSpacing.md,
    double tablet = TechSpacing.lg,
    double desktop = TechSpacing.xl,
  }) {
    if (isDesktop(context)) return desktop;
    if (isTablet(context)) return tablet;
    return mobile;
  }
}