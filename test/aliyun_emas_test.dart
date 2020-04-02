import 'dart:async';

import 'package:platform/platform.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_emas/aliyun_emas.dart';
import 'package:mockito/mockito.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  MockMethodChannel mockChannel;
  Push push;

  setUp(() {
    mockChannel = MockMethodChannel();
    push = Push.private(mockChannel, FakePlatform(operatingSystem: 'ios'));
  });

  tearDown(() {
    mockChannel.setMockMethodCallHandler(null);
  });

  test('requestNotificationPermissions on ios with default permissions', () {
    push.requestNotificationPermissions();
    verify(mockChannel.invokeMethod<void>(
        'requestNotificationPermissions', <String, bool>{
      'sound': true,
      'badge': true,
      'alert': true,
      'provisional': false
    }));
  });

  test('requestNotificationPermissions on ios with custom permissions', () {
    push.requestNotificationPermissions(
        const IosNotificationSettings(sound: false, provisional: true));
    verify(mockChannel.invokeMethod<void>(
        'requestNotificationPermissions', <String, bool>{
      'sound': false,
      'badge': true,
      'alert': true,
      'provisional': true
    }));
  });

  test('requestNotificationPermissions on android', () {
    push = Push.private(mockChannel, FakePlatform(operatingSystem: 'android'));

    push.requestNotificationPermissions();
    verifyZeroInteractions(mockChannel);
  });

  test('requestNotificationPermissions on android', () {
    push = Push.private(mockChannel, FakePlatform(operatingSystem: 'android'));

    push.requestNotificationPermissions();
    verifyZeroInteractions(mockChannel);
  });

  test('configure', () {
    push.configure();
    verify(mockChannel.setMethodCallHandler(any));
    verify(mockChannel.invokeMethod<void>('configure'));
  });

  test('get deviceId', () {
    push.getDeviceId;
    verify(mockChannel.invokeMethod<String>('getDeviceId'));
  });

  test('incoming messages', () async {
    final Completer<dynamic> onMessage = Completer<dynamic>();
    final Completer<dynamic> onLaunch = Completer<dynamic>();
    final Completer<dynamic> onResume = Completer<dynamic>();

    push.configure(
      onMessage: (dynamic m) async {
        onMessage.complete(m);
      },
    );
    final dynamic handler =
        verify(mockChannel.setMethodCallHandler(captureAny)).captured.single;

    final Map<String, dynamic> onMessageMessage = <String, dynamic>{};

    await handler(MethodCall('onMessage', onMessageMessage));

    expect(await onMessage.future, onMessageMessage);
    expect(onLaunch.isCompleted, isFalse);
    expect(onResume.isCompleted, isFalse);
  });
}

class MockMethodChannel extends Mock implements MethodChannel {}
