import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/md3_animations.dart';

/// Material Design 3 交互式卡片组件
/// 支持悬停、按压动画和语义化颜色
class MD3InteractiveCard extends StatefulWidget {
  const MD3InteractiveCard({
    Key? key,
    required this.child,
    this.onTap,
    this.margin,
    this.elevation,
    this.shadowColor,
    this.surfaceTintColor,
    this.shape,
    this.clipBehavior = Clip.none,
    this.semanticContainer = true,
    this.borderOnForeground = true,
    this.enableHoverAnimation = true,
    this.enablePressAnimation = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final bool semanticContainer;
  final bool borderOnForeground;
  final bool enableHoverAnimation;
  final bool enablePressAnimation;

  @override
  State<MD3InteractiveCard> createState() => _MD3InteractiveCardState();
}

class _MD3InteractiveCardState extends State<MD3InteractiveCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    
    // 初始化悬停动画控制器
    _hoverController = MD3MicroAnimations.createHoverController(this);
    
    // 初始化按压动画控制器
    _pressController = MD3MicroAnimations.createPressController(this);
    
    // 创建缩放动画
    _scaleAnimation = MD3MicroAnimations.createScaleAnimation(
      _pressController,
      minScale: 0.98,
      maxScale: 1.0,
    );
    
    // 创建阴影动画
    _elevationAnimation = MD3MicroAnimations.createElevationAnimation(
      _hoverController,
      minElevation: widget.elevation ?? 2.0,
      maxElevation: (widget.elevation ?? 2.0) + 2.0,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleHoverEnter(PointerEvent event) {
    if (!widget.enableHoverAnimation) return;
    
    setState(() {
      _isHovered = true;
    });
    _hoverController.forward();
  }

  void _handleHoverExit(PointerEvent event) {
    if (!widget.enableHoverAnimation) return;
    
    setState(() {
      _isHovered = false;
    });
    _hoverController.reverse();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enablePressAnimation) return;
    
    setState(() {
      _isPressed = true;
    });
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.enablePressAnimation) return;
    
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
    
    // 触发点击回调
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (!widget.enablePressAnimation) return;
    
    setState(() {
      _isPressed = false;
    });
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: AnimatedBuilder(
        animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Card(
              margin: widget.margin,
              elevation: _elevationAnimation.value,
              shadowColor: widget.shadowColor ?? theme.colorScheme.shadow,
              surfaceTintColor: widget.surfaceTintColor ?? theme.colorScheme.surfaceTint,
              shape: widget.shape,
              clipBehavior: widget.clipBehavior,
              semanticContainer: widget.semanticContainer,
              borderOnForeground: widget.borderOnForeground,
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTapDown: widget.onTap != null ? _handleTapDown : null,
                  onTapUp: widget.onTap != null ? _handleTapUp : null,
                  onTapCancel: widget.onTap != null ? _handleTapCancel : null,
                  onTap: null, // 我们在 onTapUp 中处理点击
                  borderRadius: BorderRadius.circular(TW.radius("md")),
                  splashColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                  highlightColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                  child: AnimatedContainer(
                    duration: MD3Animations.duration100,
                    curve: MD3Animations.standard,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(TW.radius("md")),
                      border: _isHovered && widget.enableHoverAnimation
                          ? Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.12),
                              width: 1,
                            )
                          : null,
                    ),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// MD3 信息卡片组件 - 具有交互动画的文件信息卡片
class MD3FileInfoCard extends StatelessWidget {
  const MD3FileInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String svgSrc;
  final String amountOfFiles;
  final int numOfFiles;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MD3InteractiveCard(
      onTap: onTap,
      margin: EdgeInsets.only(top: TW.space('4')),
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(TW.space('4')),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 32,
              width: 32,
              padding: EdgeInsets.all(TW.space('1')),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(TW.radius("sm")),
              ),
              child: Icon(
                Icons.folder_outlined,
                size: 20,
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: TW.space('4')),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: TW.space('1') / 2),
                    Text(
                      "$numOfFiles 个文件",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              amountOfFiles,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// MD3 存储信息卡片组件 - 具有进度指示和交互动画
class MD3StorageInfoCard extends StatelessWidget {
  const MD3StorageInfoCard({
    Key? key,
    required this.title,
    required this.totalStorage,
    required this.usedStorage,
    required this.percentage,
    required this.color,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String totalStorage;
  final String usedStorage;
  final int percentage;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return MD3InteractiveCard(
      onTap: onTap,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.all(TW.space('4')),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 标题和图标行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(TW.space("2")),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(TW.radius("sm")),
                  ),
                  child: Icon(
                    Icons.storage_outlined,
                    size: 20,
                    color: color,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            
            SizedBox(height: TW.space('4')),
            
            // 标题
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            SizedBox(height: TW.space("2")),
            
            // 进度条
            MD3ProgressIndicator(
              color: color,
              percentage: percentage,
            ),
            
            SizedBox(height: TW.space("2")),
            
            // 存储信息行
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  usedStorage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  totalStorage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// MD3 进度指示器 - 具有动画效果
class MD3ProgressIndicator extends StatefulWidget {
  const MD3ProgressIndicator({
    Key? key,
    this.color = Colors.blue,
    required this.percentage,
    this.height = 6.0,
    this.animationDuration = const Duration(milliseconds: 1200),
  }) : super(key: key);

  final Color color;
  final int percentage;
  final double height;
  final Duration animationDuration;

  @override
  State<MD3ProgressIndicator> createState() => _MD3ProgressIndicatorState();
}

class _MD3ProgressIndicatorState extends State<MD3ProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.percentage / 100.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: MD3Animations.emphasized,
    ));
    
    // 延迟启动动画以创建更好的视觉效果
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 背景轨道
        Container(
          width: double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(widget.height / 2),
          ),
        ),
        
        // 进度条
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return FractionallySizedBox(
              widthFactor: _progressAnimation.value,
              child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(widget.height / 2),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}