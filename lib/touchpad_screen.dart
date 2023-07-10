import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'main.dart';

class TouchpadScreen extends StatefulWidget {
  final String ipAddress;

  TouchpadScreen({required this.ipAddress});

  @override
  _TouchpadScreenState createState() => _TouchpadScreenState();
}

class _TouchpadScreenState extends State<TouchpadScreen> {
  late IO.Socket socket;
  final double tapMaxDistance =
      20; // Maximum distance in pixels for a tap to be considered

  Offset? tapPosition;
  bool isDoubleTap = false;

  void disconnect() {
    socket.disconnect();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => MouseControllerApp(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  void connectToServer() {
    socket = IO.io(
      'http://${widget.ipAddress}:3000',
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
        actions: [
          IconButton(
            onPressed: disconnect,
            icon: Icon(Icons.logout),
          ),
        ],
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
          ),
        ],
      ),
    );
  }
}
