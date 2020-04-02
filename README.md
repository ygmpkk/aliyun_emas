# 阿里云EMAS插件

支持阿里云EMAS的推送、移动数据分析、Feedback、



## 快速开始

阿里云消息通知有两种方式，一种是系统级别的Push通知，还有一种是应用内的消息。

iOS的Push到达率比较稳定，所有的Push必须走iOS系统的通道。但是Android的国内版没办法使用Google服务，所以很多的推送都失效了，有些App的做法是自己持久化为1个像素保持后台活跃达到推送的目的；还在国内有5大厂商有推送接口，小米、华为、魅族、Oppo、Vivo，如果要自己一家家对接的话，工作量也是一个问题，用阿里云EMAS可以统一解决这个问题，只需要简单配置一下就可以使用。

iOS和Android的推送的差别还是挺多的，插件在实现的时候，尽量保持API的一致性。

集成插件

```dart
// 引用插件
import 'package:aliyun_emas/aliyun_emas.dart';

// 监听回调
await AliyunEmas.push.listenOn(
  onInit: (T deviceId) async {}, // iOS插件初始化之后回调这个函数
  onToken: (T deviceToken) async {}, // iOS设备注册之后，获得deviceToken，开发和生产环境生成的deviceToken是不一致的
  
	// 消息相关
	onMessage: (T message) async {},
	// 通知相关
	onNotification: (T notification) async {},
	onNotificationReceivedInApp: (T notification) async {},
	onNotificationOpened: (T notification) async {},
	onNotificationRemoved: (T notification) async {}, // iOS无效
);
```

iOS 10之后，应工信部要求，必须先获得用户授权同意，才能发送push通知。

推荐先请求一下用户是否开启了通知，如果没有开启通知，需要引导用户去系统设置一下通知。

```dart
// 获取是否获得通知权限
// Android设备如果调用的话，返回null
// iOS设备调用，返回true或者false
bool hasTurnOnPush = await AliyunEmas.push.getIosNotificationSettingStatus;
```



获取权限示例

```dart
...
Container(
  child: FlatButton(
 	child: Text('获取通知权限'),
 	onPressed: () async {
 		var granted = await AliyunEmas.push.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
      provisional: false,
    ));
 		print("granted: $granted");
    // await AliyunEmas.push.openAppSettings();
	},
)
...
  
// 可以增加一个回调函数，用于判断用户是否授权Push消息
await AliyunEmas.push.listenOn(
	onIosNotificationRegistered: (T result) async {},
);
```

## 回调函数

| API                             | 参数                    | iOS Only | Android Only |
| ------------------------------- | ----------------------- | -------- | ------------ |
| onInit                          | SDK初始化               | ✔️        |              |
| onToken                         | 获得DeviceToken         | ✔️        |              |
| onMessage                       | 应用内消息              |          |              |
| onNotification                  | Push消息                |          |              |
| onNotificationReceivedInApp     | 应用内Push消息          |          |              |
| onNotificationOpened            | 打开Push消息            |          |              |
| onNotificationRemoved           | 忽略Push消息            |          | ✔️            |

## API

| API                             | 参数                    | iOS Only | Android Only |
| ------------------------------- | ----------------------- | -------- | ------------ |
| requestNotificationPermissions  | 请求通知权限            | ✔️        |              |
| getIosNotificationSettingStatus | 获取iOS是否有通知权限   | ✔️        |              |
| openAppSettings                 | 打开iOS应用设置         | ✔️        |              |
| setDebug                        | Debug模式               |          | ✔️            |
| getDeviceId                     | 获取Device Id           |          |              |
| turnOnPushChannel               | 打开推送通道            |          | ✔️            |
| turnOffPushChannel              | 关闭推送通道            |          | ✔️            |
| checkPushChannelStatus          | 检查推送通道            |          | ✔️            |
| bindAccount                     | 绑定账号，唯一          |          |              |
| unbindAccount                   | 解除绑定                |          |              |
| bindTag                         | 绑定Tag                 |          |              |
| removeTag                       | 删除Tag                 |          |              |
| addAlias                        | 绑定别名，最多绑定128个 |          |              |
| removeAlias                     | 解绑别名                |          |              |
| setDoNotDisturb                 | 开启勿扰模式            |          | ✔️            |
| closeDoNotDisturbMode           | 关闭勿扰模式            |          | ✔️            |
| clearNotifications              | 清除角标                |          |              |
| bindPhoneNumber                 | 绑定手机号              |          | ✔️            |
| unbindPhoneNumber               | 解绑手机号              |          | ✔️            |

## iOS集成

项目的 AppDelegate.m 增加一段配置

```objc
- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      // 增加这一行
  if (@available(iOS 10.0, *)) {
    [UNUserNotificationCenter currentNotificationCenter].delegate = (id<UNUserNotificationCenterDelegate>)self;
  }
    
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
```

打开系统配置还需要配置一下 Info.plist

```xml
<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>prefs</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>app-prefs</string>
			</array>
		</dict>
	</array>
```

在XCode的Targets设置需要打开Notification和Background Mode的Remote notifications



## Android集成

1. 在android/gradle目录下，修改gradle-wrapper.properties配置

```
distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.2-all.zip
```



2. android目录下的build.gradle

在buildscript.repositories增加maven配置，dependencies增加一个classpath，用于解析aliyun-emas-services.json配置。

```
buildscript {
    repositories {
        google()
        jcenter()
        // 增加阿里云的配置
        maven {
            url 'http://maven.aliyun.com/nexus/content/repositories/releases/'
        }
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:3.5.3'
        // 增加一个classpath
        classpath 'com.aliyun.ams:emas-services:1.0.1'
    }
}

allprojects {
    repositories {
        google()
        jcenter()
    }
}

rootProject.buildDir = '../build'
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(':app')
}

task clean(type: Delete) {
    delete rootProject.buildDir
}

```



3. 在app目录下的build.gradle

在apply plugin: 'com.android.application'下面增加一行

```
apply plugin: 'com.aliyun.ams.emas-services'
```



在defaultConfig下面增加一段配置

```gradle
manifestPlaceholders = [
  HUAWEI_APPID: "101687971",
  VIVO_APIKEY : "YOUR OPPO_APPID",
  OPPO_APPID  : "YOUR OPPO_APPID",
]

// 小米推送
buildConfigField 'String', 'MI_APPID', '"2882303761518311833"'
buildConfigField 'String', 'MI_APPKEY', '"5321831155833"'

// 华为推送，不需要配置

// Oppo推送
buildConfigField 'String', 'OPPO_APPKEY', '"YOUR OPPO_APPKEY"'
buildConfigField 'String', 'OPPO_APPSECRET', '"YOUR OPPO_APPSECRET"'

// Vivo推送，不需要配置

// 魅族推送
buildConfigField 'String', 'MEIZU_APPKEY', '"YOUR MEIZU_APPKEY"'
buildConfigField 'String', 'MEIZU_APPSECRET', '"YOUR MEIZU_APPSECRET"'
```



4. 在app/src/main目录下的AndroidManifest.xml

manifest增加一个属性

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.ygmpkk.aliyun_emas_example">
```

application增加属性修改android:name为自定义的Application，增加tools:replace="android:label"配置

```
<application
        android:name=".MyApplication"
        android:icon="@mipmap/ic_launcher"
        android:label="aliyun_emas_example"
        tools:replace="android:label">
```

在application下面增加一段配置

```
<meta-data
  android:name="com.huawei.hms.client.appid"
  android:value="appid=${HUAWEI_APPID}" />
<meta-data
  android:name="com.vivo.push.api_key"
  android:value="${VIVO_APIKEY}" />
<meta-data
  android:name="com.vivo.push.app_id"
  android:value="${OPPO_APPID}" />
```

在代码目录下增加一个文件MyApplication.java

```
package com.ygmpkk.aliyun_emas_example;

import android.util.Log;

import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.huawei.HuaWeiRegister;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.MiPushRegister;
import com.huawei.hms.support.api.push.HuaweiPush;
import com.huawei.hms.support.api.push.service.HmsMsgService;


import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    private static String TAG = "AliyunEmasApplication";

    public void onCreate() {
        super.onCreate();

        initPushService();
        initThirdPushServices();
    }

    private void initPushService() {

        PushServiceFactory.init(getApplicationContext());
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();
        pushService.setDebug(true);
        pushService.register(getApplicationContext(), new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                Log.d(TAG, "init cloud channel success" + response);
            }

            @Override
            public void onFailed(String errorCode, String errorMessage) {
                Log.d(TAG, "init cloud channel failed -- errorCode:" + errorCode + " -- errorMessage:" + errorMessage);
            }
        });
    }

    private void initThirdPushServices() {
        MiPushRegister.register(this, BuildConfig.MI_APPID, BuildConfig.MI_APPKEY);
        HuaWeiRegister.register(this);

//    OppoRegister.register(this, "abc", "def");
//    VivoRegister.register(this);
//    MeizuRegister.register(this, "appId", "appkey");
//    GcmRegister.register(this, sendId, applicationId); //sendId/applicationId为步骤获得的参数
    }
}
```





