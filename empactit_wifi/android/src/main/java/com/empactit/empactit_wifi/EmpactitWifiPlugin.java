package com.empactit.empactit_wifi;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import android.os.PatternMatcher;
import android.net.NetworkRequest;
import android.net.NetworkCapabilities;
import android.net.wifi.WifiNetworkSpecifier;
import android.net.wifi.WifiNetworkSuggestion;
import android.content.Context;
import android.net.ConnectivityManager;
import android.net.Network;
import android.net.wifi.WifiConfiguration;
import android.net.wifi.WifiManager;
import android.net.wifi.hotspot2.PasspointConfiguration;
import android.net.wifi.hotspot2.pps.Credential.UserCredential;
import android.net.wifi.hotspot2.pps.Credential;
import android.os.Bundle;
import android.provider.Settings;
import android.os.Parcelable;
import android.content.Intent;
import android.net.ConnectivityManager.NetworkCallback;

/** EmpactitWifiPlugin */
public class EmpactitWifiPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "empactit_wifi");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("connect")) {
      String ssid = call.argument("ssid");
      String password = call.argument("password");
      Log.d("wifi","connecting to wifi  " + ssid);
      result.success(connectWifi(ssid,password));
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }


  private String connectWifi(String ssid, String password){

    String result = "";

    Log.d("wifi","connectWifi API LEVEL: " + android.os.Build.VERSION.SDK_INT);

    if(android.os.Build.VERSION.SDK_INT < 29){
      Log.d("wifi","android.os.Build.VERSION.SDK_INT < 29");
      result = "OldAPI";
            /*
            var networkSSID = ssid;
            var networkPass = password;
            var conf = new WifiConfiguration();
            conf.SSID = "\"" + networkSSID + "\""
            conf.preSharedKey = "\""+ networkPass +"\""
            var wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
            var netid = wifiManager.addNetwork(conf)
            wifiManager.disconnect()
            wifiManager.enableNetwork(netid, true)
            wifiManager.reconnect()
            return ssid.length*/
    }

    if(android.os.Build.VERSION.SDK_INT == 29){
      Log.d("wifi","android.os.Build.VERSION.SDK_INT == 29");
      if(addWifiToSuggestionList(ssid,password)){
        result = "SuggestedAPI_29";
      }else{
        result = "ERROR";
      }
    }

    if(android.os.Build.VERSION.SDK_INT > 29){
      Log.d("wifi","android.os.Build.VERSION.SDK_INT >= 30");
      if( addWifiToSuggestionList(ssid,password) ){
        result = "SuggestedAPI_30";
      }else{
        result = "ERROR";
      }
    }
    return result;

  }
  public void bindProcessToNetwork(Network network,ConnectivityManager connectivityManager) {
    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP) {

      if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
        connectivityManager.bindProcessToNetwork(network);
      } else {
        connectivityManager.setProcessDefaultNetwork(network);
      }
    }
  }
  private boolean addWifiToSuggestionList(String ssid, String password){
    boolean result = true;
    if(android.os.Build.VERSION.SDK_INT >= 29){
      Log.d("wifi","building wifiNetworkSuggestion");
      final WifiNetworkSuggestion suggestion2 =
              new WifiNetworkSuggestion.Builder()
                      .setSsid(ssid)
                      .setWpa2Passphrase(password)
                      .setIsAppInteractionRequired(true) // Optional (Needs location permission)
                      .build();

      ArrayList<WifiNetworkSuggestion> arraySug = new ArrayList<WifiNetworkSuggestion>();
      arraySug.add(suggestion2);
      final List<WifiNetworkSuggestion> suggestionsList =arraySug;

      final WifiManager wifiManager =
              (WifiManager) context.getSystemService(Context.WIFI_SERVICE);

      final int status = wifiManager.addNetworkSuggestions(suggestionsList);
      if (status != WifiManager.STATUS_NETWORK_SUGGESTIONS_SUCCESS) {
        // do error handling here…
        Log.d("wifi","building wifiNetworkSuggestion error: " + status);
        result = false;
      }else{
        Log.d("wifi","building wifiNetworkSuggestion status: " + status);
      }
    }
    return result;

  }
  /*
  private fun getTest(ssid: String): Int {
      if(android.os.Build.VERSION.SDK_INT >= 29)
      {
          val specifier = WifiNetworkSpecifier.Builder()
          // .setSsidPattern(PatternMatcher("SSID", PatternMatcher.PATTERN_PREFIX))
          .setSsid(ssid)
          .setWpa2Passphrase("Your_Password")
          .build()
      val request = NetworkRequest.Builder()
          .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
          .setNetworkSpecifier(specifier)
          .build()
          val connectivityManager = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

      connectivityManager.requestNetwork(request, mNetworkCallback)
      // Release the request when done.
      //
      return 123
      }
      else {
          var networkSSID = ssid;
          var networkPass = "Your_Password";
          var conf = WifiConfiguration()
          conf.SSID = "\"" + networkSSID + "\""
          conf.preSharedKey = "\""+ networkPass +"\""
          var wifiManager = context.getSystemService(Context.WIFI_SERVICE) as WifiManager
          var netid = wifiManager.addNetwork(conf)
          wifiManager.disconnect()
          wifiManager.enableNetwork(netid, true)
          wifiManager.reconnect()
          return ssid.length

      }

  }
  * */
  private boolean addPasspoint(String ssid, String password){
    boolean result = true;
    if(android.os.Build.VERSION.SDK_INT >= 30){
      Log.d("wifi","building wifiNetworkSuggestion with Passpoint");
    }
    return result;

  }
}
