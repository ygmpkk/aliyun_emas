package com.ygmpkk.aliyun_emas;

import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import com.alibaba.sdk.android.push.AndroidPopupActivity;

import java.util.HashMap;
import java.util.Map;

public class AliyunEmasPopupPushActivity extends AndroidPopupActivity {
  public static final String TAG = "AliyunEmasActivity";

  private final Handler handler = new Handler();

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
  }


  /**
   * 实现通知打开回调方法，获取通知相关信息
   *
   * @param title    标题
   * @param summary  内容
   * @param extraMap 额外参数
   */
  @Override
  protected void onSysNoticeOpened(String title, String summary, Map<String, String> extraMap) {
    Log.d(TAG, "OnMiPushSysNoticeOpened, title: " + title + ", content: " + summary + ", extraMap: " + extraMap);


    final Map<String, Object> payload = new HashMap<>();
    payload.put("title", title);
    payload.put("summary", summary);
    payload.put("extraMap", extraMap);

    handler.post(() -> AliyunEmasHandler.methodChannel.invokeMethod("PushNotification", payload));
  }
}
