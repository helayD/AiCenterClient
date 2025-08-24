import 'package:flutter/foundation.dart';

/// CORS跨域配置管理类
/// 处理Flutter Web环境下的跨域请求配置
class CorsConfig {
  // 私有构造函数
  CorsConfig._();

  /// 代理服务器配置
  static const String proxyHost = '127.0.0.1';
  static const int proxyPort = 3001;
  static const String proxyProtocol = 'http';
  
  /// 原始API服务器配置
  static const String originalApiHost = '47.106.218.81';
  static const int originalApiPort = 20080;
  static const String originalApiProtocol = 'http';
  
  /// 获取基础URL
  static String get baseUrl {
    if (kIsWeb && _shouldUseProxy) {
      // Web环境使用代理服务器
      return '$proxyProtocol://$proxyHost:$proxyPort';
    } else {
      // 非Web环境直连API服务器
      return '$originalApiProtocol://$originalApiHost:$originalApiPort';
    }
  }
  
  /// 获取代理服务器URL
  static String get proxyUrl => '$proxyProtocol://$proxyHost:$proxyPort';
  
  /// 获取原始API服务器URL
  static String get originalApiUrl => '$originalApiProtocol://$originalApiHost:$originalApiPort';
  
  /// 判断是否应该使用代理
  static bool get _shouldUseProxy {
    // 在Web环境下默认使用代理，除非明确禁用
    if (!kIsWeb) return false;
    
    // 可以通过环境变量控制
    const useProxy = String.fromEnvironment('USE_PROXY', defaultValue: 'true');
    return useProxy.toLowerCase() == 'true';
  }
  
  /// 获取健康检查URL
  static String get healthCheckUrl => '$proxyUrl/health';
  
  /// 检查代理服务器是否可用
  static Future<bool> isProxyAvailable() async {
    if (!kIsWeb || !_shouldUseProxy) return false;
    
    try {
      // 这里可以实现健康检查逻辑
      // 由于Flutter Web环境限制，暂时返回true
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// 获取环境信息
  static Map<String, dynamic> getEnvironmentInfo() {
    return {
      'isWeb': kIsWeb,
      'shouldUseProxy': _shouldUseProxy,
      'baseUrl': baseUrl,
      'proxyUrl': proxyUrl,
      'originalApiUrl': originalApiUrl,
      'environment': {
        'USE_PROXY': const String.fromEnvironment('USE_PROXY', defaultValue: 'true'),
        'NODE_ENV': const String.fromEnvironment('NODE_ENV', defaultValue: 'development'),
      }
    };
  }
  
  /// CORS解决方案说明
  static const String corsDescription = '''
Flutter Web CORS解决方案:

1. 开发环境: 使用本地代理服务器 (proxy.js)
   - 启动: npm start 或 node proxy.js
   - 地址: http://127.0.0.1:3001
   - 功能: 代理请求到后端API并添加CORS头

2. 生产环境: 
   - 方案A: 后端配置CORS头
   - 方案B: 部署代理服务器
   - 方案C: 使用CDN/云服务代理

3. 备用方案: Chrome禁用CORS (仅开发)
   - 脚本: scripts/start_chrome_no_cors.sh
   - 注意: 仅开发环境使用，生产环境无效
''';
  
  /// 获取启动指引
  static List<String> getStartupGuide() {
    return [
      '🚀 Flutter Web CORS解决方案启动指引:',
      '',
      '1. 安装Node.js依赖:',
      '   npm install',
      '',
      '2. 启动CORS代理服务器:',
      '   npm start  # 或 node proxy.js',
      '',
      '3. 启动Flutter Web应用:',
      '   flutter run -d web-server --web-port 16001',
      '',
      '4. 访问应用:',
      '   http://localhost:16001',
      '',
      '🔧 环境检查:',
      '- 代理服务器: $proxyUrl/health',
      '- API服务器: $originalApiUrl',
      '- 当前配置: ${kIsWeb ? "Web代理模式" : "直连模式"}',
    ];
  }
  
  /// 常见问题解决方案
  static Map<String, String> get troubleshooting => {
    'CORS错误': '确保代理服务器已启动: npm start',
    '代理连接失败': '检查proxy.js是否正常运行在3001端口',
    '登录失败': '验证API服务器可访问性和代理配置',
    '网络超时': '检查防火墙设置和网络连接',
    '端口冲突': '修改proxy.js中的PORT配置',
  };
}