
import 'package:flutter/material.dart';

import 'big_text_widget.dart';

class CommonCardOne extends StatelessWidget {
  final String cardHeading;
  final String cardSubHeading;
  final IconData iconName;

  const CommonCardOne({Key? key, required this.cardHeading, required this.cardSubHeading, required this.iconName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 20,right: 20, top: 20, bottom: 5),
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shadowColor: Colors.blueGrey,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
              Radius.circular(15)
          )
      ),
      child: Padding(
        padding: const EdgeInsets.only(left:5,top: 10,right:5, bottom: 10,),
        child: ListTile(
          leading: Icon(
            iconName,
            color: Colors.lightGreen,
            size: 45,
          ),
          title: BigTextWidget(content: cardHeading,fontSize: 20, colorCode: Colors.black54, fontWeight: FontWeight.w600,),
          subtitle: Text(
            cardSubHeading,
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.blueGrey,
          ),
        ),
      ),
    );
  }

}
