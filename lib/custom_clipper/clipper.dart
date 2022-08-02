import 'package:flutter/material.dart';

import 'my_custom_clipper.dart';

class Clipper extends StatelessWidget {
  const Clipper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clipper'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 100,
            left: 100,
            right: 100,
            child: ClipPath(
              clipper: MyCustomClipper(),
              child: Container(
                color: const Color.fromARGB(255, 150, 5, 0),
                height: 300.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
