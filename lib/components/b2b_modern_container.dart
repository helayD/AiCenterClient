import 'package:flutter/material.dart';
import '../constants.dart';
import '../theme/tailwind_colors.dart';

/// B2B现代化容器组件 - 替代传统Card设计
/// 采用状态驱动、渐变背景、图标引导的企业级设计
class B2BModernContainer extends StatefulWidget {
  const B2BModernContainer({
    Key? key,
    required this.child,
    this.onTap,
    this.statusColor,
    this.gradientColors,
    this.icon,
    this.title,
    this.subtitle,
    this.trailing,
    this.padding,
    this.margin,
    this.height,
    this.showStatusBar = true,
    this.showHoverEffect = true,
    this.borderRadius,
    this.elevation,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final Color? statusColor;
  final List<Color>? gradientColors;
  final IconData? icon;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final bool showStatusBar;
  final bool showHoverEffect;
  final double? borderRadius;
  final double? elevation;

  @override
  State<B2BModernContainer> createState() => _B2BModernContainerState();
}

class _B2BModernContainerState extends State<B2BModernContainer>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 2.0,
      end: (widget.elevation ?? 2.0) + 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHoverEnter(PointerEvent event) {
    if (!widget.showHoverEffect) return;
    setState(() {
      _isHovered = true;
    });
    _animationController.forward();
  }

  void _handleHoverExit(PointerEvent event) {
    if (!widget.showHoverEffect) return;
    setState(() {
      _isHovered = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: widget.margin ?? EdgeInsets.only(bottom: TechSpacing.md),
            height: widget.height,
            child: MouseRegion(
              onEnter: _handleHoverEnter,
              onExit: _handleHoverExit,
              cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
              child: Material(
                elevation: _elevationAnimation.value,
                borderRadius: BorderRadius.circular(
                  widget.borderRadius ?? TechRadius.md,
                ),
                shadowColor: (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.15),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? TechRadius.md,
                    ),
                    gradient: widget.gradientColors != null
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: widget.gradientColors!,
                          )
                        : null,
                    color: widget.gradientColors == null
                        ? (isDark ? const Color(0xFF1A1D23) : Colors.white)
                        : null,
                    border: Border.all(
                      color: _isHovered
                          ? (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.3)
                          : (isDark ? TailwindColors.slate600 : TailwindColors.slate300).withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 主要内容区域
                      InkWell(
                        onTap: widget.onTap,
                        borderRadius: BorderRadius.circular(
                          widget.borderRadius ?? TechRadius.md,
                        ),
                        splashColor: (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.1),
                        highlightColor: (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.05),
                        child: IntrinsicWidth(
                          child: Container(
                            padding: widget.padding ?? EdgeInsets.all(TechSpacing.lg),
                            child: _buildContent(context),
                          ),
                        ),
                      ),
                      
                      // 状态指示条
                      if (widget.showStatusBar)
                        Positioned(
                          left: 0,
                          top: 0,
                          bottom: 0,
                          child: Container(
                            width: 4,
                            decoration: BoxDecoration(
                              color: widget.statusColor ?? TailwindSemanticColors.primary,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(widget.borderRadius ?? TechRadius.md),
                                bottomLeft: Radius.circular(widget.borderRadius ?? TechRadius.md),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context) {
    if (widget.title != null || widget.subtitle != null || widget.icon != null) {
      return _buildStructuredContent(context);
    }
    return widget.child;
  }

  Widget _buildStructuredContent(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        // 图标区域
        if (widget.icon != null) ...[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.1),
                  (widget.statusColor ?? TailwindSemanticColors.primary).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(TechRadius.sm),
            ),
            child: Icon(
              widget.icon,
              size: 24,
              color: widget.statusColor ?? TailwindSemanticColors.primary,
            ),
          ),
          SizedBox(width: TechSpacing.lg),
        ],
        
        // 文本内容区域
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
              if (widget.subtitle != null) ...[
                SizedBox(height: TechSpacing.xs),
                Text(
                  widget.subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
              if (widget.title == null && widget.subtitle == null)
                widget.child,
            ],
          ),
        ),
        
        // 尾部区域
        if (widget.trailing != null) ...[
          SizedBox(width: TechSpacing.md),
          widget.trailing!,
        ],
      ],
    );
  }
}

/// B2B数据展示容器 - 用于仪表板指标展示
class B2BDataContainer extends StatelessWidget {
  const B2BDataContainer({
    Key? key,
    required this.title,
    required this.value,
    this.subtitle,
    this.trend,
    this.trendValue,
    this.icon,
    this.color,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String value;
  final String? subtitle;
  final TrendDirection? trend;
  final String? trendValue;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? TailwindSemanticColors.primary;
    
    return B2BModernContainer(
      onTap: onTap,
      statusColor: effectiveColor,
      padding: EdgeInsets.all(TechSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题和图标行
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(TechSpacing.sm),
                  decoration: BoxDecoration(
                    color: effectiveColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(TechRadius.sm),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: effectiveColor,
                  ),
                ),
                SizedBox(width: TechSpacing.md),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
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
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trend != null && trendValue != null) ...[
                SizedBox(width: TechSpacing.sm),
                _buildTrendIndicator(context),
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

  Widget _buildTrendIndicator(BuildContext context) {
    final theme = Theme.of(context);
    
    Color trendColor;
    IconData trendIcon;
    
    switch (trend!) {
      case TrendDirection.up:
        trendColor = TailwindColors.green500;
        trendIcon = Icons.trending_up_rounded;
        break;
      case TrendDirection.down:
        trendColor = TailwindColors.red500;
        trendIcon = Icons.trending_down_rounded;
        break;
      case TrendDirection.neutral:
        trendColor = TailwindColors.slate500;
        trendIcon = Icons.trending_flat_rounded;
        break;
    }
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.sm,
        vertical: TechSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(TechRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            trendIcon,
            size: 16,
            color: trendColor,
          ),
          SizedBox(width: TechSpacing.xs),
          Text(
            trendValue!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 趋势方向枚举
enum TrendDirection {
  up,
  down,
  neutral,
}

/// B2B列表项容器 - 现代化列表设计
class B2BListItem extends StatelessWidget {
  const B2BListItem({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.statusColor,
    this.showStatusBar = false,
  }) : super(key: key);

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? statusColor;
  final bool showStatusBar;

  @override
  Widget build(BuildContext context) {
    return B2BModernContainer(
      onTap: onTap,
      statusColor: statusColor,
      showStatusBar: showStatusBar,
      elevation: 1.0,
      padding: EdgeInsets.all(TechSpacing.lg),
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
                if (title != null)
                  Text(
                    title!,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (subtitle != null) ...[
                  SizedBox(height: TechSpacing.xs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
    );
  }
}