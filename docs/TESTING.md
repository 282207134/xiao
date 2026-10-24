# 测试与验证记录

验证日期：2026-10-24（Asia/Tokyo）。

## 环境

| 项目 | 环境 |
| --- | --- |
| Flutter / Dart | 3.41.6 stable / 3.11.4 |
| Xcode | 26.0.1 |
| 运行平台 | iPhone 17 Pro，iOS 26.0 模拟器 |
| 截图分辨率 | 1206 × 2622 |
| 组件测试尺寸 | 375 × 812、320 × 568、844 × 390 |

## 结果

| 检查 | 结果 |
| --- | --- |
| `flutter analyze` | 通过，无问题 |
| `flutter test` | 10 项测试通过 |
| iOS 集成测试 | 完整流程通过 |
| 24 个路由的三种尺寸布局 | 通过，未发现 RenderFlex 溢出 |
| 原始界面截图 | 29 张，已逐组视觉复核 |

单元测试验证：购物车变体合并、数量边界、运费与合计、重复下单保护、本地状态恢复、不保存密码和消息、损坏 JSON、空消息和独立会话。

组件测试验证：登录表单错误、访客进入、空图片占位面积、24 个路由的标准手机 / 小屏 / 横屏渲染、主题切换。

模拟器集成测试执行：引导 → 欢迎 → 注册 / 登录 → 访客 → 动态 → 导航 → 分类 → 文章 → 收藏 → 商城 → 商品集合 → 详情 → 加入购物车 → 数量调整 → 配送 → 演示支付 → 核对 → 订单完成；随后验证消息发送、音乐页面、图表周期切换、资料保存和深色切换。

视觉复核修正了空图片占位在松约束下收缩的问题。加入了尺寸断言防止此问题回归。最终截图已重新采集。

## 复现

```bash
flutter pub get
flutter analyze
flutter test
flutter devices
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d <模拟器设备ID>
```

截图写入 `docs/screenshots/`，集成测试使用独立的内存偏好存储，不依赖日常运行时保存的数据。文档拼图可用 Python + Pillow 重新生成：

```bash
python3 scripts/make_gallery.py
```

## 已知范围

运行与截图在 iOS 模拟器完成，未进行 Android 真机、iOS 真机、商店发布或真实网络服务测试。UI Kit 的灰色图片区块属于原始设计占位。音乐播放器测试覆盖交互预览，不包含音频解码与播放。
