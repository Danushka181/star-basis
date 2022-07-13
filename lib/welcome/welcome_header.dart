import 'package:flutter/material.dart';


class WelcomeHeader extends StatelessWidget {
  const WelcomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.4,
      width: size.width,
      padding: const EdgeInsets.only(
        left: 40,
        right: 40,
        bottom: 65,
        top: 65,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40)
        ),
        image: DecorationImage(
            image: AssetImage("assets/images/pngegg.png"),
            fit: BoxFit.cover,
            opacity: 0.5
        ),
        color: Colors.lightGreen,
        boxShadow: [
          BoxShadow(
              color: Colors.lightGreen,
              blurRadius: 25.0,
              offset: Offset(0.0, 0.75)
          )
        ],
      ),

      child: Container(
        alignment: AlignmentDirectional.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Star-basis.png"),
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
