import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'empactit_wifi_platform_interface.dart';

class EmpactitWifi {

  static const String successResponse = "CONNECTED";
  static const String errorResponse = "ERROR";
  static const String suggestedNotificationResponse = "SUGGESTED_WIFI_NOTIFICATION";
  static const String suggestedPopupResponse = "SUGGESTED_WIFI_POPUP";
  static const String addResponse = "ADD_WIFI";

  Future<String?> connect(String ssid, String password) {

    if(Platform.isIOS){
      return _connectToWifiIOS(ssid,password);
    }else{
      return _connectToWifiAndroid(ssid, password);
    }

  }

  Future<String> _connectToWifiIOS(String ssid, String password) async{
    bool result = await WiFiForIoTPlugin.connect(
        ssid,
        password: password,
        joinOnce: true,
        withInternet:true,
        security: NetworkSecurity.WPA);

    return (result==true)?EmpactitWifi.successResponse:EmpactitWifi.errorResponse;
  }

  Future<String> _connectToWifiAndroid(String ssid, String password) async{
    String channelResult = await EmpactitWifiPlatform.instance.connect(ssid, password)??"";
    var result = "";

    debugPrint("channel result: " + channelResult);
    if(channelResult == "OldAPI"){
      //logger.d(("Connecting through the flutter Wifi iot plugin"));
      bool resultPlugin = await WiFiForIoTPlugin.connect(
          ssid,
          password: password,
          joinOnce: true,
          withInternet:true,
          security: NetworkSecurity.WPA);

      result = (resultPlugin==true)?EmpactitWifi.successResponse:EmpactitWifi.errorResponse;

    }else if(channelResult == "SuggestedAPI_29"){
      result = EmpactitWifi.suggestedNotificationResponse;
    }else if(channelResult == "SuggestedAPI_30"){
      result = EmpactitWifi.suggestedPopupResponse;
    }else{
      result = EmpactitWifi.errorResponse;
    }
    debugPrint(" result: " + result);

    return result;
  }
}