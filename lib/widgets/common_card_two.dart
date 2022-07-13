import 'package:flutter/material.dart';

import 'big_text_widget.dart';

class CommonCardTwo extends StatelessWidget {

  final String cardHeading;
  final String cardSubHeading;
  final String loanAmount;

  const CommonCardTwo({Key? key, required this.cardHeading, required this.cardSubHeading, required this.loanAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
          ),
        ),
      ),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        child: ListTile(
          selectedColor: Colors.lightGreen.withOpacity(0.1),
          title: Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BigTextWidget(content: '#24', fontSize: 22, colorCode: Colors.lightGreen,fontWeight: FontWeight.w400,),
                    BigTextWidget(content: '2021-02-06', fontSize: 12, colorCode: Colors.black54.withOpacity(0.5), fontWeight: FontWeight.w500,),
                  ],
                ),
                //loan owner
                Row(
                  children: [
                    BigTextWidget(content: cardHeading,fontSize: 17, colorCode: Colors.black54, fontWeight: FontWeight.w600,)
                  ],
                )
              ],
            ),
          ),
          subtitle: Container(
            margin: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    strutStyle: const StrutStyle(fontSize: 10),
                    text: TextSpan(
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.4),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                        text: cardSubHeading),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 4,bottom: 4,left: 8, right: 8),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    loanAmount+' /=',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,

                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.blueGrey.withOpacity(0.5),
          ),
        ),
      )
    );
  }
}
