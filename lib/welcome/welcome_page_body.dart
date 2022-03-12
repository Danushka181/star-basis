import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:star_basis/welcome/welcome_header.dart';

import '../screens/login_page.dart';
import '../widgets/big_text_widget.dart';
import '../widgets/btn_widget.dart';


class WelcomePageBody extends StatelessWidget {
  const WelcomePageBody({Key? key}) : super(key: key);

  loginBtnPressed(context) {
    // Route route = MaterialPageRoute(builder: (context) => const LoginPage());
    // Navigator.pushReplacement(context, route);
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const LoginPage()));
    // Navigator.pushReplacementNamed(context, LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
     children: <Widget>[
       const WelcomeHeader(),
       const SizedBox(
         height: 60,
       ),
       const BigTextWidget(content: 'Hello!', fontSize: 30,colorCode: Colors.green,),
       const SizedBox(
         height: 10,
       ),
       const BigTextWidget(content: 'wellcome to starbasis portal', fontSize: 18,colorCode: Colors.blueGrey,fontWeight: FontWeight.w400,),
       const SizedBox(
        height: 100,
       ),
       ButtonWidget(onButtonPres:() => loginBtnPressed(context),btnText: 'Log in',),
       const SizedBox(
         height: 20,
       ),
       ButtonWidget(onButtonPres:() => null,btnText: 'Create an Account',btnFontWeight: FontWeight.w400,),
     ]
    );
  }


}
