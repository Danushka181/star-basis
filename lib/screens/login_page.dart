import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:star_basis/screens/register_page.dart';
import 'package:star_basis/services/auth_services.dart';
import 'package:http/http.dart' as http;

import '../services/globals.dart';
import '../widgets/btn_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = '';
  String _password = '';

  loginAccountPressed() async {
    bool emailValid   = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if(emailValid){
      http.Response response = await AuthServices.login( _email, _password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode == 200){
        // logged in user name
        final String userName;
        final String _token;
        userName = responseMap['user']['name'];
        _token  = responseMap['access_token'];
        await storage.write(key: 'jwt', value: _token);
        // route to dashboard here

        successSnackBar(context,'Welcome '+userName+ ' Please wait..'); // user logged in user message
      }else{
        errorSnackBar(context, "We don't have user with given details!"); // user name pass invalid message
      }
    }else{
      errorSnackBar(context, "Please enter valid email address!"); // email not valid message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
          title: const Text(
          "Login to Star Basis",
           style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Inter'
            ),
          ),
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,

            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Email Address",
              ),
              onChanged: (value){
                _email = value;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              decoration: const InputDecoration(
                hintText: "Password",
              ),
              onChanged: (value){
                _password = value;
              },
            ),
            const SizedBox(
              height: 40,
            ),
            ButtonWidget(
              btnText: "Login to Star Basis",
              onButtonPres: () => loginAccountPressed(),
            ),
            const SizedBox(
              height: 40,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const RegisterPage()));
              },
              child: const Text(
                "Create an account",
                style: TextStyle(
                  decoration: TextDecoration.underline,
                ),
              ),
            )

          ],
        ),
      ),
      );
  }
}


