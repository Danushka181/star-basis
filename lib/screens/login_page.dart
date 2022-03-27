import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_basis/screens/register_page.dart';
import 'package:star_basis/services/auth_services.dart';
import 'package:http/http.dart' as http;

import '../home/home_page.dart';
import '../services/auth_services.dart';
import '../services/globals.dart';
import '../welcome/welcome_header.dart';
import '../widgets/btn_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);



  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String _email = '';
  String _password = '';
  String token = '';

  loginAccountPressed() async {
    bool emailValid   = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if(emailValid){
      http.Response response = await AuthServices.login( _email, _password);
      Map responseMap = jsonDecode(response.body);
      if(response.statusCode == 200){
        // logged in user name
        final String userName;
        final String _token;
        final String _userId;

        userName = responseMap['user']['name'];
        _userId = responseMap['user']['id'].toString();
        _token  = responseMap['access_token'];
        // store user token and id
        SharedPreferences storage = await SharedPreferences.getInstance();
        await storage.setString('userid', _userId );
        await storage.setString('token', _token );
        await storage.setString('name', userName );

        //String token = await AuthServices.getToken().then((value) => value) as String; // get saved token
        // route to dashboard here
        Route route = MaterialPageRoute(builder: (context) => const HomePage());
        Navigator.pushReplacement(context, route);

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

      body: Padding(
        padding: const EdgeInsets.fromLTRB(0,0,0,0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Column(
              children: [
                const WelcomeHeader(), // welcome header with logo
                Padding(
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
                )
              ],
            ),
          ),
        ),
      )
      );
  }

}


