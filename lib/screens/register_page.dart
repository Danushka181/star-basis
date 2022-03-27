import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_basis/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:star_basis/services/globals.dart';

import '../home/home_page.dart';
import '../widgets/btn_widget.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  String _email = '';
  String _password = '';
  String _name = '';
  String _confirmPassword = '';

  createAccountPressed() async {

    bool emailValid   = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_email);
    if(_password != _confirmPassword){
      errorSnackBar(context, "Passwords not matched");
    }


    if( emailValid ) {
      http.Response response = await AuthServices.register(_name, _email, _password, _confirmPassword);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        successSnackBar(context,'Account is created Please Log in..');
        Route route = MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        errorSnackBar(context, responseMap.values.first[0]);
      }
    }else{
      errorSnackBar(context, "Email address id not valid");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black54, //change your color here
        ),
        elevation: 4,
        title: const Text(
          "Register with Star Basis",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter'
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,

                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Name (Ex : Nadun)",
                  ),
                  onChanged: (value){
                    _name = value;
                  },
                ),
                const SizedBox(
                  height: 30,
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
                  height: 30,
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Confirm Password",
                  ),
                  onChanged: (value){
                    _confirmPassword = value;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ButtonWidget(
                  btnText: "Create an Account",
                  onButtonPres: () => createAccountPressed(),
                ),
                const SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const LoginPage()));
                  },
                  child: const Text(
                    "Already have and account",
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
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
