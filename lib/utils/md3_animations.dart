import 'package:flutter/material.dart';

/// Material Design 3 动画和交互系统
/// 基于官方MD3动态设计标准实现
class MD3Animations {
  
  // Material Design 3 动画时长标准
  static const Duration duration50 = Duration(milliseconds: 50);
  static const Duration duration100 = Duration(milliseconds: 100);
  static const Duration duration150 = Duration(milliseconds: 150);
  static const Duration duration200 = Duration(milliseconds: 200);
  static const Duration duration250 = Duration(milliseconds: 250);
  static const Duration duration300 = Duration(milliseconds: 300);
  static const Duration duration350 = Duration(milliseconds: 350);
  static const Duration duration400 = Duration(milliseconds: 400);
  static const Duration duration500 = Duration(milliseconds: 500);
  static const Duration duration700 = Duration(milliseconds: 700);
  
  // Material Design 3 缓动曲线标准
  static const Curve linear = Curves.linear;
  static const Curve standard = Curves.fastOutSlowIn;  // Material 3 标准曲线
  static const Curve standardAccelerate = Curves.easeInCubic;
  static const Curve standardDecelerate = Curves.fastOutSlowIn;
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;  // MD3 强调曲线
  static const Curve emphasizedAccelerate = Curves.easeInCubic;
  static const Curve emphasizedDecelerate = Curves.easeOutCubic;
  
  // 页面转场动画 - Material 3 标准
  static Route<T> createRoute<T>({
    required Widget child,
    RouteSettings? settings,
    MD3TransitionType transitionType = MD3TransitionType.slideFromEnd,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionDuration: duration300,
      reverseTransitionDuration: duration200,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return _buildTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
          transitionType: transitionType,
        );
      },
    );
  }
  
  // 构建转场动画
  static Widget _buildTransition({
    required Animation<double> animation,
    required Animation<double> secondaryAnimation,
    required Widget child,
    required MD3TransitionType transitionType,
  }) {
    switch (transitionType) {
      case MD3TransitionType.fadeThrough:
        return FadeThroughTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          child: child,
        );
      case MD3TransitionType.fadeIn:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      case MD3TransitionType.slideFromEnd:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: emphasized,
          )),
          child: child,
        );
      case MD3TransitionType.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0.0, 1.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: emphasized,
          )),
          child: child,
        );
      case MD3TransitionType.sharedAxis:
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
    }
  }
}

/// Material Design 3 转场动画类型
enum MD3TransitionType {
  fadeThrough,    // 淡入淡出穿越
  fadeIn,         // 简单淡入
  slideFromEnd,   // 从右侧滑入
  slideFromBottom, // 从底部滑入
  sharedAxis,     // 共享轴转场
}

/// Fade Through 转场实现
class FadeThroughTransition extends StatelessWidget {
  const FadeThroughTransition({
    Key? key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.35, 1.0, curve: MD3Animations.standard),
          ),
          child: child,
        );
      },
      reverseBuilder: (context, animation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: const Interval(0.0, 0.35, curve: MD3Animations.standard),
          ),
          child: child!,
        );
      },
      child: DualTransitionBuilder(
        animation: secondaryAnimation,
        forwardBuilder: (context, animation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.0, 0.35, curve: MD3Animations.standard),
            ),
            child: child,
          );
        },
        reverseBuilder: (context, animation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: ReverseAnimation(animation),
              curve: const Interval(0.35, 1.0, curve: MD3Animations.standard),
            ),
            child: child!,
          );
        },
        child: child,
      ),
    );
  }
}

/// Shared Axis 转场实现
class SharedAxisTransition extends StatelessWidget {
  const SharedAxisTransition({
    Key? key,
    required this.animation,
    required this.secondaryAnimation,
    required this.transitionType,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final SharedAxisTransitionType transitionType;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) {
        return _buildSharedAxisTransition(
          animation: animation,
          isForward: true,
          child: child!,
        );
      },
      reverseBuilder: (context, animation, child) {
        return _buildSharedAxisTransition(
          animation: animation,
          isForward: false,
          child: child!,
        );
      },
      child: child,
    );
  }

  Widget _buildSharedAxisTransition({
    required Animation<double> animation,
    required bool isForward,
    required Widget child,
  }) {
    final Offset beginOffset;
    final Offset endOffset;

    switch (transitionType) {
      case SharedAxisTransitionType.horizontal:
        beginOffset = isForward ? const Offset(0.3, 0.0) : const Offset(-0.3, 0.0);
        endOffset = Offset.zero;
        break;
      case SharedAxisTransitionType.vertical:
        beginOffset = isForward ? const Offset(0.0, 0.3) : const Offset(0.0, -0.3);
        endOffset = Offset.zero;
        break;
      case SharedAxisTransitionType.scaled:
        // For scaled transitions, we use different logic
        return ScaleTransition(
          scale: Tween<double>(
            begin: isForward ? 0.8 : 1.2,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: MD3Animations.emphasized,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }

    return SlideTransition(
      position: Tween<Offset>(
        begin: beginOffset,
        end: endOffset,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: MD3Animations.emphasized,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

/// Shared Axis 转场类型
enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// 双重转场构建器
class DualTransitionBuilder extends StatelessWidget {
  const DualTransitionBuilder({
    Key? key,
    required this.animation,
    required this.forwardBuilder,
    required this.reverseBuilder,
    required this.child,
  }) : super(key: key);

  final Animation<double> animation;
  final AnimationTransitionBuilder forwardBuilder;
  final AnimationTransitionBuilder reverseBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        if (animation.status == AnimationStatus.reverse) {
          return reverseBuilder(context, animation, child!);
        } else {
          return forwardBuilder(context, animation, child!);
        }
      },
      child: child,
    );
  }
}

/// 动画转场构建器类型定义
typedef AnimationTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget? child,
);

/// MD3 微动画工具类
class MD3MicroAnimations {
  
  /// 创建悬停状态动画
  static AnimationController createHoverController(TickerProvider vsync) {
    return AnimationController(
      duration: MD3Animations.duration100,
      vsync: vsync,
    );
  }
  
  /// 创建按压状态动画
  static AnimationController createPressController(TickerProvider vsync) {
    return AnimationController(
      duration: MD3Animations.duration50,
      reverseDuration: MD3Animations.duration150,
      vsync: vsync,
    );
  }
  
  /// 创建缩放动画
  static Animation<double> createScaleAnimation(AnimationController controller, {
    double minScale = 0.95,
    double maxScale = 1.0,
  }) {
    return Tween<double>(
      begin: minScale,
      end: maxScale,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: MD3Animations.standard,
    ));
  }
  
  /// 创建阴影动画
  static Animation<double> createElevationAnimation(AnimationController controller, {
    double minElevation = 1.0,
    double maxElevation = 4.0,
  }) {
    return Tween<double>(
      begin: minElevation,
      end: maxElevation,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: MD3Animations.standard,
    ));
  }
}