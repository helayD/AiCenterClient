import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../components/tailwind_components.dart';
import '../../../components/b2b_modern_container.dart';
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
        
        SizedBox(height: TW.space('6')),
        
        // 图表区域 - 保持原有图表
        Chart(),
        
        SizedBox(height: TW.space('6')),
        
        // 使用TailwindCard包装存储信息列表
        TailwindCard(
          padding: '6',
          showBorder: true,
          child: Column(
            children: [
              _buildStorageMetric(
                context,
                title: "文档文件",
                amount: "1.3GB",
                numOfFiles: 1328,
                trend: TrendDirection.up,
                change: "+5.2%",
              ),
              SizedBox(height: TW.space('4')),
              _buildStorageMetric(
                context,
                title: "媒体文件",
                amount: "15.3GB",
                numOfFiles: 1328,
                trend: TrendDirection.up,
                change: "+12.8%",
              ),
              SizedBox(height: TW.space('4')),
              _buildStorageMetric(
                context,
                title: "其他文件",
                amount: "1.3GB",
                numOfFiles: 1328,
                trend: TrendDirection.neutral,
                change: "0%",
              ),
              SizedBox(height: TW.space('4')),
              _buildStorageMetric(
                context,
                title: "未知文件",
                amount: "1.3GB",
                numOfFiles: 140,
                trend: TrendDirection.down,
                change: "-2.1%",
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// 使用B2BDataContainer构建存储指标
  Widget _buildStorageMetric(BuildContext context, {
    required String title,
    required String amount,
    required int numOfFiles,
    required TrendDirection trend,
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
    
    return B2BDataContainer(
      title: title,
      value: amount,
      trendValue: change,
      trend: trend,
      icon: getFileTypeIcon(title),
      subtitle: '$numOfFiles 个文件',
    );
  }
}
