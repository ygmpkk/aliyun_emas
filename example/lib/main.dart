import 'package:flutter/material.dart';
import 'dart:async';

import 'package:aliyun_emas/aliyun_emas.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _deviceId = 'unknown';
  String _pushTitle = '';
  String _pushContent = '';
  String _messageTitle = '';
  String _messageContent = '';

  @override
  void initState() {
    super.initState();
    setupPush();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupPush() async {
    // bool hasNotificationPermission =
    //     await AliyunEmas.push.getIosNotificationSettingStatus;

//    await AliyunEmas.push.setDebug();
    await AliyunEmas.push.listenOn(
      onInit: (String deviceId) async {
        print("callback deviceId => $deviceId");
      },
      onToken: (String token) async {
        print("callback token => $token");
      },
      onIosNotificationRegistered: (IosNotificationSettings msg) async {
        print("onIosSettingsRegistered: $msg");

        await AliyunEmas.push.bindAccount(userId: "ygmpkk");
      },
      onNotification: (PushNotification msg) async {
        print('received_onNotification: $msg');
      },
      onMessage: (PushMessage msg) async {
        print('received_onMessage: $msg');

        setState(() {
          _messageTitle = msg.title;
          _messageContent = msg.content;
        });
      },
      onNotificationOpened: (PushNotificationOpened msg) async {
        print(
            "onNotificationOpened => title: ${msg.title}, summary: ${msg.summary}, extras: ${msg.extras}, badge: ${msg.badge}");
        setState(() {
          _pushTitle = msg.title;
          _pushContent = msg.summary;
        });
      },
      onNotificationReceivedInApp: (PushNotificationReceivedInApp msg) async {
        print("onNotificationReceivedInApp => ${msg.extras}");
      },
    );

    String deviceId = await AliyunEmas.push.getDeviceId;

    print("deviceId: $deviceId");

    setState(() {
      _deviceId = deviceId;
    });

   await  AliyunEmas.eventTrack.trackEvent(pageName: 'abc', eventName: 'bbb');
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
            Container(
              child: FlatButton(
                child: Text('获取通知权限'),
                onPressed: () async {
                  var granted = await AliyunEmas.push
                      .requestNotificationPermissions(IosNotificationSettings(
                          sound: true,
                          badge: true,
                          alert: true,
                          provisional: false));
                  print("granted: $granted");
                  await AliyunEmas.push.openAppSettings();
                },
              ),
            ),
            Container(
              child: Text('DeviceId: $_deviceId\n'),
            ),
            Container(
              child: Text('Push title: $_pushTitle\n'),
            ),
            Container(
              child: Text('Push content: $_pushContent\n'),
            ),
            Container(
              child: Text('Message title: $_messageTitle\n'),
            ),
            Container(
              child: Text('Message content: $_messageContent\n'),
            ),
          ],
        ),
      ),
    );
  }
}
