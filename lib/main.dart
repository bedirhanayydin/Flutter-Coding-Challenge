import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/view_model/detail_view_model.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';

import 'view/home_view.dart';
import 'view_model/home_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(
          create: (_) => HomeProvider(),
        ),
        ChangeNotifierProvider<DetailProvider>(
          create: (_) => DetailProvider(),
        ),
      ],
      child: GetMaterialApp(
        title: 'Flutter Coding Challenge',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
