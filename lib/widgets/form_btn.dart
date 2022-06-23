// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class FormButtons extends StatelessWidget {
  final String btnText;
  final btnColor;
  final btnFontWeight;

  const FormButtons({Key? key, required this.btnText, this.btnColor=Colors.white, this.btnFontWeight=FontWeight.w600}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      color: Colors.lightGreen,
      borderRadius: BorderRadius.circular(30),
      child: MaterialButton(
        minWidth: 320,
        height: 60,
        onPressed: () {  },
        child: Text(
          btnText,
          style:  TextStyle(
            color: btnColor,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: btnFontWeight,
          ),
        ),
      ),
    );
  }
}
