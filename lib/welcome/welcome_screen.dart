import 'package:flutter/material.dart';
import 'package:star_basis/welcome/welcome_page_body.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: WelcomePageBody(),
    );
  }
}
