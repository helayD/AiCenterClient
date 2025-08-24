import 'package:admin/models/recent_file.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../utils/tailwind_flutter.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TW.colFlat(
      gap: TW.sp6,
      children: [
        // 扁平标题栏 - 无装饰
        TW.rowFlat(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "最近文件",
              style: TW.heading3(context),
            ),
            // 扁平查看全部按钮 - 仅使用文字色彩
            TextButton(
              onPressed: () {},
              child: Text(
                "查看全部",
                style: TW.textStyle(
                  context,
                  size: TW.textSm,
                  weight: TW.medium,
                  color: TW.blue600,
                ),
              ),
            ),
          ],
        ),
        
        // 扁平文件列表 - 完全无装饰
        TW.colFlat(
          gap: TW.sp4,
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
      child: TW.contentBox(
        padding: EdgeInsets.symmetric(
          vertical: TW.sp4,
          horizontal: TW.sp2,
        ),
        child: TW.rowFlat(
          gap: TW.sp4,
          children: [
            // 文件类型标识 - 仅使用文字，无图标装饰
            SizedBox(
              width: 60,
              child: Text(
                _getFileTypeLabel(file.title!),
                style: TW.textStyle(
                  context,
                  size: TW.textXs,
                  weight: TW.medium,
                  color: TW.text500(context),
                ),
              ),
            ),
            
            // 文件信息 - 纯文字布局
            Expanded(
              child: TW.colFlat(
                gap: TW.sp1,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    file.title!,
                    style: TW.textStyle(
                      context,
                      size: TW.textBase,
                      weight: TW.medium,
                      color: TW.text800(context),
                    ),
                  ),
                  Text(
                    file.date!,
                    style: TW.bodySmall(context),
                  ),
                ],
              ),
            ),
            
            // 文件大小 - 右对齐文字
            Text(
              file.size!,
              style: TW.textStyle(
                context,
                size: TW.textSm,
                weight: TW.medium,
                color: TW.text600(context),
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
