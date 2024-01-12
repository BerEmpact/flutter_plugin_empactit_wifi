import 'package:flutter_test/flutter_test.dart';
import 'package:empactit_wifi/empactit_wifi.dart';
import 'package:empactit_wifi/empactit_wifi_platform_interface.dart';
import 'package:empactit_wifi/empactit_wifi_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockEmpactitWifiPlatform
    with MockPlatformInterfaceMixin
    implements EmpactitWifiPlatform {

  @override
  Future<String?> connect(String ssid, String password) => Future.value('Unknow');
}

void main() {
  final EmpactitWifiPlatform initialPlatform = EmpactitWifiPlatform.instance;

  test('$MethodChannelEmpactitWifi is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelEmpactitWifi>());
  });

  test('connect', () async {
    EmpactitWifi empactitWifiPlugin = EmpactitWifi();
    MockEmpactitWifiPlatform fakePlatform = MockEmpactitWifiPlatform();
    EmpactitWifiPlatform.instance = fakePlatform;

    expect(await empactitWifiPlugin.connect("testingSSID", "password"), 'Unknow');
  });
}
