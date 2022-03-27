import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_basis/home/home_page.dart';
import 'package:star_basis/screens/login_page.dart';
import 'package:star_basis/welcome/welcome_page_body.dart';
import 'package:http/http.dart' as http;

import '../services/auth_services.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  late bool isLoading = false;
  late int _userId;
  late String _token;

  _getUserData() async {
    SharedPreferences storage = await SharedPreferences.getInstance();
    String? _token = storage.getString('token');
    if(_token != null){
      http.Response response = await AuthServices.refresh(_token);
      print(response.body);
      if( response.statusCode == 200){
        Map responseMap = jsonDecode(response.body);
        _token  = responseMap['access_token'];
        SharedPreferences storage = await SharedPreferences.getInstance();
        await storage.setString('token', _token! );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const HomePage()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginPage()));
      }
    } else {
      //   // User user = await auth.me();
      //   // _nameController.text = user.name;
      //   // _emailController.text = user.email;
      //   // _userId = user.id;
    }

  }

  @override
  @protected
  @mustCallSuper
  void initState() {
    _getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            padding: EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: WelcomePageBody(),
            )
        )
    );
  }
}
