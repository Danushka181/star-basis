import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BigTextWidget extends StatelessWidget {

  final String content;
  final double fontSize;
  final colorCode;
  final fontWeight;

  const BigTextWidget({Key? key, text, this.fontSize=20, required this.content, this.colorCode,this.fontWeight=FontWeight.w600}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
        content.length > 35 ? content.substring(0, 35)+'...' : content,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: colorCode,
        )
    );

  }
}
