import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:empactit_wifi/empactit_wifi.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _result = 'Unknown';
  final _empactitWifiPlugin = EmpactitWifi();

  @override
  void initState() {
    super.initState();
    initWifi();
  }

  Future<void> initWifi() async {
    String result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      result =
          await _empactitWifiPlugin.connect("testingSSID","password") ?? 'Unknown result';
    } on PlatformException {
      result = 'Failed to connect.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Connected: $_result\n'),
        ),
      ),
    );
  }
}
