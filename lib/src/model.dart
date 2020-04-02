/// 接收到应用内消息
class PushMessage {
  final String messageId;
  final String appId;
  final String title;
  final String content;
  final String traceInfo;

  PushMessage({
    this.messageId,
    this.appId,
    this.title,
    this.content,
    this.traceInfo,
  });
}

/// 接收到推送通知
class PushNotification {
  final String title;
  final String summary;
  final Map extras;

  PushNotification({
    this.title,
    this.summary,
    this.extras,
  });
}

/// 打开推送通知消息
class PushNotificationOpened {
  final String title;
  final String summary;
  final Map extras;
  final String subtitle;
  final int badge;

  PushNotificationOpened({
    this.title,
    this.summary,
    this.extras,
    this.subtitle,
    this.badge,
  });
}

/// 忽略推送通知
class PushNotificationRemoved {
  final String messageId;

  PushNotificationRemoved({
    this.messageId,
  });
}

/// 应用内收到推送消息
class PushNotificationReceivedInApp {
  final String title;
  final String summary;
  final Map extras;
  final int openType;
  final String openActivity;
  final String openUrl;

  PushNotificationReceivedInApp({
    this.title,
    this.summary,
    this.extras,
    this.openType,
    this.openActivity,
    this.openUrl,
  });
}

/// iOS通知配置
class IosNotificationSettings {
  final bool sound;
  final bool badge;
  final bool alert;
  final bool provisional;

  IosNotificationSettings({
    this.sound = true,
    this.badge = true,
    this.alert = true,
    this.provisional = false,
  });

  Map<String, dynamic> toMap() {
    return <String, bool>{
      'sound': sound,
      'alert': alert,
      'badge': badge,
      'provisional': provisional
    };
  }
}

class ErrorResult {
  final String code;
  final String message;
  final dynamic details;

  ErrorResult({
    this.code,
    this.message,
    this.details,
  });
}
