import 'package:flutter/material.dart';
import '../constants.dart';
import '../utils/md3_animations.dart';
import '../theme/tailwind_colors.dart';

/// Material Design 3 增强按钮基类
/// 提供统一的动画和交互行为
abstract class MD3ButtonBase extends StatefulWidget {
  const MD3ButtonBase({
    Key? key,
    required this.onPressed,
    required this.child,
    this.onLongPress,
    this.style,
    this.autofocus = false,
    this.clipBehavior = Clip.none,
    this.enableFeedback = true,
    this.enableHoverAnimation = true,
    this.enablePressAnimation = true,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final Widget child;
  final ButtonStyle? style;
  final bool autofocus;
  final Clip clipBehavior;
  final bool enableFeedback;
  final bool enableHoverAnimation;
  final bool enablePressAnimation;

  @protected
  ButtonStyle getDefaultStyle(BuildContext context);
}

abstract class MD3ButtonBaseState<T extends MD3ButtonBase> extends State<T>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isHovered = false;
  bool _isPressed = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    
    _hoverController = MD3MicroAnimations.createHoverController(this);
    _pressController = MD3MicroAnimations.createPressController(this);
    
    _scaleAnimation = MD3MicroAnimations.createScaleAnimation(
      _pressController,
      minScale: 0.95,
      maxScale: 1.0,
    );
    
    _elevationAnimation = MD3MicroAnimations.createElevationAnimation(
      _hoverController,
      minElevation: 1.0,
      maxElevation: 3.0,
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  void _handleHoverEnter(PointerEvent event) {
    if (!widget.enableHoverAnimation || widget.onPressed == null) return;
    
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

  void _handleFocusChange(bool hasFocus) {
    setState(() {
      _isFocused = hasFocus;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.enablePressAnimation || widget.onPressed == null) return;
    
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
    final defaultStyle = widget.getDefaultStyle(context);
    final mergedStyle = defaultStyle.merge(widget.style);

    return MouseRegion(
      onEnter: _handleHoverEnter,
      onExit: _handleHoverExit,
      cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
      child: Focus(
        onFocusChange: _handleFocusChange,
        child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _elevationAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: buildButton(context, mergedStyle),
            );
          },
        ),
      ),
    );
  }

  @protected
  Widget buildButton(BuildContext context, ButtonStyle style);

  @protected
  ButtonStyle getHoverStyle(ButtonStyle baseStyle) {
    if (!_isHovered) return baseStyle;
    
    return baseStyle.copyWith(
      elevation: MaterialStateProperty.all(_elevationAnimation.value),
      shadowColor: MaterialStateProperty.all(
        Theme.of(context).colorScheme.shadow.withValues(alpha: 0.2),
      ),
    );
  }
}

/// Material Design 3 增强的 ElevatedButton
class MD3ElevatedButton extends MD3ButtonBase {
  const MD3ElevatedButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    bool enableHoverAnimation = true,
    bool enablePressAnimation = true,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          onLongPress: onLongPress,
          style: style,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          enableFeedback: enableFeedback,
          enableHoverAnimation: enableHoverAnimation,
          enablePressAnimation: enablePressAnimation,
        );

  @override
  State<MD3ElevatedButton> createState() => _MD3ElevatedButtonState();

  @override
  ButtonStyle getDefaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      elevation: 1.0,
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.lg,
        vertical: TechSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TechRadius.full),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      animationDuration: Duration(milliseconds: 200),
    );
  }
}

class _MD3ElevatedButtonState extends MD3ButtonBaseState<MD3ElevatedButton> {
  @override
  Widget buildButton(BuildContext context, ButtonStyle style) {
    final enhancedStyle = getHoverStyle(style);
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        style: enhancedStyle,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        child: AnimatedDefaultTextStyle(
          style: enhancedStyle.textStyle?.resolve({}) ?? 
                 Theme.of(context).textTheme.labelLarge!,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Material Design 3 增强的 FilledButton
class MD3FilledButton extends MD3ButtonBase {
  const MD3FilledButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    bool enableHoverAnimation = true,
    bool enablePressAnimation = true,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          onLongPress: onLongPress,
          style: style,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          enableFeedback: enableFeedback,
          enableHoverAnimation: enableHoverAnimation,
          enablePressAnimation: enablePressAnimation,
        );

  @override
  State<MD3FilledButton> createState() => _MD3FilledButtonState();

  @override
  ButtonStyle getDefaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    return FilledButton.styleFrom(
      elevation: 0.0,
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.lg,
        vertical: TechSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TechRadius.full),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      animationDuration: Duration(milliseconds: 200),
    );
  }
}

class _MD3FilledButtonState extends MD3ButtonBaseState<MD3FilledButton> {
  @override
  Widget buildButton(BuildContext context, ButtonStyle style) {
    final enhancedStyle = getHoverStyle(style);
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: FilledButton(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        style: enhancedStyle,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        child: AnimatedDefaultTextStyle(
          style: enhancedStyle.textStyle?.resolve({}) ?? 
                 Theme.of(context).textTheme.labelLarge!,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Material Design 3 增强的 OutlinedButton
class MD3OutlinedButton extends MD3ButtonBase {
  const MD3OutlinedButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    bool enableHoverAnimation = true,
    bool enablePressAnimation = true,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          onLongPress: onLongPress,
          style: style,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          enableFeedback: enableFeedback,
          enableHoverAnimation: enableHoverAnimation,
          enablePressAnimation: enablePressAnimation,
        );

  @override
  State<MD3OutlinedButton> createState() => _MD3OutlinedButtonState();

  @override
  ButtonStyle getDefaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.styleFrom(
      elevation: 0.0,
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.lg,
        vertical: TechSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TechRadius.full),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: theme.colorScheme.outline,
        width: 1.0,
      ),
      animationDuration: Duration(milliseconds: 200),
    );
  }
}

class _MD3OutlinedButtonState extends MD3ButtonBaseState<MD3OutlinedButton> {
  @override
  Widget buildButton(BuildContext context, ButtonStyle style) {
    final theme = Theme.of(context);
    
    // 为 OutlinedButton 添加特殊的悬停效果
    final enhancedStyle = style.copyWith(
      side: _isHovered ? MaterialStateProperty.all(
        BorderSide(
          color: theme.colorScheme.primary,
          width: 2.0,
        ),
      ) : style.side,
      backgroundColor: _isHovered ? MaterialStateProperty.all(
        theme.colorScheme.primary.withValues(alpha: 0.04),
      ) : style.backgroundColor,
    );
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: OutlinedButton(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        style: enhancedStyle,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        child: AnimatedDefaultTextStyle(
          style: enhancedStyle.textStyle?.resolve({}) ?? 
                 Theme.of(context).textTheme.labelLarge!,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Material Design 3 增强的 TextButton
class MD3TextButton extends MD3ButtonBase {
  const MD3TextButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    VoidCallback? onLongPress,
    ButtonStyle? style,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    bool enableFeedback = true,
    bool enableHoverAnimation = true,
    bool enablePressAnimation = true,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: child,
          onLongPress: onLongPress,
          style: style,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          enableFeedback: enableFeedback,
          enableHoverAnimation: enableHoverAnimation,
          enablePressAnimation: enablePressAnimation,
        );

  @override
  State<MD3TextButton> createState() => _MD3TextButtonState();

  @override
  ButtonStyle getDefaultStyle(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton.styleFrom(
      elevation: 0.0,
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.lg,
        vertical: TechSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TechRadius.full),
      ),
      textStyle: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w500,
      ),
      animationDuration: Duration(milliseconds: 200),
    );
  }
}

class _MD3TextButtonState extends MD3ButtonBaseState<MD3TextButton> {
  @override
  Widget buildButton(BuildContext context, ButtonStyle style) {
    final theme = Theme.of(context);
    
    // 为 TextButton 添加特殊的悬停效果
    final enhancedStyle = style.copyWith(
      backgroundColor: _isHovered ? MaterialStateProperty.all(
        theme.colorScheme.primary.withValues(alpha: 0.08),
      ) : style.backgroundColor,
      foregroundColor: _isHovered ? MaterialStateProperty.all(
        theme.colorScheme.primary,
      ) : style.foregroundColor,
    );
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: TextButton(
        onPressed: widget.onPressed,
        onLongPress: widget.onLongPress,
        style: enhancedStyle,
        autofocus: widget.autofocus,
        clipBehavior: widget.clipBehavior,
        child: AnimatedDefaultTextStyle(
          style: enhancedStyle.textStyle?.resolve({}) ?? 
                 Theme.of(context).textTheme.labelLarge!,
          duration: Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: widget.child,
        ),
      ),
    );
  }
}