import 'package:flutter/material.dart';

import 'big_text_widget.dart';

class CommonCardFour extends StatelessWidget {

  final String cardHeading;
  final String cardNumber;
  final activeColor;
  final usersCount;
  const CommonCardFour({Key? key, required this.cardHeading, required this.cardNumber, this.activeColor=Colors.white, this.usersCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: const BoxDecoration(
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
            tileColor:activeColor,
            title: Container(
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigTextWidget(content: '#'+cardNumber, fontSize: 22, colorCode: Colors.lightGreen,fontWeight: FontWeight.w400,),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigTextWidget(content: cardHeading,fontSize: 17, colorCode: Colors.black54, fontWeight: FontWeight.w600,),
                      Stack(
                        children: [
                          Positioned(
                            child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: Text(
                              usersCount,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
