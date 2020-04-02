import 'package:flutter_test/flutter_test.dart';
import 'package:aliyun_emas/aliyun_emas.dart';
import 'package:e2e/e2e.dart';

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can turn on push channel', (WidgetTester tester) async {
    final Push messaging = Push();
    final bool turnOn = await messaging.turnOnPushChannel();
    expect(turnOn, isTrue);
  });
}
