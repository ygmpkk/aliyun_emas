
#import "AliyunEmasPlugin.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import <AlicloudMobileAnalitics/ALBBMAN.h>

// iOS 10 notification
#import <UserNotifications/UserNotifications.h>

#define CASE(str) if ([__s__ isEqualToString:(str)])
#define SWITCH(s) for (NSString *__s__ = (s);;)
#define DEFAULT

@interface AliyunEmasPlugin () <UNUserNotificationCenterDelegate>
@end

static FlutterError *getFlutterError(NSError *error) {
    if (error == nil)
        return nil;
    return [FlutterError
            errorWithCode:[NSString stringWithFormat:@"Error %ld", (long)error.code]
            message:error.domain
            details:error.localizedDescription];
}

@implementation AliyunEmasPlugin {
    // iOS 10通知中心
    UNUserNotificationCenter *_notificationCenter API_AVAILABLE(ios(10.0));
    NSMutableDictionary *_latestPayload;
    Boolean *_latestPayloadOpened;

    FlutterMethodChannel *_channel;
    ALBBMANAnalytics *_man;
}

#pragma mark - 插件处理函数

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel =
    [FlutterMethodChannel methodChannelWithName:@"ygmpkk.aliyun_emas/emas"
                                binaryMessenger:[registrar messenger]];
    AliyunEmasPlugin *instance =
    [[AliyunEmasPlugin alloc] initWithChannel:channel];

    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];

    if (self) {
        _channel = channel;
    }

    return self;
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    SWITCH(call.method) {
        CASE(@"requestNotificationPermissions") {
            [self requestNotificationPermissions:call result:result];
            break;
        }

        CASE(@"getDeviceId") {
            [self getDeviceId:call result:result];
            break;
        }

        CASE(@"turnOnPushChannel") {
            [self turnOnPushChannel:call result:result];
            break;
        }

        CASE(@"turnOffPushChannel") {
            [self turnOnPushChannel:call result:result];
            break;
        }

        CASE(@"checkPushChannelStatus") {
            [self checkPushChannelStatus:call result:result];
            break;
        }

        CASE(@"setDoNotDisturb") {
            [self setDoNotDisturb:call result:result];
            break;
        }

        CASE(@"closeDoNotDisturbMode") {
            [self closeDoNotDisturbMode:call result:result];
            break;
        }

        CASE(@"addAlias") {
            [self addAlias:call result:result];
            break;
        }

        CASE(@"removeAlias") {
            [self removeAlias:call result:result];
            break;
        }

        CASE(@"bindAccount") {
            [self bindAccount:call result:result];
            break;
        }

        CASE(@"unbindAccount") {
            [self unbindAccount:call result:result];
            break;
        }

        CASE(@"bindPhoneNumber") {
            [self bindPhoneNumber:call result:result];
            break;
        }

        CASE(@"unbindPhoneNumber") {
            [self unbindPhoneNumber:call result:result];
            break;
        }

        CASE(@"bindTag") {
            [self bindTag:call result:result];
            break;
        }

        CASE(@"unbindTag") {
            [self unbindTag:call result:result];
            break;
        }

        CASE(@"setLogLevel") {
            [self setLogLevel:call result:result];
            break;
        }

        CASE(@"setDebug") {
            [self setDebug:call result:result];
            break;
        }

        CASE(@"clearNotifications") {
            [self clearNotifications:call result:result];
            break;
        }

        CASE(@"getNotificationSettingStatus") {
            [self getNotificationSettingStatus:call result:result];
            break;
        }

        CASE(@"openAppSettings") {
            [self openAppSettings:call result:result];
            break;
        }

        CASE(@"userRegister") {
            [self userRegister:call result:result];
            break;
        }

        CASE(@"updateUserAccount") {
            [self updateUserAccount:call result:result];
            break;
        }

        CASE(@"pageAppear") {
            [self pageAppear:call result:result];
            break;
        }

        CASE(@"pageDisAppear") {
            [self pageDisAppear:call result:result];
            break;
        }

        CASE(@"updatePageProperties") {
            [self updatePageProperties:call result:result];
            break;
        }

        CASE(@"trackPage") {
            [self trackPage:call result:result];
            break;
        }

        CASE(@"trackEvent") {
            [self trackEvent:call result:result];
            break;
        }

        CASE(@"getLatestPushNotificationOpened") {
            [self getLatestPushNotificationOpened:call result:result];
            break;
        }

        DEFAULT {
            result(FlutterMethodNotImplemented);
            break;
        }
    }
}

- (void)getLatestPushNotificationOpened:(FlutterMethodCall *)call result:(FlutterResult)result {
    result(_latestPayload);
    _latestPayload = nil;
    _latestPayloadOpened = true;
}

- (void)requestNotificationPermissions:(FlutterMethodCall *)call
                                result:(FlutterResult)result {
    [self registerAPNS:call result:result];
}

- (void)getDeviceId:(FlutterMethodCall *)call result:(FlutterResult)result {
    result([CloudPushSDK getDeviceId]);
}

- (void)turnOnPushChannel:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
}

- (void)turnOffPushChannel:(FlutterMethodCall *)call
                    result:(FlutterResult)result {
}

- (void)checkPushChannelStatus:(FlutterMethodCall *)call
                        result:(FlutterResult)result {
}

- (void)setDoNotDisturb:(FlutterMethodCall *)call result:(FlutterResult)result {
}

- (void)closeDoNotDisturbMode:(FlutterMethodCall *)call
                       result:(FlutterResult)result {
}

- (void)addAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
    [CloudPushSDK addAlias:call.arguments[@"aliasId"]
              withCallback:[self commonCallbackHandle:call result:result]];
}

- (void)removeAlias:(FlutterMethodCall *)call result:(FlutterResult)result {
    [CloudPushSDK removeAlias:call.arguments[@"aliasId"]
                 withCallback:[self commonCallbackHandle:call result:result]];
}

- (void)bindAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    [CloudPushSDK bindAccount:call.arguments[@"userId"]
                 withCallback:[self commonCallbackHandle:call result:result]];
}

- (void)unbindAccount:(FlutterMethodCall *)call result:(FlutterResult)result {
    [CloudPushSDK unbindAccount:[self commonCallbackHandle:call result:result]];
}

- (void)bindPhoneNumber:(FlutterMethodCall *)call result:(FlutterResult)result {
}

- (void)unbindPhoneNumber:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
}

- (void)bindTag:(FlutterMethodCall *)call result:(FlutterResult)result {
    int target = (int)call.arguments[@"target"];
    [CloudPushSDK bindTag:target
                 withTags:call.arguments[@"tags"]
                withAlias:call.arguments[@"aliasId"]
             withCallback:[self commonCallbackHandle:call result:result]];
}

- (void)unbindTag:(FlutterMethodCall *)call result:(FlutterResult)result {
    int target = (int)call.arguments[@"target"];
    [CloudPushSDK unbindTag:target
                   withTags:call.arguments[@"tags"]
                  withAlias:call.arguments[@"aliasId"]
               withCallback:[self commonCallbackHandle:call result:result]];
}

- (void)setLogLevel:(FlutterMethodCall *)call result:(FlutterResult)result {
}

- (void)setDebug:(FlutterMethodCall *)call result:(FlutterResult)result {
    [CloudPushSDK turnOnDebug];
}

- (void)clearNotifications:(FlutterMethodCall *)call
                    result:(FlutterResult)result {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self syncBadgeNumber:0];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)userRegister:(FlutterMethodCall *)call result:(FlutterResult)result {
     NSString *userId = call.arguments[@"userId"];
     [_man userRegister:userId];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)updateUserAccount:(FlutterMethodCall *)call
                   result:(FlutterResult)result {
     NSString *userId = call.arguments[@"userId"];
     NSString *username = call.arguments[@"username"];
     [_man updateUserAccount:username userid:userId];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)pageAppear:(FlutterMethodCall *)call result:(FlutterResult)result {
    //    [[ALBBMANPageHitHelper getInstance] pageAppear:self];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)pageDisAppear:(FlutterMethodCall *)call result:(FlutterResult)result {
    //    [[ALBBMANPageHitHelper getInstance] pageDisAppear:self];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)updatePageProperties:(FlutterMethodCall *)call
                      result:(FlutterResult)result {
    //    [[ALBBMANPageHitHelper getInstance] updatePageProperties:self
    //    properties:properties];
    result([NSNumber numberWithBool:TRUE]);
}

- (void)trackPage:(FlutterMethodCall *)call result:(FlutterResult)result {
     ALBBMANPageHitBuilder *builder = [[ALBBMANPageHitBuilder alloc] init];
     NSString *pageName = call.arguments[@"pageName"];
     NSString *referrer = call.arguments[@"referrer"];
     NSNumber *duration = call.arguments[@"duration"];
     NSDictionary *properties = call.arguments[@"properties"];

     [builder setPageName:pageName];
     if(referrer != (NSString *)[NSNull null]) {
         [builder setReferPage:referrer];
     }
     if (duration != (NSNumber *)[NSNull null]) {
         [builder setDurationOnPage:duration.longValue];
     }
     if (properties != (NSDictionary *)[NSNull null]) {
        NSLog(@"trackPage has properties: %d", properties != nil );
         [builder setProperties:properties];
     }

       ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
       [tracker send:[builder build]];

    result([NSNumber numberWithBool:TRUE]);
}

- (void)trackEvent:(FlutterMethodCall *)call result:(FlutterResult)result {
     ALBBMANCustomHitBuilder *builder = [[ALBBMANCustomHitBuilder alloc] init];
     NSString *pageName = call.arguments[@"pageName"];
     NSString *eventName = call.arguments[@"eventName"];
     NSNumber *duration = call.arguments[@"duration"];
     NSDictionary *properties = call.arguments[@"properties"];

     [builder setEventLabel:eventName];

     if( pageName != (NSString *)[NSNull null]) {
     [builder setEventPage:pageName];
     }

     if (duration != (NSNumber *)[NSNull null]) {
         [builder setDurationOnEvent:duration.longValue];
     }

     if(properties != (NSDictionary *)[NSNull null]) {
     [builder setProperties:properties];
     }

     ALBBMANTracker *tracker = [[ALBBMANAnalytics getInstance] getDefaultTracker];
     [tracker send:[builder build]];

    result([NSNumber numberWithBool:TRUE]);
}

- (id)commonCallbackHandle:(FlutterMethodCall *)call
                    result:(FlutterResult)result {
    return ^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"%@ success", call.method);
            result(res.data);
        } else {
            NSLog(@"%@ failed", call.method);
            result(getFlutterError(res.error));
        }
    };
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"didFinishLaunchingWithOptions");

    // TODO 等网络
    //    [CloudPushSDK turnOnDebug];

    [CloudPushSDK autoInit:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.",
                  [CloudPushSDK getDeviceId]);
            [self->_channel invokeMethod:@"onIosInit"
                               arguments:[CloudPushSDK getDeviceId]];
        } else {
            NSLog(@"Push SDK init failed, error: %@.", res.error);
        }
    }];

    // 监听推送通道打开动作
    [self listenerOnChannelOpened];

    // 监听推送消息到达
    [self registerMessageReceive];

    // 点击通知将App从关闭状态启动时，将通知打开回执上报
    [CloudPushSDK sendNotificationAck:launchOptions];

    // Mobile Analysis
     _man = [ALBBMANAnalytics getInstance];
//    [_man turnOnDebug];
     [_man autoInit];

    //    [man setAppVersion: @""];
    //    [man setChannel: @""];

    return YES;
}


#pragma mark - APNs Register

- (void)registerAPNS:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;

    if (@available(iOS 10.0, *)) {
        UNAuthorizationOptions authOptions = 0;
        NSNumber *provisional = arguments[@"provisional"];
        if ([arguments[@"sound"] boolValue]) {
            authOptions |= UNAuthorizationOptionSound;
        }
        if ([arguments[@"alert"] boolValue]) {
            authOptions |= UNAuthorizationOptionAlert;
        }
        if ([arguments[@"badge"] boolValue]) {
            authOptions |= UNAuthorizationOptionBadge;
        }

        NSNumber *isAtLeastVersion12;
        if (@available(iOS 12, *)) {
            isAtLeastVersion12 = [NSNumber numberWithBool:YES];
            if ([provisional boolValue])
                authOptions |= UNAuthorizationOptionProvisional;
        } else {
            isAtLeastVersion12 = [NSNumber numberWithBool:NO];
        }

        NSLog(@"UNAuthorizationOptions: %lu.", (unsigned long)authOptions);

        // 请求推送权限
        _notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [_notificationCenter
         requestAuthorizationWithOptions:authOptions
         completionHandler:^(BOOL granted,
                             NSError *_Nullable error) {
            if (error) {
                result(getFlutterError(error));
                return;
            }

            NSLog(@"granted: %d.", granted);

            [[UNUserNotificationCenter currentNotificationCenter]
             getNotificationSettingsWithCompletionHandler:^(
                                                            UNNotificationSettings *_Nonnull settings) {
                NSDictionary *settingsDictionary = @{
                    @"sound" :
                        [NSNumber numberWithBool:
                         settings.soundSetting ==
                         UNNotificationSettingEnabled],
                    @"badge" :
                        [NSNumber numberWithBool:
                         settings.badgeSetting ==
                         UNNotificationSettingEnabled],
                    @"alert" :
                        [NSNumber numberWithBool:
                         settings.alertSetting ==
                         UNNotificationSettingEnabled],
                    @"provisional" : [NSNumber
                                      numberWithBool:granted &&
                                      [provisional boolValue] &&
                                      isAtLeastVersion12],
                };
                [self->_channel
                 invokeMethod:@"onIosSettingsRegistered"
                 arguments:settingsDictionary];
            }];

            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication]
                 registerForRemoteNotifications];
            });

            result([NSNumber numberWithBool:granted]);
        }];
    } else if (@available(iOS 8.0, *)) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIUserNotificationType notificationTypes = 0;
        if ([arguments[@"sound"] boolValue]) {
            notificationTypes |= UIUserNotificationTypeSound;
        }
        if ([arguments[@"alert"] boolValue]) {
            notificationTypes |= UIUserNotificationTypeAlert;
        }
        if ([arguments[@"badge"] boolValue]) {
            notificationTypes |= UIUserNotificationTypeBadge;
        }

        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:notificationTypes
                                          categories:nil];
        [[UIApplication sharedApplication]
         registerUserNotificationSettings:settings];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] registerForRemoteNotifications];
        });
        result([NSNumber numberWithBool:YES]);
#pragma clang diagnostic pop
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        UIRemoteNotificationType notificationTypes = 0;
        if ([arguments[@"sound"] boolValue]) {
            notificationTypes |= UIRemoteNotificationTypeSound;
        }
        if ([arguments[@"alert"] boolValue]) {
            notificationTypes |= UIRemoteNotificationTypeAlert;
        }
        if ([arguments[@"badge"] boolValue]) {
            notificationTypes |= UIRemoteNotificationTypeBadge;
        }

        [[UIApplication sharedApplication]
         registerForRemoteNotificationTypes:notificationTypes];

        result([NSNumber numberWithBool:YES]);
#pragma clang diagnostic pop
    }
}

#pragma mark - 注册DeviceToken

// APNs注册成功回调，将返回的deviceToken上传到CloudPush服务器
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Upload deviceToken to CloudPush server.");

    [CloudPushSDK
     registerDevice:deviceToken
     withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register device token success, deviceToken: %@.",
                  [CloudPushSDK getApnsDeviceToken]);
            [self->_channel invokeMethod:@"onToken"
                               arguments:[CloudPushSDK getApnsDeviceToken]];
        } else {
            NSLog(@"Register device token failed, error: %@.", res.error);
        }
    }];
}

/**
 *  主动获取设备通知是否授权(iOS 10+)
 */
- (void)getNotificationSettingStatus:(FlutterMethodCall *)call
                              result:(FlutterResult)result {
    NSLog(@"getNotificationSettingStatus");
    if (@available(iOS 10.0, *)) {
        [_notificationCenter getNotificationSettingsWithCompletionHandler:^(
                                                                            UNNotificationSettings *_Nonnull settings) {
            // TODO 如果用户拒绝，需要有一个方法引导用户去设置打开通知
//            NSLog(@"settings.authorizationStatus %lu.", settings.authorizationStatus);
            result([NSNumber numberWithBool:settings.authorizationStatus ==
                    UNAuthorizationStatusAuthorized]);
        }];
    } else {
        // Fallback on earlier versions
        result(nil);
    }
}

/*
 *  APNs注册失败回调
 */
- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *  处理iOS 10通知(iOS 10+)
 */
- (void)handleNotificationOpened:(UNNotification *)notification
API_AVAILABLE(ios(10.0)) {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSDictionary *extras = [userInfo valueForKey:@"Extras"];

    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    [self syncBadgeNumber:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];

    NSLog(@"handleNotificationOpened: %@.", content);
    NSLog(@"handleNotificationOpened: %@.", userInfo);

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setValue:content.title forKey:@"title"];
    [payload setValue:content.body forKey:@"summary"];
    [payload setValue:content.badge forKey:@"badge"];

    if (extras != nil) {
        [payload setObject:extras forKey:@"extras"];
    }

    UIApplicationState applicationState = [[UIApplication sharedApplication] applicationState];
    if (applicationState == UIApplicationStateInactive && _latestPayloadOpened != true) {
        _latestPayload = payload;
    }

     [_channel invokeMethod:@"onNotificationOpened" arguments:payload];
}

- (void)handleNotificationRemoved:(UNNotification *)notification
API_AVAILABLE(ios(10.0)) {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSDictionary *extras = [userInfo valueForKey:@"Extras"];

    NSLog(@"handleNotificationRemoved: %@.", content);
    NSLog(@"handleNotificationRemoved: %@.", userInfo);

//    if (extras == nil) {
//        extras = @{};
//    }

    // 修改角标
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //    NSInteger badgeNumber = [UIApplication
    //    sharedApplication].applicationIconBadgeNumber - 1; [UIApplication
    //    sharedApplication].applicationIconBadgeNumber = badgeNumber;
    //    // 同步角标数到服务端
    [self syncBadgeNumber:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];

    NSLog(@"handleNotificationRemoved: %@.", content);

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setValue:content.title forKey:@"title"];
    [payload setValue:content.body forKey:@"summary"];
    [payload setValue:content.badge forKey:@"badge"];

    if (extras != nil) {
        [payload setObject:extras forKey:@"extras"];
    }

    [_channel invokeMethod:@"onNotificationRemoved" arguments:payload];
}

- (void)handleNotificationReceivedInApp:(UNNotification *)notification
API_AVAILABLE(ios(10.0)) {
    UNNotificationRequest *request = notification.request;
    UNNotificationContent *content = request.content;
    NSDictionary *userInfo = content.userInfo;
    NSDictionary *extras = [userInfo valueForKey:@"Extras"];

    NSLog(@"handleNotificationReceivedInApp: %@.", content);
    NSLog(@"handleNotificationReceivedInApp: %@.", userInfo);

    // 通知角标数清0
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    // 同步角标数到服务端
    [self syncBadgeNumber:0];
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];

    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    [payload setValue:content.title forKey:@"title"];
    [payload setValue:content.body forKey:@"summary"];
    [payload setValue:content.badge forKey:@"badge"];

    if (extras != nil) {
        [payload setObject:extras forKey:@"extras"];
    }

    NSLog(@"handleNotificationReceivedInApp: %@.", payload);

    [_channel invokeMethod:@"onNotificationReceivedInApp" arguments:payload];
}

// App处于前台时收到通知(iOS 10+)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:
(void (^)(UNNotificationPresentationOptions))completionHandler
API_AVAILABLE(ios(10.0)) {
    NSLog(@"willPresentNotification");

    [self handleNotificationReceivedInApp:notification];

    // 通知弹出，且带有声音、内容和角标
    completionHandler(UNNotificationPresentationOptionSound |
                      UNNotificationPresentationOptionAlert |
                      UNNotificationPresentationOptionBadge);
}

// 触发通知动作时回调，比如点击、删除通知和点击自定义action(iOS 10+)
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)(void))completionHandler
API_AVAILABLE(ios(10.0)) {
    NSLog(@"didReceiveNotificationResponse");
    NSString *userAction = response.actionIdentifier;
    // 点击通知打开
    if ([userAction isEqualToString:UNNotificationDefaultActionIdentifier]) {
        NSLog(@"User opened the notification.");
        // 处理iOS 10通知，并上报通知打开回执
        [self handleNotificationOpened:response.notification];
    }

    // 通知dismiss，category创建时传入UNNotificationCategoryOptionCustomDismissAction才可以触发
    if ([userAction isEqualToString:UNNotificationDismissActionIdentifier]) {
        NSLog(@"User dismissed the notification.");
        [self handleNotificationRemoved:response.notification];
    }

    completionHandler();
}

#pragma mark Notification Open

// App处于启动状态时，通知打开回调
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Receive one notification. %@.", userInfo);
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSDictionary *extras = [userInfo valueForKey:@"Extras"];

    application.applicationIconBadgeNumber = 0;
    // 同步通知角标数到服务端
    // [self syncBadgeNum:0];
    [CloudPushSDK sendNotificationAck:userInfo];

    NSDictionary *payload = @{
        @"title" : [aps valueForKey:@"title"],
        @"summary" : [aps valueForKey:@"alert"],
        @"badge" : [aps valueForKey:@"badge"],
    };

    if (extras != nil) {
        [payload setValue:extras forKey:@"extras"];
    }

    [_channel invokeMethod:@"onNotificationOpened" arguments:payload];
}

#pragma mark Channel Opened

// 注册推送通道打开监听
- (void)listenerOnChannelOpened {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onChannelOpened:)
     name:@"CCPDidChannelConnectedSuccess"
     object:nil];
}

// 推送通道打开回调
- (void)onChannelOpened:(NSNotification *)notification {
    NSLog(@"消息通道建立成功");
}

#pragma mark Receive Message

// 注册推送消息到来监听
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(onMessageReceived:)
     name:@"CCPDidReceiveMessageNotification"
     object:nil];
}

// 处理到来推送消息
- (void)onMessageReceived:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"onMessageReceived %@.", [userInfo valueForKey:@"Extras"]);

    CCPSysMessage *message = [notification object];
    NSLog(@"Receive message: %i.", message.messageType);

    NSDictionary *payload = @{
        //        @"messageId": notification
        @"title" : [[NSString alloc] initWithData:message.title
                                         encoding:NSUTF8StringEncoding],
        @"content" : [[NSString alloc] initWithData:message.body
                                           encoding:NSUTF8StringEncoding],
    };


    NSLog(@"onMessageReceived payload %@.", payload);


    [_channel invokeMethod:@"onMessage" arguments:payload];
}

// 同步角标数量
- (void)syncBadgeNumber:(NSUInteger)badgeNum {
    [CloudPushSDK
     syncBadgeNum:badgeNum
     withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Sync badge num: [%lu] success.", (unsigned long)badgeNum);
        } else {
            NSLog(@"Sync badge num: [%lu] failed, error: %@",
                  (unsigned long)badgeNum, res.error);
        }
    }];
}

#pragma mark - 打开系统设置

- (void)openSystemScheme:(NSString *)path {
    UIApplication *application = [UIApplication sharedApplication];
    // prefs:root=NOTIFICATIONS_ID&path={identifier}
    NSURL *uri = [NSURL URLWithString:path];

    if ([application canOpenURL:uri]) {
        [application openURL:uri];
    } else {
        [self->_channel
         invokeMethod:@"onError"
         arguments:@{
             @"code" : @"openSystemScheme:canOpenURL",
             @"message" : [NSString stringWithFormat:@"无法打开 %@", path],
         }];
    }
}

- (void)openAppSettings:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *path = @"app-settings:";
    [self openSystemScheme:path];
}

@end
