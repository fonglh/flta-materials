import 'package:flutter/material.dart';

class CircleImage extends StatelessWidget {
  // CircleImage takes imageProvider and imageRadius as params
  const CircleImage({
    Key? key,
    this.imageProvider,
    this.imageRadius = 20,
  }) : super(key: key);

  // Property declarations for the 2 params
  final double imageRadius;
  final ImageProvider? imageProvider;

  @override
  Widget build(BuildContext context) {
    // CircleAvatar is from the Material library.
    return CircleAvatar(
      backgroundColor: Colors.white,
      radius: imageRadius,
      // Inside the outer circle is another CircleAvatar with the image,
      // the smaller radius gives the white border effect
      child: CircleAvatar(
        radius: imageRadius - 5,
        backgroundImage: imageProvider,
      ),
    );
  }
}
