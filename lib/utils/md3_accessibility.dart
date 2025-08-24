import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

/// Material Design 3 可访问性工具类
/// 提供全面的无障碍访问支持
class MD3Accessibility {
  
  // WCAG 2.1 AA 标准最小对比度
  static const double minimumContrastRatio = 4.5;
  static const double minimumLargeTextContrastRatio = 3.0;
  
  // 大文本阈值
  static const double largeTextThreshold = 18.0;
  static const double largeBoldTextThreshold = 14.0;
  
  /// 检查颜色对比度是否符合 WCAG 标准
  static bool isContrastCompliant(Color foreground, Color background, {
    bool isLargeText = false,
  }) {
    final contrastRatio = calculateContrastRatio(foreground, background);
    final minRatio = isLargeText ? minimumLargeTextContrastRatio : minimumContrastRatio;
    return contrastRatio >= minRatio;
  }
  
  /// 计算两种颜色之间的对比度
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (lighter + 0.05) / (darker + 0.05);
  }
  
  /// 获取符合对比度要求的文本颜色
  static Color getAccessibleTextColor(Color backgroundColor, {
    bool isLargeText = false,
    Color? preferredColor,
  }) {
    if (preferredColor != null && 
        isContrastCompliant(preferredColor, backgroundColor, isLargeText: isLargeText)) {
      return preferredColor;
    }
    
    // 尝试黑色文本
    if (isContrastCompliant(Colors.black, backgroundColor, isLargeText: isLargeText)) {
      return Colors.black;
    }
    
    // 使用白色文本
    return Colors.white;
  }
  
  /// 创建语义化标签
  static String createSemanticLabel({
    required String baseText,
    String? role,
    String? state,
    String? description,
  }) {
    final parts = <String>[baseText];
    
    if (role != null) parts.add(role);
    if (state != null) parts.add(state);
    if (description != null) parts.add(description);
    
    return parts.join(', ');
  }
  
  /// 创建焦点管理器
  static FocusNode createManagedFocusNode({
    String? debugLabel,
    bool skipTraversal = false,
    bool canRequestFocus = true,
  }) {
    return FocusNode(
      debugLabel: debugLabel,
      skipTraversal: skipTraversal,
      canRequestFocus: canRequestFocus,
    );
  }
  
  /// 播放可访问性音效
  static void playAccessibilitySound(SystemSoundType sound) {
    SystemSound.play(sound);
  }
  
  /// 创建可访问性公告
  static void announce(String message, {
    TextDirection textDirection = TextDirection.ltr,
  }) {
    SemanticsService.announce(message, textDirection);
  }
}

/// Material Design 3 语义化组件基类
/// 为所有组件提供基础的可访问性支持
mixin MD3AccessibilityMixin<T extends StatefulWidget> on State<T> {
  FocusNode? _focusNode;
  
  @protected
  FocusNode get focusNode => _focusNode ??= MD3Accessibility.createManagedFocusNode(
    debugLabel: widget.runtimeType.toString(),
  );
  
  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }
  
  /// 构建语义化包装器
  @protected
  Widget buildAccessibleWidget({
    required Widget child,
    String? semanticLabel,
    String? hint,
    String? tooltip,
    VoidCallback? onTap,
    bool enabled = true,
    bool focusable = true,
    bool button = false,
    bool header = false,
    bool link = false,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: hint,
      button: button,
      header: header,
      link: link,
      enabled: enabled,
      focusable: focusable && enabled,
      child: tooltip != null 
        ? Tooltip(
            message: tooltip,
            child: child,
          )
        : child,
    );
  }
}

/// 可访问的按钮包装器
class MD3AccessibleButton extends StatefulWidget {
  const MD3AccessibleButton({
    Key? key,
    required this.child,
    required this.onPressed,
    this.onLongPress,
    this.semanticLabel,
    this.tooltip,
    this.hint,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final String? tooltip;
  final String? hint;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;

  @override
  State<MD3AccessibleButton> createState() => _MD3AccessibleButtonState();
}

class _MD3AccessibleButtonState extends State<MD3AccessibleButton>
    with MD3AccessibilityMixin {
  bool _isFocused = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return buildAccessibleWidget(
      semanticLabel: widget.semanticLabel,
      hint: widget.hint,
      tooltip: widget.tooltip,
      enabled: widget.enabled && widget.onPressed != null,
      button: true,
      child: Focus(
        focusNode: widget.focusNode ?? focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
        },
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: widget.onPressed != null ? SystemMouseCursors.click : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: widget.enabled ? () {
              MD3Accessibility.playAccessibilitySound(SystemSoundType.click);
              widget.onPressed?.call();
            } : null,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            child: Container(
              decoration: _isFocused ? BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(TW.radius("sm")),
              ) : null,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 可访问的文本输入框
class MD3AccessibleTextField extends StatefulWidget {
  const MD3AccessibleTextField({
    Key? key,
    this.controller,
    this.decoration,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.semanticLabel,
    this.hint,
    this.errorText,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final String? semanticLabel;
  final String? hint;
  final String? errorText;
  final FocusNode? focusNode;

  @override
  State<MD3AccessibleTextField> createState() => _MD3AccessibleTextFieldState();
}

class _MD3AccessibleTextFieldState extends State<MD3AccessibleTextField>
    with MD3AccessibilityMixin {
  
  @override
  Widget build(BuildContext context) {
    return buildAccessibleWidget(
      semanticLabel: widget.semanticLabel,
      hint: widget.hint,
      enabled: widget.enabled,
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode ?? focusNode,
        decoration: widget.decoration?.copyWith(
          errorText: widget.errorText,
        ),
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        autofocus: widget.autofocus,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        validator: widget.validator,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: MD3Accessibility.getAccessibleTextColor(
            Theme.of(context).colorScheme.surface,
            preferredColor: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// 可访问的列表项
class MD3AccessibleListTile extends StatefulWidget {
  const MD3AccessibleListTile({
    Key? key,
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.selected = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.hint,
    this.tooltip,
  }) : super(key: key);

  final Widget? leading;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final bool selected;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;
  final String? hint;
  final String? tooltip;

  @override
  State<MD3AccessibleListTile> createState() => _MD3AccessibleListTileState();
}

class _MD3AccessibleListTileState extends State<MD3AccessibleListTile>
    with MD3AccessibilityMixin {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return buildAccessibleWidget(
      semanticLabel: widget.semanticLabel,
      hint: widget.hint,
      tooltip: widget.tooltip,
      enabled: widget.enabled,
      button: widget.onTap != null,
      child: Focus(
        focusNode: widget.focusNode ?? focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focused) {
          setState(() {
            _isFocused = focused;
          });
          
          if (focused && widget.selected) {
            MD3Accessibility.announce("已选择${widget.semanticLabel ?? '项目'}");
          }
        },
        child: Container(
          decoration: _isFocused ? BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(TW.radius("sm")),
          ) : null,
          child: ListTile(
            leading: widget.leading,
            title: widget.title,
            subtitle: widget.subtitle,
            trailing: widget.trailing,
            onTap: widget.enabled ? () {
              MD3Accessibility.playAccessibilitySound(SystemSoundType.click);
              widget.onTap?.call();
            } : null,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            enabled: widget.enabled,
            selected: widget.selected,
            selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.12),
            focusColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
            hoverColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
          ),
        ),
      ),
    );
  }
}

/// 屏幕阅读器支持工具
class MD3ScreenReaderSupport {
  
  /// 检查屏幕阅读器是否启用
  static bool isScreenReaderEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }
  
  /// 为屏幕阅读器优化文本
  static String optimizeTextForScreenReader(String text) {
    return text
        .replaceAll('&', '和')
        .replaceAll('@', '艾特')
        .replaceAll('#', '井号')
        .replaceAll('%', '百分号');
  }
  
  /// 创建屏幕阅读器友好的描述
  static String createScreenReaderDescription({
    required String mainContent,
    String? context,
    String? instructions,
  }) {
    final parts = <String>[mainContent];
    
    if (context != null) parts.add("上下文: $context");
    if (instructions != null) parts.add("操作提示: $instructions");
    
    return parts.join(". ");
  }
}

/// 高对比度模式支持
class MD3HighContrastSupport {
  
  /// 获取高对比度主题色彩
  static ColorScheme getHighContrastColors(Brightness brightness) {
    if (brightness == Brightness.dark) {
      return const ColorScheme.dark(
        primary: Colors.white,
        onPrimary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
        error: Colors.red,
        onError: Colors.white,
      );
    } else {
      return const ColorScheme.light(
        primary: Colors.black,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        error: Colors.red,
        onError: Colors.white,
      );
    }
  }
  
  /// 检查是否启用高对比度模式
  static bool isHighContrastEnabled(BuildContext context) {
    return MediaQuery.of(context).highContrast;
  }
}