import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';
import '../../../components/b2b_modern_container.dart';
import '../../../theme/tailwind_colors.dart';

class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.svgSrc,
    required this.amountOfFiles,
    required this.numOfFiles,
    this.accentColor,  // 新增：鲜明商业颜色参数
  }) : super(key: key);

  final String title, svgSrc, amountOfFiles;
  final int numOfFiles;
  final Color? accentColor;  // 可选的鲜明颜色

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 使用传入的Tailwind颜色，或回退到标准配色方案
    final color = accentColor ?? _getTailwindColor(title);
    
    return B2BModernContainer(
      statusColor: color,
      padding: EdgeInsets.all(TechSpacing.lg),
      child: Row(
        children: [
          // 现代化文件图标容器
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.15),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(TechRadius.sm),
              border: Border.all(
                color: color.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Icon(
              _getStorageIcon(title),
              size: 24,
              color: color,
            ),
          ),
          
          SizedBox(width: TechSpacing.lg),
          
          // 存储信息展示区域
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: TechSpacing.xs),
                Text(
                  amountOfFiles,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: TechSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.folder_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: TechSpacing.xs),
                    Text(
                      '$numOfFiles 个文件',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // 状态指示器
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: TechSpacing.sm,
              vertical: TechSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(TechRadius.sm),
            ),
            child: Icon(
              Icons.trending_up_rounded,
              size: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// 根据存储类型获取Tailwind配色
  Color _getTailwindColor(String title) {
    switch (title.toLowerCase()) {
      case 'documents':
      case '文档文件':
      case 'documents files':
        return TailwindColors.blue600;    // Tailwind蓝 - 文档数据
      case 'media':
      case '媒体文件':
      case 'media files':
        return TailwindColors.violet500;     // Tailwind紫 - 创意内容
      case 'other':
      case '其他文件':
      case 'other files':
        return TailwindColors.green500;    // Tailwind绿 - 其他资源
      case 'unknown':
      case '未知':
        return TailwindColors.orange500;     // Tailwind橙 - 未知文件
      default:
        return TailwindColors.blue600;    // 默认蓝色
    }
  }
  
  /// 根据存储类型获取对应图标
  IconData _getStorageIcon(String title) {
    switch (title.toLowerCase()) {
      case 'documents':
      case '文档文件':
      case 'documents files':
        return Icons.description_outlined;
      case 'media':
      case '媒体文件':
      case 'media files':
        return Icons.perm_media_outlined;
      case 'other':
      case '其他文件':
      case 'other files':
        return Icons.folder_outlined;
      case 'unknown':
      case '未知':
        return Icons.help_outline;
      default:
        return Icons.storage_outlined;
    }
  }
}
