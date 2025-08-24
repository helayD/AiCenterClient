import 'package:admin/controllers/menu_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: TW.space('6'),
        vertical: TW.space('4'),
      ),
      child: Row(
        children: [
          if (!Responsive.isDesktop(context))
            Container(
              padding: EdgeInsets.all(TW.space('2')),
              decoration: BoxDecoration(
                color: TW.colorBlue[600]!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TW.radius('sm')),
              ),
              child: IconButton(
                icon: Icon(
                  Icons.menu_rounded,
                  color: TW.colorBlue[600]!,
                ),
                onPressed: context.read<MenuAppController>().controlMenu,
              ),
            ),
          
          if (!Responsive.isMobile(context)) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: TW.space('6'),
                vertical: TW.space('2'),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(TW.space('2')),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [TW.colorBlue[600]!, TW.colorCyan[500]!],
                      ),
                      borderRadius: BorderRadius.circular(TW.radius('sm')),
                    ),
                    child: Icon(
                      Icons.dashboard_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: TW.space('4')),
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
      margin: EdgeInsets.only(left: TW.space('6')),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: TW.space('6'),
          vertical: TW.space('4'),
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(TW.radius('lg')),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
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
                  colors: [TW.colorBlue[600]!, TW.colorCyan[500]!],
                ),
                borderRadius: BorderRadius.circular(TW.radius('xl')),
                border: Border.all(
                  color: TW.colorBlue[600]!.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(TW.radius('xl')),
                child: Image.asset(
                  "assets/images/profile_pic.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            
            if (!Responsive.isMobile(context)) ...[ 
              SizedBox(width: TW.space('4')),
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
              SizedBox(width: TW.space('2')),
            ],
            
            Container(
              padding: EdgeInsets.all(TW.space('1')),
              decoration: BoxDecoration(
                color: TW.colorBlue[600]!.withOpacity(0.1),
                borderRadius: BorderRadius.circular(TW.radius('xs')),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: TW.colorBlue[600]!,
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
              ? TW.colorSlate[800]!.withOpacity(0.3)
              : TW.colorSlate[100]!.withOpacity(0.5),
          filled: true,
          contentPadding: EdgeInsets.symmetric(
            horizontal: TW.space('6'),
            vertical: TW.space('4'),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: TW.colorBlue[600]!.withOpacity(0.2),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TW.radius('md'))),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: theme.dividerColor.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TW.radius('md'))),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: TW.colorBlue[600]!,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(TW.radius('md'))),
          ),
          prefixIcon: Container(
            margin: EdgeInsets.only(
              left: TW.space('4'),
              right: TW.space('2'),
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
            borderRadius: BorderRadius.circular(TW.radius('sm')),
            child: Container(
              margin: EdgeInsets.all(TW.space('1')),
              padding: EdgeInsets.all(TW.space('2')),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [TW.colorBlue[600]!, TW.colorCyan[500]!],
                ),
                borderRadius: BorderRadius.all(Radius.circular(TW.radius('sm'))),
                boxShadow: [
                  BoxShadow(
                    color: TW.colorBlue[600]!.withOpacity(0.25),
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
