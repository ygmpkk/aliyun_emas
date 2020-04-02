import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';
import './src/model.dart';

export './src/model.dart';

class AliyunEmas {
  static final AliyunEmasPush push = AliyunEmasPush();
  static final AliyunEmasEventTrack eventTrack = AliyunEmasEventTrack();
}

typedef Future<dynamic> PushMessageHandler<T>(T message);

enum PushLogLevel {
  OFF,
  DEBUG,
  INFO,
  ERROR,
}

extension PushLogLevelExtension on PushLogLevel {
  int get name {
    switch (this) {
      case PushLogLevel.OFF:
        return 3;
      case PushLogLevel.DEBUG:
        return 2;
      case PushLogLevel.INFO:
        return 1;
      case PushLogLevel.ERROR:
        return 0;
      default:
        return null;
    }
  }
}

enum TagTarget {
  DEVICE,
  ACCOUNT,
  MOBILE,
}

extension TagTargetExtension on TagTarget {
  int get name {
    switch (this) {
      case TagTarget.DEVICE:
        return 1;
      case TagTarget.ACCOUNT:
        return 2;
      case TagTarget.MOBILE:
        return 3;
      default:
        return null;
    }
  }
}

class AliyunEmasPush {
  factory AliyunEmasPush() => _instance;

  @visibleForTesting
  AliyunEmasPush.private(MethodChannel channel, Platform platform)
      : _channel = channel,
        _platform = platform;

  static final AliyunEmasPush _instance = AliyunEmasPush.private(
      const MethodChannel('ygmpkk.aliyun_emas/emas'), const LocalPlatform());

  final MethodChannel _channel;
  final Platform _platform;

  /// 消息接收回调
  PushMessageHandler<String> _onToken;
  PushMessageHandler<String> _onInit;

  PushMessageHandler<ErrorResult> _onError;

  /// 消息接收回调
  PushMessageHandler<PushMessage> _onMessage;

  /// 通知接收回调
  PushMessageHandler<PushNotification> _onNotification;

  /// 通知打开回调
  PushMessageHandler<PushNotificationOpened> _onNotificationOpened;

  /// 通知删除回调
  PushMessageHandler<PushNotificationRemoved> _onNotificationRemoved;

  /// 通知在应用内到达回调

  PushMessageHandler<PushNotificationReceivedInApp>
      _onNotificationReceivedInApp;

  /// 在iOS设备上，需求请求通知权限
  PushMessageHandler<IosNotificationSettings> _onIosNotificationRegistered;

  Future<void> listenOn({
    PushMessageHandler<String> onInit,
    PushMessageHandler<String> onToken,
    PushMessageHandler<ErrorResult> onError,
    PushMessageHandler<PushMessage> onMessage,
    PushMessageHandler<PushNotification> onNotification,
    PushMessageHandler<PushNotificationOpened> onNotificationOpened,
    PushMessageHandler<PushNotificationRemoved> onNotificationRemoved,
    PushMessageHandler<PushNotificationReceivedInApp>
        onNotificationReceivedInApp,
    PushMessageHandler<IosNotificationSettings> onIosNotificationRegistered,
  }) async {
    _onInit = onInit;
    _onToken = onToken;
    _onError = onError;
    _onMessage = onMessage;
    _onNotification = onNotification;
    _onNotificationOpened = onNotificationOpened;
    _onNotificationRemoved = onNotificationRemoved;
    _onNotificationReceivedInApp = onNotificationReceivedInApp;
    _onIosNotificationRegistered = onIosNotificationRegistered;

    _channel.setMethodCallHandler(_handleMethod);
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onInit":
        return _onInit(call.arguments);

      case "onToken":
        return _onToken(call.arguments);

      case 'onError':
        return _onError(ErrorResult(
          code: call.arguments["code"],
          message: call.arguments['message'],
          details: call.arguments['details'],
        ));

      case "onIosSettingsRegistered":
        return _onIosNotificationRegistered(IosNotificationSettings(
          badge: call.arguments['badge'],
          sound: call.arguments["sound"],
          alert: call.arguments["alert"],
          provisional: call.arguments['provisional'],
        ));

      case "onMessage":
        return _onMessage(PushMessage(
          messageId: call.arguments["messageId"],
          title: call.arguments["title"],
          content: call.arguments["content"],
          traceInfo: call.arguments["traceInfo"],
          appId: call.arguments["appId"],
        ));

      case "onNotification":
        return _onNotification(PushNotification(
          title: call.arguments["title"],
          summary: call.arguments['summary'],
          extras: call.arguments["extras"],
        ));

      case "onNotificationOpened":
        return _onNotificationOpened(
          PushNotificationOpened(
              title: call.arguments["title"],
              summary: call.arguments["summary"],
              extras: call.arguments["extras"],
              subtitle: call.arguments["subtitle"],
              badge: call.arguments["badge"]),
        );

      case "onNotificationRemoved":
        return _onNotificationRemoved(PushNotificationRemoved(
          messageId: call.arguments["messageId"],
        ));

      case "onNotificationReceivedInApp":
        return _onNotificationReceivedInApp(PushNotificationReceivedInApp(
          title: call.arguments["title"],
          summary: call.arguments['summary'],
          extras: call.arguments["extras"],
          // android
          openType: call.arguments["openType"],
          openActivity: call.arguments["openActivity"],
          openUrl: call.arguments["openUrl"],
        ));

      default:
        throw UnsupportedError("Unrecognized JSON message");
    }
  }

  // iOS请求消息通知权限
  FutureOr<bool> requestNotificationPermissions(
    IosNotificationSettings iosSettings,
  ) {
    if (!_platform.isIOS) {
      return null;
    }

    return _channel.invokeMethod<bool>(
      'requestNotificationPermissions',
      iosSettings.toMap(),
    );
  }

  FutureOr<bool> get getIosNotificationSettingStatus async {
    if (!_platform.isIOS) {
      return null;
    }

    return _channel.invokeMethod<bool>("getNotificationSettingStatus");
  }

  FutureOr<void> openAppSettings() async {
    if (!_platform.isIOS) {
      return null;
    }

    return _channel.invokeMethod("openAppSettings");
  }

  Future<void> setDebug() async {
    return _channel.invokeMethod('setDebug');
  }

  /// 获取设备标识
  Future<String> get getDeviceId async {
    return await _channel.invokeMethod<String>('getDeviceId');
  }

  /// 打开推送通道
  Future<bool> turnOnPushChannel() async {
    await _channel.invokeMethod("turnOnPushChannel");
    return true;
  }

  /// 关闭推送通道
  Future<bool> turnOffPushChannel() async {
    await _channel.invokeMethod("turnOnPushChannel");
    return false;
  }

  /// 查询推送通道状态
  Future<String> checkPushChannelStatus() async {
    return _channel.invokeMethod("checkPushChannelStatus");
  }

  /// 绑定账号
  Future<void> bindAccount({
    String userId,
  }) async {
    return _channel.invokeMethod("bindAccount", {
      "userId": userId,
    });
  }

  /// 解绑账号
  Future<void> unbindAccount() async {
    return _channel.invokeMethod("unbindAccount");
  }

  /// 绑定标签
  Future<void> bindTag({
    TagTarget target,
    List<String> tags,
    String aliasId,
  }) async {
    return _channel.invokeMethod("bindTag", {
      "target": target.name,
      "tags": tags,
      "aliasId": aliasId,
    });
  }

  /// 解绑标签
  Future<void> removeTag({
    TagTarget target,
    List<String> tags,
    String aliasId,
  }) async {
    return _channel.invokeMethod("removeTag", {
      "target": target.name,
      "tags": tags,
      "aliasId": aliasId,
    });
  }

  /// 查询标签

  /// 添加别名����单个设备最多添加128个别名，且同一别名最多添加到128个设备
  Future<void> addAlias({
    String aliasId,
  }) async {
    return _channel.invokeMethod("addAlias", {
      "aliasId": aliasId,
    });
  }

  /// 删除别名
  Future<void> removeAlias({
    String aliasId,
  }) async {
    return _channel.invokeMethod("removeAlias", {
      "aliasId": aliasId,
    });
  }

  /// 查询别名

  /// 设置免打扰时段
  Future<void> setDoNotDisturb({
    @required int startHour,
    @required int startMinute,
    @required int endHour,
    @required int endMinute,
  }) async {
    return _channel.invokeMethod("setDoNotDisturb", {
      "startHour": startHour,
      "startMinute": startMinute,
      "endHour": endHour,
      "endMinute": endMinute,
    });
  }

  /// 关闭免打扰功能
  Future<void> closeDoNotDisturbMode() async {
    return _channel.invokeMethod("closeDoNotDisturbMode");
  }

  /// 删除所有通知接口
  Future<void> clearNotifications() async {
    return _channel.invokeMethod("clearNotifications");
  }

  /// 绑定电话号
  Future<void> bindPhoneNumber({@required String mobile}) async {
    return _channel.invokeMethod("bindPhoneNumber", {"mobile": mobile});
  }

  /// 解绑电话号
  Future<void> unbindPhoneNumber() async {
    return _channel.invokeMethod("unbindPhoneNumber");
  }

  /// 用户注册
  Future<void> userRegister({
    @required String userId,
  }) async {
    return _channel.invokeMethod("userRegister", {"userId": userId});
  }

  /// 登录/注销
  Future<void> updateUserAccount({
    @required String userId,
    @required String username,
  }) async {
    return _channel.invokeMethod("updateUserAccount", {
      "userId": userId,
      "username": username,
    });
  }
}

class AliyunEmasEventTrack {
  factory AliyunEmasEventTrack() => _instance;

  @visibleForTesting
  AliyunEmasEventTrack.private(MethodChannel channel, Platform platform)
      : _channel = channel;

  static final AliyunEmasEventTrack _instance = AliyunEmasEventTrack.private(
      const MethodChannel('ygmpkk.aliyun_emas/emas'), const LocalPlatform());

  final MethodChannel _channel;

  /// 进入页面
  Future<void> pageAppear() async {
    return _channel.invokeMethod("pageAppear");
  }

  /// 退出页面
  Future<void> pageDisAppear() async {
    return _channel.invokeMethod("pageDisAppear");
  }

  /// 更新页面埋点
  Future<void> updatePageProperties({
    @required Map<String, String> properties,
  }) async {
    return _channel.invokeMethod("updatePageProperties", {
      "properties": properties,
    });
  }

  /// 自定义页面埋点
  Future<void> trackPage({
    @required String pageName,
    String referrer,
    int duration,
    Map<String, String> properties,
  }) async {
    return _channel.invokeMethod("trackPage", {
      "pageName": pageName,
      "referrer": referrer,
      "duration": duration,
      "properties": properties,
    });
  }

  /// 事件埋点
  Future<void> trackEvent({
    @required String pageName,
    @required String eventName,
    int duration,
    Map<String, String> properties,
  }) async {
    return _channel.invokeMethod("trackEvent", {
      "pageName": pageName,
      "eventName": eventName,
      "duration": duration,
      "properties": properties,
    });
  }

  /// 关闭自动页面埋点
  Future<void> turnOffAutoPageTrack() async {
    return _channel.invokeMethod("turnOffAutoPageTrack");
  }
}

/*
{
"aps": {
"alert": {
"title": "title1",
"subtitle": "subtitle1",
"body": "body1"
},
"badge": 1,
"sound": "default"
},
"Extras": {"key1": "value1"}
}
*/
