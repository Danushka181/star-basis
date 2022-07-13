import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'big_text_widget.dart';


class SingleHeaderCard extends StatelessWidget {
  String smallHeading;
  String headerLargeText;
  String phoneNumber;
  String nameHeading;

  SingleHeaderCard({Key? key, required this.headerLargeText, required this.nameHeading, required this.phoneNumber, required this.smallHeading}) : super(key: key);

  _launchCaller(String phoneNumber) async {
    var callTo = "tel:"+phoneNumber;
    if (await canLaunch(callTo)) {
      await launch(callTo);
    } else {
      throw 'Could not launch $callTo';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      height: 250,
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
                      '#'+headerLargeText,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 63,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 15 ,),
                    BigTextWidget(
                      content: nameHeading,
                      fontWeight: FontWeight.w700,
                      fontSize: 26,
                      colorCode: Colors.white,
                    ),
                  ],
                ),
              ),
          ),
          Positioned(
            child: FloatingActionButton(
              elevation: 4,
              child:const Icon(Icons.call,color: Colors.green), //child widget inside this button
              backgroundColor: Colors.white,
              onPressed: () {
                _launchCaller(phoneNumber);
              }
            ),
            bottom: 20,
            right: 20,
          ),
        ],
      ),
    );
  }
}
