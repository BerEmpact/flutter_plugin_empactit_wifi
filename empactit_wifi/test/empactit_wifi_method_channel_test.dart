import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:empactit_wifi/empactit_wifi_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelEmpactitWifi platform = MethodChannelEmpactitWifi();
  const MethodChannel channel = MethodChannel('empactit_wifi');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('connect', () async {
    expect(await platform.connect("testingSSID", "password"), 'Unkown');
  });
}
