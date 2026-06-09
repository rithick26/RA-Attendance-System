import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About")),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              const Icon(Icons.school, size: 100, color: Color(0xFF2563EB)),

              const SizedBox(height: 20),

              const Text(
                "Robotics and Automation\nAttendance Monitoring System",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 30),

              const Text("Version 1.0", style: TextStyle(fontSize: 18)),

              const SizedBox(height: 20),

              const Text(
                "Developed By",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text("Rithick P", style: TextStyle(fontSize: 20)),

              const Text("71812310045", style: TextStyle(fontSize: 18)),

              const Text(
                "B.E Robotics and Automation",
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 30),

              const Text(
                "Sri Ramakrishna Engineering College",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
