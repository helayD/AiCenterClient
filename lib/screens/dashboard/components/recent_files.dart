import 'package:admin/models/recent_file.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: TW.space('6'),
      children: [
        // 扁平标题栏 - 无装饰
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "最近文件",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // 扁平查看全部按钮 - 仅使用文字色彩
            TextButton(
              onPressed: () {},
              child: Text(
                "查看全部",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        
        // 扁平文件列表 - 完全无装饰
        Column(
          spacing: TW.space('4'),
          children: demoRecentFiles
              .take(5)
              .map((file) => _buildFlatFileItem(context, file))
              .toList(),
        ),
      ],
    );
  }
  
  /// 构建完全扁平的文件列表项 - 无任何装饰
  Widget _buildFlatFileItem(BuildContext context, RecentFile file) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: TW.space('4'),
          horizontal: TW.space('2'),
        ),
        child: Row(
          spacing: TW.space('4'),
          children: [
            // 文件类型标识 - 仅使用文字，无图标装饰
            SizedBox(
              width: 60,
              child: Text(
                _getFileTypeLabel(file.title!),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            
            // 文件信息 - 纯文字布局
            Expanded(
              child: Column(
                spacing: TW.space('1'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.title!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    file.date!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            
            // 文件大小 - 右对齐文字
            Text(
              file.size!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// 根据文件类型获取简短标识文字 - 替代视觉图标
  String _getFileTypeLabel(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return 'PDF';
      case 'doc':
      case 'docx':
        return 'DOC';
      case 'xlsx':
      case 'xls':
        return 'XLS';
      case 'csv':
        return 'CSV';
      case 'ppt':
      case 'pptx':
        return 'PPT';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return 'IMG';
      default:
        return 'FILE';
    }
  }
  
}

// 传统装饰性设计已被完全扁平化设计取代
// 现在使用Tailwind风格的纯内容布局，参见 _buildFlatFileItem 方法
