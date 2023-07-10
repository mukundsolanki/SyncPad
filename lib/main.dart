import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MouseControllerApp());
}

class MouseControllerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SYNCPAD',
      theme: ThemeData(
        primarySwatch:  Colors.teal
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
  final double tapMaxDistance =
      20; // Maximum distance in pixels for a tap to be considered

  Offset? tapPosition;
  bool isDoubleTap = false;

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

  void sendMouseAction(String action) {
    socket.emit('mouseAction', {'action': action});
  }

  void handleTapUp(TapUpDetails details) {
    if (isDoubleTap) {
      sendMouseAction('right_click');
      isDoubleTap = false;
    } else {
      tapPosition = details.globalPosition;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (tapPosition != null) {
          final dx = (details.globalPosition.dx - tapPosition!.dx).abs();
          final dy = (details.globalPosition.dy - tapPosition!.dy).abs();
          if (dx <= tapMaxDistance && dy <= tapMaxDistance) {
            sendMouseAction('left_click');
          }
        }
        tapPosition = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('SyncPad')),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: handleTapUp,
                onDoubleTap: () {
                  isDoubleTap = true;
                  sendMouseAction('right_click');
                },
                onPanUpdate: (details) {
                  int dx = details.delta.dx.round();
                  int dy = details.delta.dy.round();
                  sendMouseEvent('move', dx, dy);
                },
                child: Transform.rotate(
                  angle: -90 * math.pi / 180,
                  child: Container(
                    color: Color.fromARGB(255, 255, 255, 255),
                    // height: 100,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  sendMouseAction('left_click');
                },
                child: Text('Left Click'),
              ),
              ElevatedButton(
                onPressed: () {
                  sendMouseAction('right_click');
                },
                child: Text('Right Click'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
