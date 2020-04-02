package com.ygmpkk.aliyun_emas;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import com.alibaba.sdk.android.man.MANHitBuilders;
import com.alibaba.sdk.android.man.MANPageHitBuilder;
import com.alibaba.sdk.android.man.MANService;
import com.alibaba.sdk.android.man.MANServiceProvider;
import com.alibaba.sdk.android.push.CloudPushService;
import com.alibaba.sdk.android.push.CommonCallback;
import com.alibaba.sdk.android.push.noonesdk.PushServiceFactory;

import java.util.Map;

/**
 * AliyunEmasPlugin
 */
public class AliyunEmasPlugin implements FlutterPlugin, MethodCallHandler {
    private static final String TAG = "AliyunEmasPlugin";

    private Activity activity;
    private MethodChannel channel;
    private Context applicationContext;
    private CloudPushService pushService;
    private MANService manService;

    public static void registerWith(Registrar registrar) {
        AliyunEmasPlugin instance = new AliyunEmasPlugin();
        instance.setActivity(registrar.activity());
        instance.onAttachedToEngine(registrar.context(), registrar.messenger());
    }

    private void setActivity(Activity activity) {
        this.activity = activity;
    }

    private void onAttachedToEngine(Context context, BinaryMessenger binaryMessenger) {
        this.applicationContext = context;
        channel = new MethodChannel(binaryMessenger, "ygmpkk.aliyun_emas/emas");
        channel.setMethodCallHandler(this);
        pushService = PushServiceFactory.getCloudPushService();
        manService = MANServiceProvider.getService();
        AliyunEmasHandler.methodChannel = channel;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        switch (call.method) {
            case "getDeviceId":
                getDeviceId(call, result);
                break;

            case "turnOnPushChannel":
                turnOnPushChannel(call, result);
                break;

            case "turnOffPushChannel":
                turnOffPushChannel(call, result);
                break;

            case "checkPushChannelStatus":
                checkPushChannelStatus(call, result);
                break;

            case "setDoNotDisturb":
                setDoNotDisturb(call, result);
                break;

            case "closeDoNotDisturbMode":
                closeDoNotDisturbMode(call, result);
                break;

            case "addAlias":
                addAlias(call, result);
                break;

            case "removeAlias":
                removeAlias(call, result);
                break;

            case "bindAccount":
                bindAccount(call, result);
                break;

            case "unbindAccount":
                unbindAccount(call, result);
                break;

            case "bindPhoneNumber":
                bindPhoneNumber(call, result);
                break;

            case "unbindPhoneNumber":
                unbindPhoneNumber(call, result);
                break;

            case "bindTag":
                bindTag(call, result);
                break;

            case "unbindTag":
                unbindTag(call, result);
                break;


            case "setLogLevel":
                setLogLevel(call, result);
                break;

            case "setDebug":
                setDebug(call, result);
                break;

            case "clearNotifications":
                clearNotifications(call, result);
                break;

            case "turnOffAutoPageTrack":
                turnOffAutoPageTrack(call, result);
                break;

            case "pageAppear":
                pageAppear(call, result);
                break;

            case "pageDisAppear":
                pageDisAppear(call, result);
                break;

            case "userRegister":
                userRegister(call, result);
                break;

            case "updateUserAccount":
                updateUserAccount(call, result);
                break;

            case "updatePageProperties":
                updatePageProperties(call, result);
                break;

            case "trackPage":
                trackPage(call, result);
                break;

            case "trackEvent":
                trackEvent(call, result);
                break;

            default:
                result.notImplemented();
                break;
        }
    }

    private void getDeviceId(MethodCall call, final Result result) {
        Log.d(TAG, "getDeviceId");

        result.success(pushService.getDeviceId());
    }

    private void turnOnPushChannel(MethodCall call, final Result result) {
        pushService.turnOnPushChannel(commonCallbackHandle(call, result));
    }

    private void turnOffPushChannel(MethodCall call, final Result result) {
        pushService.turnOffPushChannel(commonCallbackHandle(call, result));
    }


    private void checkPushChannelStatus(MethodCall call, final Result result) {
        pushService.checkPushChannelStatus(commonCallbackHandle(call, result));
    }


    @SuppressWarnings("ConstantConditions")
    private void setDoNotDisturb(MethodCall call, final Result result) {
        Integer startHour = call.argument("startHour");
        Integer startMinute = call.argument("startMinute");
        Integer endHour = call.argument("endHour");
        Integer endMinute = call.argument("endMinute");

        pushService.setDoNotDisturb(startHour, startMinute, endHour, endMinute, commonCallbackHandle(call, result));
    }


    private void addAlias(MethodCall call, final Result result) {
        String aliasId = call.argument("aliasId");
        pushService.addAlias(aliasId, commonCallbackHandle(call, result));
    }


    private void removeAlias(MethodCall call, final Result result) {
        String aliasId = call.argument("aliasId");
        pushService.removeAlias(aliasId, commonCallbackHandle(call, result));
    }

    private void bindAccount(MethodCall call, final Result result) {
        String userId = call.argument("userId");
        pushService.bindAccount(userId, commonCallbackHandle(call, result));
    }


    private void unbindAccount(MethodCall call, final Result result) {
        pushService.unbindAccount(commonCallbackHandle(call, result));
    }


    private void bindPhoneNumber(MethodCall call, final Result result) {
        String mobile = call.argument("mobile");
        pushService.bindPhoneNumber(mobile, commonCallbackHandle(call, result));
    }


    private void unbindPhoneNumber(MethodCall call, final Result result) {
        pushService.unbindPhoneNumber(commonCallbackHandle(call, result));
    }


    private void bindTag(MethodCall call, final Result result) {
        Integer target = call.argument("target");
        String[] tags = call.argument("tags");
        String aliasId = call.argument("aliasId");
        pushService.bindTag(target, tags, aliasId, commonCallbackHandle(call, result));
    }


    private void unbindTag(MethodCall call, final Result result) {
        Integer target = call.argument("target");
        String[] tags = call.argument("tags");
        String aliasId = call.argument("aliasId");
        pushService.unbindTag(target, tags, aliasId, commonCallbackHandle(call, result));
    }


    private void setLogLevel(MethodCall call, final Result result) {
        Integer logLevel = call.argument("logLevel");

        pushService.setLogLevel(logLevel);
        result.success(true);
    }


    private void closeDoNotDisturbMode(MethodCall call, final Result result) {
        pushService.closeDoNotDisturbMode();
        result.success(true);
    }


    private void clearNotifications(MethodCall call, final Result result) {
        pushService.clearNotifications();
        result.success(true);
    }


    private void setDebug(MethodCall call, final Result result) {
        boolean debugMode = call.argument("debug");
        pushService.setDebug(debugMode);
        result.success(true);
    }

    private void userRegister(MethodCall call, final Result result) {
        String userId = call.argument("userId");
        manService.getMANAnalytics().userRegister(userId);
        result.success(true);
    }

    private void updateUserAccount(MethodCall call, final Result result) {
        String username = call.argument("username");
        String userId = call.argument("userId");
        manService.getMANAnalytics().updateUserAccount(username, userId);
        result.success(true);
    }

    private void turnOffAutoPageTrack(MethodCall call, final Result result) {
        manService.getMANAnalytics().turnOffAutoPageTrack();
        result.success(true);
    }

    private void pageAppear(MethodCall call, final Result result) {
        manService.getMANPageHitHelper().pageAppear(activity);
        result.success(true);
    }


    private void pageDisAppear(MethodCall call, final Result result) {
        manService.getMANPageHitHelper().pageAppear(activity);
        result.success(true);
    }

    private void updatePageProperties(MethodCall call, final Result result) {
        Map<String, String> properties = call.argument("properties");
        manService.getMANPageHitHelper().updatePageProperties(properties);
        result.success(true);
    }


    private void trackPage(MethodCall call, final Result result) {
        String pageName = call.argument("pageName");
        String referrer = call.argument("referrer");
        Long duration = call.argument("duration");
        Map<String, String> properties = call.argument("properties");

        MANPageHitBuilder builder = new MANPageHitBuilder(pageName);
        builder.setReferPage(referrer);
        builder.setDurationOnPage(duration);
        builder.setProperties(properties);

        manService.getMANAnalytics().getDefaultTracker().send(builder.build());

        result.success(true);
    }


    private void trackEvent(MethodCall call, final Result result) {
        String pageName = call.argument("pageName");
        String eventName = call.argument("eventName");
        Long duration = call.argument("duration");
        Map<String, String> properties = call.argument("properties");

        MANHitBuilders.MANCustomHitBuilder builder = new MANHitBuilders.MANCustomHitBuilder(eventName);
        builder.setDurationOnEvent(duration);
        builder.setEventPage(pageName);
        builder.setProperties(properties);

        manService.getMANAnalytics().getDefaultTracker().send(builder.build());

        result.success(true);
    }

    private CommonCallback commonCallbackHandle(MethodCall call, final Result result) {
        return new CommonCallback() {
            @Override
            public void onSuccess(String response) {
                Log.d(TAG, call.method + " success => " + response);

                result.success(response);
            }

            @Override
            public void onFailed(String errorCode, String errorMessage) {
                Log.d(TAG, call.method + " fail => " + errorCode + ", erorrMessage => " + errorMessage);
                result.error(errorCode, errorMessage, null);
            }
        };
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {

    }
}
