package com.ygmpkk.aliyun_emas;

import android.content.Context;
import android.os.Handler;
import android.util.Log;

import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;
import com.google.gson.Gson;


import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;


public class AliyunEmasIntentService extends MessageReceiver {
    public static final String TAG = "AliyunEmasService";
    private final Handler handler = new Handler();

    @Override
    public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
        Log.d(TAG, "onNotification, " + title);
        Log.d(TAG, "onNotification, " + summary);
        Log.d(TAG, "onNotification, " + extraMap);
        final Map<String, Object> payload = new HashMap<>();

        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extraMap", extraMap);

        // TODO Android实现角标
        // 华为没有角标
        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotification", payload));
    }

    @Override
    public void onMessage(Context context, CPushMessage cPushMessage) {
        Log.d(TAG, "onMessage, " + cPushMessage.getMessageId() + ", title: " + cPushMessage.getTitle());
        final Map<String, Object> payload = new HashMap<>();
        payload.put("messageId", cPushMessage.getMessageId());
        payload.put("appId", cPushMessage.getAppId());
        payload.put("title", cPushMessage.getTitle());
        payload.put("content", cPushMessage.getContent());
        payload.put("traceInfo", cPushMessage.getTraceInfo());

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onMessage", payload));
    }

    @Override
    public void onNotificationOpened(Context context, String title, String summary, String extraMap) {
        Log.d(TAG, "onNotificationOpened, " + title);
//        Log.d(TAG, "onNotificationOpened, " + summary);
//        Log.d(TAG, "onNotificationOpened, " + extraMap);

        String openUrl = null;

        final Map<String, Object> payload = new HashMap<>();
        try {
            openUrl = new JSONObject(extraMap).getString("openUrl");
        } catch (JSONException e) {
            Log.e(TAG, e.getMessage());
        }

        final Map<String, Object> extras = new HashMap<>();
        extras.put("openUrl", openUrl);
//        Log.d(TAG, "onNotificationOpened, " + extras.toString());

        payload.put("title", title);
        payload.put("summary", summary);

        payload.put("extras", extras);
//        Log.d(TAG, "onNotificationOpened, " + payload.toString());

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotificationOpened", payload));
    }

    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        Log.d(TAG, "onNotificationClickedWithNoAction, " + title);
        final Map<String, Object> payload = new HashMap<>();
        final AliyunEmasExtraMap aliyunEmasExtraMap = new Gson().fromJson(extraMap, AliyunEmasExtraMap.class);
        final Map<String, Object> extras = new HashMap<>();
        extras.put("openUrl", aliyunEmasExtraMap.getOpenUrl());

        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extras", extras);

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotificationClickedWithNoAction", payload));
    }

    @Override
    protected void onNotificationReceivedInApp(Context context, String title, String summary, Map<String, String> extraMap, int openType, String openActivity, String openUrl) {
        Log.d(TAG, "onNotificationReceivedInApp, " + title);
        final Map<String, Object> payload = new HashMap<>();

        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extras", extraMap);
        payload.put("openType", openType);
        payload.put("openActivity", openActivity);
        payload.put("openUrl", openUrl);

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotificationReceivedInApp", payload));
    }

    @Override
    protected void onNotificationRemoved(Context context, String messageId) {
        Log.d(TAG, "onNotificationRemoved," + messageId);
        final Map<String, Object> payload = new HashMap<>();
        payload.put("messageId", messageId);

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotificationRemoved", payload));
    }
}