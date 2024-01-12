import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'empactit_wifi_method_channel.dart';

abstract class EmpactitWifiPlatform extends PlatformInterface {
  /// Constructs a EmpactitWifiPlatform.
  EmpactitWifiPlatform() : super(token: _token);


  static final Object _token = Object();

  static EmpactitWifiPlatform _instance = MethodChannelEmpactitWifi();

  /// The default instance of [EmpactitWifiPlatform] to use.
  ///
  /// Defaults to [MethodChannelEmpactitWifi].
  static EmpactitWifiPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [EmpactitWifiPlatform] when
  /// they register themselves.
  static set instance(EmpactitWifiPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> connect(String ssid , String password) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
