import 'package:flutter/material.dart';
import '../utils/md3_animations.dart';

/// Material Design 3 页面转场管理器
/// 为整个应用提供统一的页面转场动画
class MD3PageTransitions {
  
  /// 创建认证转场（登录 <-> 主界面）
  static Route<T> createAuthTransition<T>({
    required Widget child,
    RouteSettings? settings,
    bool isLogin = true,
  }) {
    return MD3Animations.createRoute<T>(
      child: child,
      settings: settings,
      transitionType: isLogin 
          ? MD3TransitionType.fadeThrough 
          : MD3TransitionType.slideFromEnd,
    );
  }
  
  /// 创建主界面内部转场（Dashboard、Tasks等之间的切换）
  static Route<T> createMainTransition<T>({
    required Widget child,
    RouteSettings? settings,
  }) {
    return MD3Animations.createRoute<T>(
      child: child,
      settings: settings,
      transitionType: MD3TransitionType.sharedAxis,
    );
  }
  
  /// 创建模态转场（弹出对话框、底部抽屉等）
  static Route<T> createModalTransition<T>({
    required Widget child,
    RouteSettings? settings,
  }) {
    return MD3Animations.createRoute<T>(
      child: child,
      settings: settings,
      transitionType: MD3TransitionType.slideFromBottom,
    );
  }
  
  /// 创建详情转场（列表项 -> 详情页）
  static Route<T> createDetailTransition<T>({
    required Widget child,
    RouteSettings? settings,
  }) {
    return MD3Animations.createRoute<T>(
      child: child,
      settings: settings,
      transitionType: MD3TransitionType.sharedAxis,
    );
  }
}

/// 带有转场动画的 Navigator 扩展
extension MD3NavigatorExtension on NavigatorState {
  
  /// 使用 MD3 转场推送新页面
  Future<T?> pushMD3<T extends Object?>(
    Widget page, {
    MD3TransitionType transitionType = MD3TransitionType.slideFromEnd,
    RouteSettings? settings,
  }) {
    return push<T>(
      MD3Animations.createRoute<T>(
        child: page,
        settings: settings,
        transitionType: transitionType,
      ),
    );
  }
  
  /// 使用 MD3 转场替换当前页面
  Future<T?> pushReplacementMD3<T extends Object?, TO extends Object?>(
    Widget page, {
    MD3TransitionType transitionType = MD3TransitionType.fadeThrough,
    RouteSettings? settings,
    TO? result,
  }) {
    return pushReplacement<T, TO>(
      MD3Animations.createRoute<T>(
        child: page,
        settings: settings,
        transitionType: transitionType,
      ),
      result: result,
    );
  }
}

/// 主题切换动画组件
/// 在主题切换时提供平滑的过渡效果
class MD3ThemeTransition extends StatefulWidget {
  const MD3ThemeTransition({
    Key? key,
    required this.child,
    required this.themeMode,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final Widget child;
  final ThemeMode themeMode;
  final Duration duration;

  @override
  State<MD3ThemeTransition> createState() => _MD3ThemeTransitionState();
}

class _MD3ThemeTransitionState extends State<MD3ThemeTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  ThemeMode? _previousThemeMode;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: MD3Animations.emphasized,
    ));
    
    _previousThemeMode = widget.themeMode;
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(MD3ThemeTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.themeMode != widget.themeMode && !_isTransitioning) {
      _startThemeTransition();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startThemeTransition() {
    setState(() {
      _isTransitioning = true;
    });
    
    _animationController.reverse().then((_) {
      setState(() {
        _previousThemeMode = widget.themeMode;
        _isTransitioning = false;
      });
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 语言切换动画组件
/// 在语言切换时提供平滑的过渡效果
class MD3LocaleTransition extends StatefulWidget {
  const MD3LocaleTransition({
    Key? key,
    required this.child,
    required this.locale,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  final Widget child;
  final Locale locale;
  final Duration duration;

  @override
  State<MD3LocaleTransition> createState() => _MD3LocaleTransitionState();
}

class _MD3LocaleTransitionState extends State<MD3LocaleTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  
  Locale? _previousLocale;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: MD3Animations.emphasized,
    ));
    
    _previousLocale = widget.locale;
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(MD3LocaleTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.locale != widget.locale && !_isTransitioning) {
      _startLocaleTransition();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startLocaleTransition() {
    setState(() {
      _isTransitioning = true;
    });
    
    _animationController.reverse().then((_) {
      setState(() {
        _previousLocale = widget.locale;
        _isTransitioning = false;
      });
      _animationController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _animationController,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 导航切换动画组件
/// 为底部导航栏的页面切换提供动画
class MD3NavigationTransition extends StatefulWidget {
  const MD3NavigationTransition({
    Key? key,
    required this.child,
    required this.index,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  final Widget child;
  final int index;
  final Duration duration;

  @override
  State<MD3NavigationTransition> createState() => _MD3NavigationTransitionState();
}

class _MD3NavigationTransitionState extends State<MD3NavigationTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  
  int _previousIndex = 0;
  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: MD3Animations.emphasized,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 1.0, curve: MD3Animations.standard),
    ));
    
    _previousIndex = widget.index;
    _animationController.value = 1.0;
  }

  @override
  void didUpdateWidget(MD3NavigationTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.index != widget.index && !_isTransitioning) {
      _startNavigationTransition();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startNavigationTransition() {
    setState(() {
      _isTransitioning = true;
    });
    
    // 确定滑动方向
    final direction = widget.index > _previousIndex ? 1.0 : -1.0;
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.2 * direction, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: MD3Animations.emphasized,
    ));
    
    _animationController.reset();
    _animationController.forward().then((_) {
      setState(() {
        _previousIndex = widget.index;
        _isTransitioning = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideAnimation, _fadeAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: widget.child,
          ),
        );
      },
    );
  }
}