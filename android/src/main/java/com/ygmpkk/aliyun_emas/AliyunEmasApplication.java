package com.ygmpkk.aliyun_emas;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.util.Log;

import com.alibaba.sdk.android.man.MANService;
import com.alibaba.sdk.android.man.MANServiceProvider;
import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.huawei.HuaWeiRegister;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.MiPushRegister;

import org.jetbrains.annotations.Nullable;

import io.flutter.app.FlutterApplication;

public class AliyunEmasApplication {
  private static String TAG = "AliyunEmasApplication";

  public static void init(FlutterApplication application, Context context) {
    // Push
    PushServiceFactory.init(context);
    final CloudPushService pushService = PushServiceFactory.getCloudPushService();
    pushService.setDebug(true);
    pushService.register(context, new CommonCallback() {
      @Override
      public void onSuccess(String response) {
        Log.d(TAG, "init cloud channel success" + response);
      }

      @Override
      public void onFailed(String errorCode, String errorMessage) {
        Log.d(TAG, "init cloud channel failed -- errorCode:" + errorCode + " -- errorMessage:" + errorMessage);
      }
    });

    // Mobile report
    MANService manService = MANServiceProvider.getService();
    manService.getMANAnalytics().turnOnDebug();
//    manService.getMANAnalytics().turnOffCrashReporter();
//    manService.getMANAnalytics().turnOffAutoPageTrack();
    manService.getMANAnalytics().init(application, context);

    // Feedback
  }

  private static void reigstePushChannel(FlutterApplication application, Context context) {
    String mi_appid = getPackageMetadata(context, "MI_APPID");
    String mi_appkey = getPackageMetadata(context, "MI_APPKEY");

    MiPushRegister.register(application, mi_appid, mi_appkey);
    HuaWeiRegister.register(application);


//    OppoRegister.register(this, "abc", "def");
//    VivoRegister.register(this);
//    MeizuRegister.register(this, "appId", "appkey");
//    GcmRegister.register(this, sendId, applicationId); //sendId/applicationId为步骤获得的参数
  }

  @Nullable
  private static String getPackageMetadata(Context context, String name) {
    try {
      ApplicationInfo appInfo = context.getPackageManager().getApplicationInfo(
        context.getPackageName(), PackageManager.GET_META_DATA);
      if (appInfo.metaData != null) {
        return appInfo.metaData.getString(name);
      }
    } catch (PackageManager.NameNotFoundException e) {
    }

    return null;
  }
}
