import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'empactit_wifi_platform_interface.dart';

/// An implementation of [EmpactitWifiPlatform] that uses method channels.
class MethodChannelEmpactitWifi extends EmpactitWifiPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('empactit_wifi');

  @override
  Future<String?> connect(String ssid, String password) async {
    final String channelResult = await methodChannel.invokeMethod<String>('connect', {"ssid": ssid, "password":password})??"";

    return channelResult;
  }
}
