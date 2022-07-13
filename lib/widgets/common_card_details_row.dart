import 'package:flutter/material.dart';

import 'label_text.dart';

class CommonCardUserRow extends StatelessWidget {
  String rowHeading;
  String rowValue;
  CommonCardUserRow({Key? key, required this.rowHeading, required this.rowValue }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10.0,top: 10.0),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black54.withOpacity(0.04),
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              LabelText(content: rowHeading, fontSize: 14,colorCode: Colors.blueGrey,fontWeight: FontWeight.w400,),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              LabelText(content: rowValue, fontSize: 20, colorCode: Colors.black,fontWeight: FontWeight.w700),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
