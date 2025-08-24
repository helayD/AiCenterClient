import 'package:flutter/material.dart';

/// 标准Tailwind CSS色彩系统
/// 基于Tailwind CSS官方OKLCH色彩数值，确保完全符合设计规范
/// 
/// 特性:
/// - 精确的OKLCH色彩空间数值
/// - 完整的50-950色彩层级（11个层级）
/// - 感知均匀的色彩渐变
/// - 支持可访问性标准（4.5:1对比度）
/// 
/// 参考: https://tailwindcss.com/docs/colors

class TailwindColors {
  const TailwindColors();

  // ============================================================================
  // Slate - 冷色调灰色系 (专业、技术感)
  // ============================================================================
  static const Color slate50 = Color(0xFFF8FAFC);   // oklch(0.984 0.003 247.858)
  static const Color slate100 = Color(0xFFF1F5F9);  // oklch(0.968 0.007 247.896)
  static const Color slate200 = Color(0xFFE2E8F0);  // oklch(0.929 0.013 255.508)
  static const Color slate300 = Color(0xFFCBD5E1);  // oklch(0.869 0.022 252.894)
  static const Color slate400 = Color(0xFF94A3B8);  // oklch(0.704 0.04 256.788)
  static const Color slate500 = Color(0xFF64748B);  // oklch(0.554 0.046 257.417)
  static const Color slate600 = Color(0xFF475569);  // oklch(0.446 0.043 257.281)
  static const Color slate700 = Color(0xFF334155);  // oklch(0.372 0.044 257.287)
  static const Color slate800 = Color(0xFF1E293B);  // oklch(0.279 0.041 260.031)
  static const Color slate900 = Color(0xFF0F172A);  // oklch(0.208 0.042 265.755)
  static const Color slate950 = Color(0xFF020617);  // oklch(0.129 0.042 264.695)

  // ============================================================================
  // Gray - 中性灰色系 (平衡、通用)
  // ============================================================================
  static const Color gray50 = Color(0xFFF9FAFB);   // oklch(0.985 0.002 247.839)
  static const Color gray100 = Color(0xFFF3F4F6);  // oklch(0.967 0.003 264.542)
  static const Color gray200 = Color(0xFFE5E7EB);  // oklch(0.928 0.006 264.531)
  static const Color gray300 = Color(0xFFD1D5DB);  // oklch(0.872 0.01 258.338)
  static const Color gray400 = Color(0xFF9CA3AF);  // oklch(0.707 0.022 261.325)
  static const Color gray500 = Color(0xFF6B7280);  // oklch(0.556 0.027 264.364)
  static const Color gray600 = Color(0xFF4B5563);  // oklch(0.446 0.03 256.802)
  static const Color gray700 = Color(0xFF374151);  // oklch(0.373 0.034 259.733)
  static const Color gray800 = Color(0xFF1F2937);  // oklch(0.278 0.033 256.848)
  static const Color gray900 = Color(0xFF111827);  // oklch(0.21 0.034 264.665)
  static const Color gray950 = Color(0xFF030712);  // oklch(0.13 0.028 261.692)

  // ============================================================================
  // Zinc - 现代中性色系 (简约、现代)
  // ============================================================================
  static const Color zinc50 = Color(0xFFFAFAFA);   // oklch(0.985 0 0)
  static const Color zinc100 = Color(0xFFF4F4F5);  // oklch(0.967 0.001 286.375)
  static const Color zinc200 = Color(0xFFE4E4E7);  // oklch(0.92 0.004 286.32)
  static const Color zinc300 = Color(0xFFD4D4D8);  // oklch(0.871 0.006 286.286)
  static const Color zinc400 = Color(0xFFA1A1AA);  // oklch(0.705 0.015 286.067)
  static const Color zinc500 = Color(0xFF71717A);  // oklch(0.552 0.016 285.938)
  static const Color zinc600 = Color(0xFF52525B);  // oklch(0.442 0.017 285.786)
  static const Color zinc700 = Color(0xFF3F3F46);  // oklch(0.37 0.013 285.805)
  static const Color zinc800 = Color(0xFF27272A);  // oklch(0.274 0.006 286.033)
  static const Color zinc900 = Color(0xFF18181B);  // oklch(0.21 0.006 285.885)
  static const Color zinc950 = Color(0xFF09090B);  // oklch(0.141 0.005 285.823)

  // ============================================================================
  // Blue - 主要品牌色系 (可信、专业、科技)
  // ============================================================================
  static const Color blue50 = Color(0xFFEFF6FF);   // oklch(0.97 0.014 254.604)
  static const Color blue100 = Color(0xFFDBEAFE);  // oklch(0.932 0.032 255.585)
  static const Color blue200 = Color(0xFFBFDBFE);  // oklch(0.882 0.059 254.128)
  static const Color blue300 = Color(0xFF93C5FD);  // oklch(0.809 0.105 251.813)
  static const Color blue400 = Color(0xFF60A5FA);  // oklch(0.707 0.165 254.624)
  static const Color blue500 = Color(0xFF3B82F6);  // oklch(0.623 0.214 259.815)
  static const Color blue600 = Color(0xFF2563EB);  // oklch(0.546 0.245 262.881)
  static const Color blue700 = Color(0xFF1D4ED8);  // oklch(0.488 0.243 264.376)
  static const Color blue800 = Color(0xFF1E40AF);  // oklch(0.424 0.199 265.638)
  static const Color blue900 = Color(0xFF1E3A8A);  // oklch(0.379 0.146 265.522)
  static const Color blue950 = Color(0xFF172554);  // oklch(0.282 0.091 267.935)

  // ============================================================================
  // Green - 成功状态色系 (成功、安全、增长)
  // ============================================================================
  static const Color green50 = Color(0xFFF0FDF4);   // oklch(0.982 0.018 155.826)
  static const Color green100 = Color(0xFFDCFCE7);  // oklch(0.962 0.044 156.743)
  static const Color green200 = Color(0xFFBBF7D0);  // oklch(0.925 0.084 155.995)
  static const Color green300 = Color(0xFF86EFAC);  // oklch(0.871 0.15 154.449)
  static const Color green400 = Color(0xFF4ADE80);  // oklch(0.792 0.209 151.711)
  static const Color green500 = Color(0xFF22C55E);  // oklch(0.723 0.219 149.579)
  static const Color green600 = Color(0xFF16A34A);  // oklch(0.627 0.194 149.214)
  static const Color green700 = Color(0xFF15803D);  // oklch(0.527 0.154 150.069)
  static const Color green800 = Color(0xFF166534);  // oklch(0.448 0.119 151.328)
  static const Color green900 = Color(0xFF14532D);  // oklch(0.393 0.095 152.535)
  static const Color green950 = Color(0xFF052E16);  // oklch(0.266 0.065 152.934)

  // ============================================================================
  // Red - 错误状态色系 (危险、错误、警告)
  // ============================================================================
  static const Color red50 = Color(0xFFFEF2F2);    // oklch(0.971 0.013 17.38)
  static const Color red100 = Color(0xFFFEE2E2);   // oklch(0.936 0.032 17.717)
  static const Color red200 = Color(0xFFFECACA);   // oklch(0.885 0.062 18.334)
  static const Color red300 = Color(0xFFFCA5A5);   // oklch(0.808 0.114 19.571)
  static const Color red400 = Color(0xFFF87171);   // oklch(0.704 0.191 22.216)
  static const Color red500 = Color(0xFFEF4444);   // oklch(0.637 0.237 25.331)
  static const Color red600 = Color(0xFFDC2626);   // oklch(0.577 0.245 27.325)
  static const Color red700 = Color(0xFFB91C1C);   // oklch(0.505 0.213 27.518)
  static const Color red800 = Color(0xFF991B1B);   // oklch(0.444 0.177 26.899)
  static const Color red900 = Color(0xFF7F1D1D);   // oklch(0.396 0.141 25.723)
  static const Color red950 = Color(0xFF450A0A);   // oklch(0.258 0.092 26.042)

  // ============================================================================
  // Orange/Amber - 警告状态色系 (注意、警告、待处理)
  // ============================================================================
  static const Color orange50 = Color(0xFFFFF7ED);  // oklch(0.98 0.016 73.684)
  static const Color orange100 = Color(0xFFFFEDD5); // oklch(0.954 0.038 75.164)
  static const Color orange200 = Color(0xFFFED7AA); // oklch(0.901 0.076 70.697)
  static const Color orange300 = Color(0xFFDDDFE4); // oklch(0.837 0.128 66.29)
  static const Color orange400 = Color(0xFFFB923C); // oklch(0.75 0.183 55.934)
  static const Color orange500 = Color(0xFFF97316); // oklch(0.705 0.213 47.604)
  static const Color orange600 = Color(0xFFEA580C); // oklch(0.646 0.222 41.116)
  static const Color orange700 = Color(0xFFC2410C); // oklch(0.553 0.195 38.402)
  static const Color orange800 = Color(0xFF9A3412); // oklch(0.47 0.157 37.304)
  static const Color orange900 = Color(0xFF7C2D12); // oklch(0.408 0.123 38.172)
  static const Color orange950 = Color(0xFF431407); // oklch(0.266 0.079 36.259)

  // ============================================================================
  // Cyan - 信息状态色系 (信息、提示、辅助)
  // ============================================================================
  static const Color cyan50 = Color(0xFFECFEFF);   // oklch(0.984 0.019 200.873)
  static const Color cyan100 = Color(0xFFCFFAFE);  // oklch(0.956 0.045 203.388)
  static const Color cyan200 = Color(0xFFA5F3FC);  // oklch(0.917 0.08 205.041)
  static const Color cyan300 = Color(0xFF67E8F9);  // oklch(0.865 0.127 207.078)
  static const Color cyan400 = Color(0xFF22D3EE);  // oklch(0.789 0.154 211.53)
  static const Color cyan500 = Color(0xFF06B6D4);  // oklch(0.715 0.143 215.221)
  static const Color cyan600 = Color(0xFF0891B2);  // oklch(0.609 0.126 221.723)
  static const Color cyan700 = Color(0xFF0E7490);  // oklch(0.52 0.105 223.128)
  static const Color cyan800 = Color(0xFF155E75);  // oklch(0.45 0.085 224.283)
  static const Color cyan900 = Color(0xFF164E63);  // oklch(0.398 0.07 227.392)
  static const Color cyan950 = Color(0xFF083344);  // oklch(0.302 0.056 229.695)

  // ============================================================================
  // 基础色彩
  // ============================================================================
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ============================================================================
  // 透明度变体 (用于悬停、禁用等状态)
  // ============================================================================
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}

/// Tailwind CSS语义颜色映射
/// 将标准颜色映射到语义用途，便于主题切换和维护
class TailwindSemanticColors {
  const TailwindSemanticColors();

  // ============================================================================
  // 明亮主题语义映射
  // ============================================================================
  
  /// 主要品牌色 - 用于主要交互元素
  static const Color primary = TailwindColors.blue600;
  static const Color primaryHover = TailwindColors.blue700;
  static const Color primaryActive = TailwindColors.blue800;
  static const Color primaryLight = TailwindColors.blue100;
  
  /// 成功状态色 - 用于成功提示、完成状态
  static const Color success = TailwindColors.green500;
  static const Color successHover = TailwindColors.green600;
  static const Color successLight = TailwindColors.green100;
  
  /// 警告状态色 - 用于警告提示、注意状态
  static const Color warning = TailwindColors.orange500;
  static const Color warningHover = TailwindColors.orange600;
  static const Color warningLight = TailwindColors.orange100;
  
  /// 错误状态色 - 用于错误提示、危险操作
  static const Color error = TailwindColors.red500;
  static const Color errorHover = TailwindColors.red600;
  static const Color errorLight = TailwindColors.red100;
  
  /// 信息状态色 - 用于信息提示、帮助说明
  static const Color info = TailwindColors.cyan500;
  static const Color infoHover = TailwindColors.cyan600;
  static const Color infoLight = TailwindColors.cyan100;

  // ============================================================================
  // 中性色语义映射 (明亮主题)
  // ============================================================================
  
  /// 背景色系
  static const Color background = TailwindColors.white;
  static const Color surface = TailwindColors.gray50;
  static const Color surfaceVariant = TailwindColors.gray100;
  static const Color surfaceHover = TailwindColors.gray200;
  
  /// 文字色系
  static const Color onBackground = TailwindColors.gray900;  // 主要文字
  static const Color onSurface = TailwindColors.gray800;     // 表面文字
  static const Color onSurfaceVariant = TailwindColors.gray600;  // 次要文字
  static const Color onSurfaceDisabled = TailwindColors.gray400; // 禁用文字
  
  /// 边框色系  
  static const Color border = TailwindColors.gray200;
  static const Color borderVariant = TailwindColors.gray300;
  static const Color borderHover = TailwindColors.gray400;

  // ============================================================================
  // 暗色主题语义映射
  // ============================================================================
  
  /// 暗色主题 - 主要色彩 (使用较亮的变体以在暗背景上显眼)
  static const Color darkPrimary = TailwindColors.blue400;
  static const Color darkPrimaryHover = TailwindColors.blue300;
  static const Color darkSuccess = TailwindColors.green400;
  static const Color darkWarning = TailwindColors.orange400;
  static const Color darkError = TailwindColors.red400;
  static const Color darkInfo = TailwindColors.cyan400;
  
  /// 暗色主题 - 背景色系
  static const Color darkBackground = TailwindColors.gray950;
  static const Color darkSurface = TailwindColors.gray900;
  static const Color darkSurfaceVariant = TailwindColors.gray800;
  static const Color darkSurfaceHover = TailwindColors.gray700;
  
  /// 暗色主题 - 文字色系
  static const Color darkOnBackground = TailwindColors.gray50;
  static const Color darkOnSurface = TailwindColors.gray100;
  static const Color darkOnSurfaceVariant = TailwindColors.gray400;
  static const Color darkOnSurfaceDisabled = TailwindColors.gray600;
  
  /// 暗色主题 - 边框色系
  static const Color darkBorder = TailwindColors.gray800;
  static const Color darkBorderVariant = TailwindColors.gray700;
  static const Color darkBorderHover = TailwindColors.gray600;
}


@Deprecated('使用 TailwindSemanticColors.warning 替代')
const warningColor = TailwindColors.orange500;

@Deprecated('使用 TailwindSemanticColors.error 替代')
const errorColor = TailwindColors.red500;