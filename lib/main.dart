import 'package:flutter/material.dart';
import 'dreamScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // return material app that has a button that navigates to the dream screen
    return MaterialApp(
      home: EnterDreamScreen(),
    );
  }
}
