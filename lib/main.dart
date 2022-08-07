import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:user_app/view/SplashScreen.dart';

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '9|mm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}