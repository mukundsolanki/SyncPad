import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(String) onIPSubmit;

  WelcomeScreen({required this.onIPSubmit});

  @override
  Widget build(BuildContext context) {
    String ipAddress = '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Please enter your computer\'s IP address:',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                ipAddress = value;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'IP Address',
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onIPSubmit(ipAddress);
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
