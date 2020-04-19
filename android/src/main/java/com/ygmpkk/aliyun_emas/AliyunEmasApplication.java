package com.ygmpkk.aliyun_emas;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.os.Build;
import android.util.Log;

import com.alibaba.sdk.android.man.MANService;
import com.alibaba.sdk.android.man.MANServiceProvider;
import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.huawei.HuaWeiRegister;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;
import com.alibaba.sdk.android.push.register.MiPushRegister;
import com.alibaba.sdk.android.push.register.OppoRegister;
import com.alibaba.sdk.android.push.register.VivoRegister;

import org.jetbrains.annotations.Nullable;

import io.flutter.app.FlutterApplication;

public class AliyunEmasApplication {
    private static String TAG = "AliyunEmasApplication";

    public static void init(FlutterApplication application, Context context) {
        try {
            createNotificationChannel(context);

            initPush(application, context);

            // 注册厂商通道
            thirdPushChannel(application, context);
        } catch (Exception ex) {
            Log.e(TAG, ex.getMessage());
        }
    }

    public static void initPush(FlutterApplication application, Context context) {
        Log.d(TAG, "初始化Push服务");
        // 初始化Push服务
        PushServiceFactory.init(context);
        final CloudPushService pushService = PushServiceFactory.getCloudPushService();
//        pushService.setDebug(true);
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

        pushService.turnOnPushChannel(new CommonCallback() {
            @Override
            public void onSuccess(String s) {

            }

            @Override
            public void onFailed(String s, String s1) {

            }
        });


        Log.d(TAG, "注册MANServiceProvider");
        try {
            // Mobile report
            MANService manService = MANServiceProvider.getService();
//        manService.getMANAnalytics().turnOnDebug();
//        manService.getMANAnalytics().turnOffCrashReporter();
//        manService.getMANAnalytics().turnOffAutoPageTrack();
            manService.getMANAnalytics().init(application, context);
        } catch (Exception ex) {
            Log.e(TAG, ex.getMessage());
        }
    }


    private static void thirdPushChannel(FlutterApplication application, Context context) {
        Log.d(TAG, "注册厂商通道");
        String mi_appid = getPackageMetadata(context, "MI_APPID");
        String mi_appkey = getPackageMetadata(context, "MI_APPKEY");
        String oppo_appkey = getPackageMetadata(context, "OPPO_APPKEY");
        String oppo_appsecret = getPackageMetadata(context, "OPPO_APPSECRET");

//        Log.e(TAG, mi_appid.getClass().toString());
//        Log.e(TAG, mi_appid);
//        Log.e(TAG, mi_appkey);
//        Log.e(TAG, hw_appid);

        MiPushRegister.register(context, mi_appid, mi_appkey);
        HuaWeiRegister.register(application);

        OppoRegister.register(application, oppo_appkey, oppo_appsecret);
        VivoRegister.register(application);
//        MeizuRegister.register(this, "appId", "appkey");
//        GcmRegister.register(this, sendId, applicationId); //sendId/applicationId为步骤获得的参数
    }

    private static void createNotificationChannel(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
            // 通知渠道的id
            String id = "1";
            // 用户可以看到的通知渠道的名字.
            CharSequence name = "notification channel";
            // 用户可以看到的通知渠道的描述
            String description = "notification description";
            int importance = NotificationManager.IMPORTANCE_HIGH;
            NotificationChannel mChannel = new NotificationChannel(id, name, importance);
            // 配置通知渠道的属性
            mChannel.setDescription(description);
            // 设置通知出现时的闪灯（如果 android 设备支持的话）
            mChannel.enableLights(true);
            mChannel.setLightColor(Color.RED);
            // 设置通知出现时的震动（如果 android 设备支持的话）
            mChannel.enableVibration(true);
            mChannel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});
            //最后在notificationmanager中创建该通知渠道
            mNotificationManager.createNotificationChannel(mChannel);
        }
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

        return "";
    }
}
