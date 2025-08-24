import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../theme/tech_theme_system.dart';
import '../../../theme/tailwind_colors.dart';
import '../../../components/tech_components.dart';
import 'chart.dart';

class StorageDetails extends StatelessWidget {
  const StorageDetails({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 使用新设计系统的标题
        Text(
          "存储分析",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        
        SizedBox(height: TechSpacing.lg),
        
        // 图表区域 - 保持原有图表
        Chart(),
        
        SizedBox(height: TechSpacing.lg),
        
        // 使用TechCard包装存储信息列表
        TechCard(
          padding: EdgeInsets.all(TechSpacing.lg),
          showBorder: true,
          child: Column(
            children: [
              _buildStorageMetric(
                context,
                title: "文档文件",
                amount: "1.3GB",
                numOfFiles: 1328,
                trend: TrendType.up,
                change: "+5.2%",
              ),
              SizedBox(height: TechSpacing.md),
              _buildStorageMetric(
                context,
                title: "媒体文件",
                amount: "15.3GB",
                numOfFiles: 1328,
                trend: TrendType.up,
                change: "+12.8%",
              ),
              SizedBox(height: TechSpacing.md),
              _buildStorageMetric(
                context,
                title: "其他文件",
                amount: "1.3GB",
                numOfFiles: 1328,
                trend: TrendType.neutral,
                change: "0%",
              ),
              SizedBox(height: TechSpacing.md),
              _buildStorageMetric(
                context,
                title: "未知文件",
                amount: "1.3GB",
                numOfFiles: 140,
                trend: TrendType.down,
                change: "-2.1%",
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// 使用MetricDisplay构建存储指标
  Widget _buildStorageMetric(BuildContext context, {
    required String title,
    required String amount,
    required int numOfFiles,
    required TrendType trend,
    required String change,
  }) {
    // 根据文件类型选择图标
    IconData getFileTypeIcon(String title) {
      switch (title) {
        case "文档文件":
          return Icons.description;
        case "媒体文件":
          return Icons.perm_media;
        case "其他文件":
          return Icons.folder;
        case "未知文件":
          return Icons.help_outline;
        default:
          return Icons.storage;
      }
    }
    
    return MetricDisplay(
      title: title,
      value: amount,
      change: change,
      trend: trend,
      icon: getFileTypeIcon(title),
      subtitle: '$numOfFiles 个文件',
    );
  }
}
