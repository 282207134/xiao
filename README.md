# xiao · Flutter 综合演示 App

根据 Pixso 的 xiao UI Kit 开发，选取各模块主要界面，串联引导、登录、动态、文章、商城、聊天、音乐、账户和个人资料。共 24 个路由，提供 29 张运行截图。

![主要界面预览](docs/screenshots/overview.png)

- [项目说明与架构](docs/PROJECT.md)：目录结构、状态管理、路由、设计映射、功能边界。
- [完整截图目录](docs/SCREENSHOTS.md)：每个页面和结算步骤的截图。
- [测试记录](docs/TESTING.md)：测试结果与复现命令。

## 运行

环境：Flutter 3.41.6 / Dart 3.11.4。已在 iPhone 17 Pro / iOS 26.0 模拟器验证。

```bash
flutter pub get
flutter run
```

首次启动显示引导页。点击 Get started → Sign Up / Login → Explore as guest 即可体验；也可使用任意合法邮箱及至少 6 位密码体验本地登录。下次启动会恢复本地会话。

在首页点击菜单图标进入全部模块。Settings 可切换深色模式。

## 检查与截图

```bash
flutter analyze
flutter test
flutter drive --driver=test_driver/integration_test.dart \
  --target=integration_test/app_test.dart -d <模拟器设备ID>
```

第三条命令会重新生成 `docs/screenshots/` 中的 29 张原始截图。

## 当前范围

这是可交互的本地演示 App：登录、订单及付款使用演示逻辑；聊天支持本机会话内消息；音乐支持播放状态、进度、切歌、循环和歌单预览，未接入音频源。设计稿中的灰色图片占位保持原样。未接入后端、真实付款或第三方账号。

源码只依赖 Flutter 和 shared_preferences。IBM Plex Sans 字体已随项目附带，许可见 [OFL.txt](assets/fonts/OFL.txt)。
