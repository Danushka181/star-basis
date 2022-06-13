import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class LabelText extends StatelessWidget {
  final double fontSize;
  final colorCode;
  final fontWeight;
  final String content;

  const LabelText({Key? key, text, this.fontSize=20, required this.content, this.colorCode,this.fontWeight=FontWeight.w600}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        content,
        style: TextStyle(
        fontFamily: 'Inter',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: colorCode,
      ),
      ),
    );
  }
}
