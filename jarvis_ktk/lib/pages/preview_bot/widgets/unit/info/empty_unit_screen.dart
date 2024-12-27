import 'package:flutter/material.dart';
import 'package:jarvis_ktk/utils/resized_image.dart';

import '../../../../../utils/colors.dart';

class EmptyUnitScreen extends StatelessWidget {
  const EmptyUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResizedImage(imagePath: 'assets/empty_box.png', width: 100, height: 100),
            SizedBox(height: 8),
            Text(
              "No Data",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Add a Unit to store your data",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: SimpleColors.deepSkyBlue),
            ),
          ],
        ),
      ),
    );
  }
}
