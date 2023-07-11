import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(String) onIPSubmit;

  const WelcomeScreen({super.key, required this.onIPSubmit});

  @override
  Widget build(BuildContext context) {
    String ipAddress = '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Center(
          child: Text(
            'SyncPad',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 65, 227, 168),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Colors.grey[900]!],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text.rich(
                        TextSpan(
                          text: 'Welcome to ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'SyncPad',
                              style: TextStyle(
                                color: Color.fromARGB(255, 65, 227, 168),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            ipAddress = value;
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            labelText: 'Enter your IP Address',
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30,
                        child: IconButton(
                          onPressed: () {
                            onIPSubmit(ipAddress);
                          },
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '© Mukund Solanki',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
