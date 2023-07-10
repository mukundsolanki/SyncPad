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
      'http://${widget.ipAddress}:6969',
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
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('SyncPad'),
        actions: [
          IconButton(
            onPressed: disconnect,
            icon: const Icon(Icons.logout),
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
                child: const Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Opacity(
                        opacity: 0.26,
                        child: Icon(
                          Icons.rounded_corner,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Opacity(
                        opacity: 0.26,
                        child: Icon(
                          Icons.rounded_corner,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      child: Opacity(
                        opacity: 0.26,
                        child: Icon(
                          Icons.rounded_corner,
                          size: 24,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Opacity(
                        opacity: 0.26,
                        child: Icon(
                          Icons.rounded_corner,
                          size: 24,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.26,
                            child: Icon(
                              Icons.touch_app,
                              size: 50,
                            ),
                          ),
                          Text(
                            'TOUCHPAD!',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text('Left Click'),
              ),
              ElevatedButton(
                onPressed: () {
                  sendMouseAction('right_click');
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                child: const Text('Right Click'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
