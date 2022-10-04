import 'package:flutter/material.dart';



class CustomPageHeading extends StatelessWidget {
  String smallHeading;
  String headerLargeText;

  CustomPageHeading({Key? key, required this.headerLargeText, required this.smallHeading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      height: 150,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.topLeft,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            "assets/images/pngegg.png",
            alignment: Alignment.centerRight,
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
          ), //This // should be a paged
          Positioned(
            top: 50,
            left: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 0,bottom: 0,left: 30,right: 50),
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    smallHeading,
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    headerLargeText,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 0,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 15 ,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
