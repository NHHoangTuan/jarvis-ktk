import 'package:flutter/material.dart';

class CommandCard extends StatelessWidget {
  final String command;
  final String description;
  final VoidCallback onTap;

  CommandCard({
    required this.command,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue[100],
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(command, style: TextStyle(fontSize: 18)),
              Text(description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}
