import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:star_basis/services/auth_services.dart';
import 'package:http/http.dart' as http;
import 'package:star_basis/services/globals.dart';

import '../widgets/app_bar.dart';
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
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  _validateEMailAddress(String email) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  // Create account button pressed
  createAccountPressed() async {
    try{
      http.Response response = await AuthServices.register(_name, _email, _password, _confirmPassword);
      Map responseMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        successSnackBar(context,'Account is created Please Log in..');
        Route route = MaterialPageRoute(builder: (context) => const LoginPage());
        Navigator.pushReplacement(context, route);
      } else {
        Navigator.pop(context);
        errorSnackBar(context, responseMap.values.first[0]);
      }
    } on SocketException {
      errorSnackBar(context, "No internet connection!");
      Navigator.pop(context);
    } on HttpException {
      errorSnackBar(context, "There is a problem when connecting to server!");
      Navigator.pop(context);
    } on FormatException {
      errorSnackBar(context, "Can't reach the server at the moment");
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: 'Register'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,

                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Name (Ex : Nadun)",
                    ),
                    onChanged: (value){
                      _name = value;
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Name is required please enter';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Email Address",
                    ),
                    onChanged: (value){
                      _email = value;
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Email is required please enter';
                      }
                      if(!_validateEMailAddress(_email)){
                        return 'Email Address is not valid Email';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password",
                    ),
                    onChanged: (value){
                      _password = value;
                    },
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Password is required please enter';
                      }
                      if(value!.length < 6) {
                        return 'Password must be more than 6 characters';
                      }
                      return null;
                    }
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Confirm Password",
                    ),
                    onChanged: (value){
                      _confirmPassword = value;
                    },
                    validator: (value) {
                      if( _password.isNotEmpty ) {
                        if (value != null && value.isEmpty) {
                          return 'Conform password is required please enter';
                        }
                        if (value != _password) {
                          return 'Confirm password not matching';
                        }
                        if (value!.length < 6) {
                          return 'Password must be more than 6 characters';
                        }
                      }
                      return null;
                    }
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ButtonWidget(
                    btnText: "Create an Account",
                    onButtonPres: () => {
                      if (_formKey.currentState!.validate()) {
                        showAlertDialog(context,'Creating account..'),
                        createAccountPressed()
                      }
                    },
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
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
