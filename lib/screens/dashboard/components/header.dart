import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';
import '../../../components/b2b_modern_container.dart';
import '../../../theme/tailwind_colors.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TechSpacing.lg,
        vertical: TechSpacing.md,
      ),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            Container(
              padding: EdgeInsets.all(TechSpacing.sm),
              decoration: BoxDecoration(
                color: TailwindColors.blue600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TechRadius.sm),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: TailwindColors.blue600,
                ),
                onPressed: context.read<MenuAppController>().controlMenu,
              ),
            ),
          
          if (!Responsive.isMobile(context)) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TechSpacing.lg,
                vertical: TechSpacing.sm,
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(TechSpacing.sm),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TailwindColors.blue600, TailwindColors.cyan500],
                      ),
                      borderRadius: BorderRadius.circular(TechRadius.sm),
                    ),
                    child: Icon(
                      Icons.dashboard_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: TechSpacing.md),
                  Text(
                    "企业仪表板",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
          ],
          
          Expanded(child: SearchField()),
          ProfileCard()
        ],
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: EdgeInsets.only(left: TechSpacing.lg),
      child: B2BModernContainer(
        statusColor: TailwindColors.blue600,
        showStatusBar: false,
        padding: EdgeInsets.symmetric(
          horizontal: TechSpacing.lg,
          vertical: TechSpacing.md,
        ),
        elevation: 1.0,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 现代化头像容器
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TailwindColors.blue600, TailwindColors.cyan500],
                      ),
                borderRadius: BorderRadius.circular(TechRadius.xl),
                border: Border.all(
                  color: TailwindColors.blue600.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(TechRadius.xl),
                child: Image.asset(
                  "assets/images/profile_pic.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            if (!Responsive.isMobile(context)) ...[ 
              SizedBox(width: TechSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Angelina Jolie",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.1,
                    ),
                  ),
                  Text(
                    "管理员",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              SizedBox(width: TechSpacing.sm),
            ],
            
            Container(
              padding: EdgeInsets.all(TechSpacing.xs),
              decoration: BoxDecoration(
                color: TailwindColors.blue600.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TechRadius.xs),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: TailwindColors.blue600,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      child: TextField(
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: "搜索仪表板...",
          hintStyle: TextStyle(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 14,
          ),
          fillColor: isDark 
              ? TailwindColors.slate800.withOpacity(0.3)
              : TailwindColors.slate100.withOpacity(0.5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: TechSpacing.lg,
            vertical: TechSpacing.md,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: TailwindColors.blue600.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TechRadius.md)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.dividerColor.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TechRadius.md)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: TailwindColors.blue600,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TechRadius.md)),
          ),
          prefixIcon: Container(
            margin: EdgeInsets.only(
              left: TechSpacing.md,
              right: TechSpacing.sm,
            ),
            child: Icon(
              Icons.search_rounded,
              color: theme.colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          suffixIcon: InkWell(
            onTap: () {
              debugPrint('Search button tapped');
            },
            borderRadius: BorderRadius.circular(TechRadius.sm),
            child: Container(
              margin: EdgeInsets.all(TechSpacing.xs),
              padding: EdgeInsets.all(TechSpacing.sm),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TailwindColors.blue600, TailwindColors.cyan500],
                      ),
                borderRadius: BorderRadius.all(Radius.circular(TechRadius.sm)),
                boxShadow: [
                  BoxShadow(
                    color: TailwindColors.blue600.withOpacity(0.25),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
