import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../controllers/theme_controller.dart';
import '../constants.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(defaultPadding),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.palette_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: defaultPadding / 2),
                    Text(
                      AppLocalizations.of(context)!.themeMode,
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Theme options
              Padding(
                padding: EdgeInsets.all(defaultPadding / 2),
                child: Column(
                  children: AppThemeMode.values.map((mode) {
                    final isSelected = themeController.themeMode == mode;
                    return _ThemeOption(
                      mode: mode,
                      isSelected: isSelected,
                      onTap: () => themeController.setThemeMode(mode),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ThemeOption extends StatefulWidget {
  final AppThemeMode mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeOption({
    Key? key,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  _ThemeOptionState createState() => _ThemeOptionState();
}

class _ThemeOptionState extends State<_ThemeOption>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = context.read<ThemeController>();
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? primaryColor.withValues(alpha: 0.15)
                  : (_isHovered
                      ? Theme.of(context).hoverColor
                      : Colors.transparent),
              borderRadius: BorderRadius.circular(8),
              border: widget.isSelected
                  ? Border.all(color: primaryColor.withValues(alpha: 0.3))
                  : null,
            ),
            child: InkWell(
              onTap: widget.onTap,
              onHover: (hovered) {
                setState(() => _isHovered = hovered);
                if (hovered) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding / 2,
                  vertical: defaultPadding / 3,
                ),
                child: Row(
                  children: [
                    // Theme icon
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: widget.isSelected
                            ? primaryColor.withValues(alpha: 0.2)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(
                        themeController.getThemeIcon(widget.mode),
                        size: 16,
                        color: widget.isSelected
                            ? primaryColor
                            : Theme.of(context).iconTheme.color,
                      ),
                    ),
                    SizedBox(width: defaultPadding / 2),
                    
                    // Theme name
                    Expanded(
                      child: Text(
                        themeController.getThemeDisplayName(widget.mode, context),
                        style: TextStyle(
                          color: widget.isSelected
                              ? primaryColor
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: widget.isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    
                    // Selection indicator
                    if (widget.isSelected)
                      Icon(
                        Icons.check_circle,
                        color: primaryColor,
                        size: 16,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Quick theme toggle button for app bar
class QuickThemeToggle extends StatelessWidget {
  const QuickThemeToggle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeController>(
      builder: (context, themeController, child) {
        return IconButton(
          icon: Icon(
            themeController.isDarkMode
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          tooltip: themeController.isDarkMode
              ? AppLocalizations.of(context)!.switchToLightMode
              : AppLocalizations.of(context)!.switchToDarkMode,
          onPressed: () {
            final newMode = themeController.isDarkMode
                ? AppThemeMode.light
                : AppThemeMode.dark;
            themeController.setThemeMode(newMode);
          },
        );
      },
    );
  }
}