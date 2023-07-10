import 'package:flutter/material.dart';
import 'package:syncpad/touchpad_screen.dart';
import 'package:syncpad/welcome_screen.dart';

void main() {
  runApp(MouseControllerApp());
}

class MouseControllerApp extends StatefulWidget {
  @override
  _MouseControllerAppState createState() => _MouseControllerAppState();
}

class _MouseControllerAppState extends State<MouseControllerApp> {
  String? ipAddress;

  void setIPAddress(String ip) {
    setState(() {
      ipAddress = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    if (ipAddress == null) {
      screen = WelcomeScreen(onIPSubmit: setIPAddress);
    } else {
      screen = TouchpadScreen(ipAddress: ipAddress!);
    }

    return MaterialApp(
      title: 'SYNCPAD',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: screen,
      debugShowCheckedModeBanner: false,
    );
  }
}
