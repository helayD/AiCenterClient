import 'package:flutter/material.dart';
import 'package:admin/models/my_files.dart';
import '../../../constants.dart';
import '../../../components/tailwind_components.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 使用新设计系统的间距
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "我的文件",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            // 使用TailwindButton替代TextButton
            TailwindButton(
              variant: 'primary',
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 18),
                  SizedBox(width: TW.space('1')),
                  Text("添加新文件"),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: TW.space('6')),
        _buildTechGrid(context),
      ],
    );
  }

  /// 使用新设计系统的响应式网格
  Widget _buildTechGrid(BuildContext context) {
    // 使用响应式布局计算列数
    final int cols = _getResponsiveCols(context);
    final double gap = TW.space('4');
    
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: demoMyFiles.map((fileInfo) => 
        SizedBox(
          width: cols == 1 
            ? double.infinity 
            : (MediaQuery.of(context).size.width - gap * (cols - 1) - TW.space('6') * 2) / cols,
          child: TechFileCard(
            title: fileInfo.title!,
            totalStorage: fileInfo.totalStorage!,
            numOfFiles: fileInfo.numOfFiles!,
            svgSrc: fileInfo.svgSrc!,
          ),
        ),
      ).toList(),
    );
  }
  
  /// 响应式列数计算
  int _getResponsiveCols(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1024) return 4;  // 桌面端
    if (width >= 768) return 3;   // 平板端
    return 1;                     // 移动端
  }
}

/// 使用新设计系统的文件卡片
class TechFileCard extends StatelessWidget {
  final String title;
  final String totalStorage;
  final int numOfFiles;
  final String svgSrc;
  
  const TechFileCard({
    Key? key,
    required this.title,
    required this.totalStorage,
    required this.numOfFiles,
    required this.svgSrc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TailwindCard(
      padding: '6',
      showBorder: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 文件类型标题
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: TW.space('4')),
          
          // 文件数量信息
          Text(
            '$numOfFiles 个文件',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          SizedBox(height: TW.space("2")),
          
          // 存储大小 - 突出显示
          Text(
            totalStorage,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}