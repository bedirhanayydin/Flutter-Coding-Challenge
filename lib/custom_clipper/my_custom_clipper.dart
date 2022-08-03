import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    /* path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height-60, size.width/2, size.height-30);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-40);
    path.lineTo(size.width, 0);*/
    double radius = 20.0;

    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - 40, size.height);
    path.lineTo(size.width - 40, 60);
    // path.quadraticBezierTo(size.width - 40, 40, size.width - 60, 40);
    path.arcToPoint(
      Offset(size.width - 60, 40),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(60, 40);
    path.arcToPoint(
      const Offset(40, 60),
      radius: Radius.circular(radius),
      clockwise: false,
    );
    path.lineTo(40, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(MyCustomClipper oldClipper) => true;
}
