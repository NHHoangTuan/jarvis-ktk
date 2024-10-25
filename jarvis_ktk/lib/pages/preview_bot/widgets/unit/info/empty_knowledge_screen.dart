import 'package:flutter/material.dart';

import '../../../../../utils/colors.dart';

class EmptyKnowledgeScreen extends StatelessWidget {
  const EmptyKnowledgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/empty_box.png', width: 100, height: 100),
            const SizedBox(height: 8),
            const Text(
              "No Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Add a unit to store you data",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: SimpleColors.deepSkyBlue),
            ),
          ],
        ),
      ),
    );
  }
}
