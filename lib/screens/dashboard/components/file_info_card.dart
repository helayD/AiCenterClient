import 'package:admin/models/my_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 使用Tailwind配色系统
    final color = _getTailwindColor(info.title!);
    
    return B2BDataContainer(
      title: info.title!,
      value: info.totalStorage!,
      subtitle: "${info.numOfFiles} 个文件",
      icon: _getStorageIcon(info.title!),
      color: color,
      trend: _getTrendDirection(info.percentage ?? 0),
      trendValue: "${info.percentage ?? 0}%",
      onTap: () {
        debugPrint('Tapped on ${info.title}');
      },
    );
  }
  
  /// 根据存储类型获取Tailwind配色
  Color _getTailwindColor(String title) {
    switch (title.toLowerCase()) {
      case 'documents':
      case '文档':
        return TW.colorBlue[600]!;    // Tailwind蓝 - 文档数据
      case 'media':
      case '媒体文件':
        return TW.colorViolet[500]!;     // Tailwind紫 - 创意内容
      case 'others':
      case '其他':
        return TW.colorGreen[500]!;    // Tailwind绿 - 其他资源
      case 'unknown':
      case '未知':
        return TW.colorOrange[500]!;     // Tailwind橙 - 未知类型
      default:
        return TW.colorGreen[500]!;    // 默认绿色 - 统计信息
    }
  }
  
  /// 根据存储类型获取对应图标
  IconData _getStorageIcon(String title) {
    switch (title.toLowerCase()) {
      case 'documents':
      case '文档':
        return Icons.description_outlined;
      case 'media':
      case '媒体文件':
        return Icons.perm_media_outlined;
      case 'others':
      case '其他':
        return Icons.folder_outlined;
      case 'unknown':
      case '未知':
        return Icons.help_outline;
      default:
        return Icons.storage_outlined;
    }
  }
  
  /// 根据百分比获取趋势方向
  TrendDirection _getTrendDirection(int percentage) {
    if (percentage >= 80) {
      return TrendDirection.up;    // 使用量高
    } else if (percentage >= 50) {
      return TrendDirection.neutral; // 使用量中等
    } else {
      return TrendDirection.down;   // 使用量低
    }
  }
}

// 现代化B2B设计已取代传统MD3设计
// 新设计位于 ../../../components/b2b_modern_container.dart 中
