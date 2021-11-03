import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:yoko_test/screens/activity_page.dart';
import 'package:yoko_test/screens/auth_page.dart';
void main() async{
  await Hive.initFlutter();
  await Hive.openBox('tokens');
  runApp(YokoApp());
}

class YokoApp extends StatelessWidget {
  const YokoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthPage(),
    );
  }
}