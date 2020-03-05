import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Umenganalytics {
  static const String CHANNEL_NAME = "io.baizi.umenganalytics";
  static const MethodChannel _channel = const MethodChannel(CHANNEL_NAME);

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> init({
    @required String androidKey,
    @required String iOSKey,
    bool logEnable = false,
    bool encrypt = false,
    bool reportCrash = true,
    String channel = "",
  }) {
    return _channel.invokeMethod("init", {
      "androidKey": androidKey,
      "iOSKey": iOSKey,
      "logEnable": logEnable,
      "encrypt": encrypt,
      "reportCrash": reportCrash,
      "channel": channel,
    });
  }

  ///
  /// 访问页面
  static void onPageStart(String pageName) {
    _channel.invokeMethod("onPageStart", pageName);
  }

  static void onPageEnd(String pageName) {
    _channel.invokeMethod("onPageEnd", pageName);
  }

  static void onEvent(String event, Map<String, dynamic> data) {
    _channel.invokeMapMethod("onEvent", {
      "event": event,
      "data": data ?? {},
    });
  }

  static void onEventLabel(String event, String label) {
    _channel.invokeMethod("onEvent", {
      "event": event,
      "data": label,
    });
  }

  static void onError(String errorMessage) {
    _channel.invokeMethod("onError", errorMessage);
  }
}
