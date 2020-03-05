# umenganalytics

umeng analytics for flutter

## Getting Started

### 安卓
1. 引入依赖
2. 初始化友盟统计
```dart
  Umenganalytics.init(androidKey: "your youmeng key", iOSKey: "");

```
3. 添加路由监听

```dart
MaterialApp(
  home: MyHomePage(),
  navigatorObservers: [
    UmengAnalyticsObserver(),
  ],
);
```
