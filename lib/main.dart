import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp( MouseControllerApp());
}

class MouseControllerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mouse Controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MouseControllerPage(),
    );
  }
}

class MouseControllerPage extends StatefulWidget {
  @override
  _MouseControllerPageState createState() => _MouseControllerPageState();
}

class _MouseControllerPageState extends State<MouseControllerPage> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io(
      'http://192.168.29.192:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );
    socket.onConnect((_) {
      print('Connected');
    });
  }

  void sendMouseEvent(String event, int dx, int dy) {
    socket.emit('mouseEvent', {'event': event, 'dx': dx, 'dy': dy});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mouse Controller'),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          int dx = details.delta.dx.round();
          int dy = details.delta.dy.round();
          sendMouseEvent('move', dx, dy);
        },
        child: Container(
          color: Colors.white,
        ),
      ),
    );
  }
}