package com.ygmpkk.aliyun_emas_example;

import com.alibaba.sdk.android.push.register.MiPushRegister;
import com.ygmpkk.aliyun_emas.AliyunEmasApplication;

import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    public void onCreate() {
        super.onCreate();

        AliyunEmasApplication.init(this, getApplicationContext());
//        MiPushRegister.register(this, "2882303761518360587", "5891836049587");
    }
}


/**
 * 推送测试
 * <p>
 * AI分时宝
 * 保隆科技(603197)在14点30分出现买点信号，当前价格30.30元(-3.07%)，立即查看
 * <p>
 * com.ygmpkk.aliyun_emas_example.MainActivity
 */