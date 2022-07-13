import 'package:flutter/material.dart';
// import 'package:star_basis/screens/login_page.dart';
// import 'package:star_basis/screens/register_page.dart';
import 'package:star_basis/welcome/welcome_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        fontFamily: 'Inter',
        primarySwatch: Colors.blue,
      ),
      home: const WelcomeScreen(),
    );
  }

}

