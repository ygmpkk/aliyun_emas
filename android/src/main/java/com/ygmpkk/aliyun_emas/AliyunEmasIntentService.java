package com.ygmpkk.aliyun_emas;

import android.content.Context;
import android.os.Handler;
import android.util.Log;

import com.alibaba.sdk.android.push.AliyunMessageIntentService;
import com.alibaba.sdk.android.push.MessageReceiver;
import com.alibaba.sdk.android.push.notification.CPushMessage;

import java.util.HashMap;
import java.util.Map;


public class AliyunEmasIntentService extends MessageReceiver {
    public static final String TAG = "AliyunEmasService";
    private final Handler handler = new Handler();

    @Override
    public void onNotification(Context context, String title, String summary, Map<String, String> extraMap) {
        Log.d(TAG, "onNotification, " + title);
        final Map<String, Object> payload = new HashMap<>();
        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extraMap", extraMap);

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
        final Map<String, Object> payload = new HashMap<>();
        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extras", extraMap);

        handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("onNotificationOpened", payload));
    }

    @Override
    protected void onNotificationClickedWithNoAction(Context context, String title, String summary, String extraMap) {
        Log.d(TAG, "onNotificationClickedWithNoAction, " + title);
        final Map<String, Object> payload = new HashMap<>();
        payload.put("title", title);
        payload.put("summary", summary);
        payload.put("extras", extraMap);

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