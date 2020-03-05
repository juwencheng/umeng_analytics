import 'package:flutter/material.dart';
import 'package:umenganalytics/umenganalytics.dart';

void main() {

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Umenganalytics.init(androidKey: "5e607074895ccaf7f50001ca", iOSKey: "", logEnable: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            FlatButton(
              child: Text("打开页面"),
              onPressed: () {
                Umenganalytics.onPageStart("/test_page");
              },
            ),
            FlatButton(
              child: Text("关闭页面"),
              onPressed: () {
                Umenganalytics.onPageEnd("/test_page");
              },
            ),
            FlatButton(
              child: Text("记录事件"),
              onPressed: () {
                Umenganalytics.onEvent("test", {
                  "key1":"value1",
                  "key2":"value2"
                });
              },
            ),
            FlatButton(
              child: Text("上报错误"),
              onPressed: () {
                Umenganalytics.onError("上报错误信息");
              },
            ),
          ],
        ),
      ),
    );
  }
}
