import 'package:flutter/material.dart';

class ResizedImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isRound;

  const ResizedImage({super.key, required this.imagePath, required this.width, required this.height, this.isRound = false});

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final image = Image.asset(
      imagePath,
      width: width,
      height: height,
      cacheHeight: (height.toInt() * devicePixelRatio.toInt()).round(),
      cacheWidth: (width.toInt() * devicePixelRatio.toInt()).round(),
    );

    return isRound
        ? ClipOval(child: image)
        : image;
  }
}