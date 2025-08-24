const http = require('http');
const { createProxyMiddleware } = require('http-proxy-middleware');
const express = require('express');
const cors = require('cors');

const app = express();

// 生产级CORS配置
const corsOptions = {
  origin: function (origin, callback) {
    // 允许的域名列表
    const allowedOrigins = [
      'http://localhost:16001',
      'http://localhost:16000',
      'http://127.0.0.1:16001',
      'http://127.0.0.1:16000',
      'https://your-production-domain.com' // 替换为实际生产域名
    ];
    
    // 开发环境允许localhost
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      console.warn(`🚨 CORS blocked origin: ${origin}`);
      callback(new Error('Not allowed by CORS'));
    }
  },
  methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
  allowedHeaders: [
    'Origin',
    'X-Requested-With', 
    'Content-Type', 
    'Accept', 
    'Authorization',
    'Cache-Control',
    'Pragma'
  ],
  credentials: true, // 支持Cookie
  optionsSuccessStatus: 200
};

// 请求日志中间件
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`📝 [${timestamp}] ${req.method} ${req.url} - Origin: ${req.headers.origin || 'None'}`);
  next();
});

// 健康检查端点
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    proxy_target: 'http://47.106.218.81:20080'
  });
});

// 使用正确的v3语法 - 事件在on对象中定义
const apiProxy = createProxyMiddleware({
  target: 'http://47.106.218.81:20080',
  changeOrigin: true,
  timeout: 30000,
  pathRewrite: {
    '^/': '/api/'
  },
  on: {
    proxyReq: (proxyReq, req, res) => {
      console.log(`🔄 Proxying ${req.method} ${req.url} -> ${proxyReq.path}`);
    },
    proxyRes: (proxyRes, req, res) => {
      const origin = req.headers.origin;
      const allowedOrigins = [
        'http://localhost:16001',
        'http://localhost:16000',
        'http://127.0.0.1:16001', 
        'http://127.0.0.1:16000'
      ];
      
      // 完全删除后端的所有CORS头部
      Object.keys(proxyRes.headers).forEach(key => {
        if (key.toLowerCase().startsWith('access-control-')) {
          delete proxyRes.headers[key];
          console.log(`🧹 Removed backend CORS header: ${key}`);
        }
      });
      
      // 设置我们自己的CORS头部
      if (!origin || allowedOrigins.includes(origin)) {
        proxyRes.headers['access-control-allow-origin'] = origin || 'http://localhost:16001';
        proxyRes.headers['access-control-allow-methods'] = 'GET, POST, PUT, DELETE, OPTIONS';
        proxyRes.headers['access-control-allow-headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control, Pragma';
        proxyRes.headers['access-control-allow-credentials'] = 'true';
        console.log(`✅ Set clean CORS headers for origin: ${origin || 'default'}`);
      }
    },
    error: (err, req, res) => {
      console.error(`❌ Proxy Error for ${req.url}:`, err.message);
      res.status(500).json({
        error: 'Proxy Error',
        message: 'Unable to connect to backend server',
        timestamp: new Date().toISOString()
      });
    }
  }
});

// OPTIONS预检处理中间件
app.use('/api', (req, res, next) => {
  if (req.method === 'OPTIONS') {
    const origin = req.headers.origin;
    const allowedOrigins = [
      'http://localhost:16001',
      'http://localhost:16000',
      'http://127.0.0.1:16001',
      'http://127.0.0.1:16000'
    ];
    
    if (!origin || allowedOrigins.includes(origin)) {
      res.setHeader('Access-Control-Allow-Origin', origin || 'http://localhost:16001');
      res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
      res.setHeader('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization, Cache-Control, Pragma');
      res.setHeader('Access-Control-Allow-Credentials', 'true');
      console.log(`🎯 Handled OPTIONS preflight for: ${origin || 'default'}`);
    }
    res.status(200).end();
    return;
  }
  next();
});

// 应用代理中间件
app.use('/api', apiProxy);

// 错误处理中间件
app.use((error, req, res, next) => {
  console.error('🚨 Server Error:', error.message);
  res.status(500).json({
    error: 'Internal Server Error',
    message: error.message,
    timestamp: new Date().toISOString()
  });
});

// 404处理
app.use((req, res) => {
  res.status(404).json({
    error: 'Not Found',
    message: `Route ${req.url} not found`,
    timestamp: new Date().toISOString()
  });
});

const PORT = process.env.PORT || 3001;
const HOST = process.env.HOST || '127.0.0.1';

app.listen(PORT, HOST, () => {
  console.log('🚀 Flutter Web CORS代理服务器启动成功!');
  console.log(`📍 服务地址: http://${HOST}:${PORT}`);
  console.log(`📡 代理目标: http://47.106.218.81:20080`);
  console.log(`🌐 健康检查: http://${HOST}:${PORT}/health`);
  console.log(`🔧 环境: ${process.env.NODE_ENV || 'development'}`);
});