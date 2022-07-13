import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(
              color: Colors.lightGreen,
              strokeWidth: 4,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Loading..',
              style: TextStyle(
                color: Colors.black54,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.w500,
                fontSize: 16
              ),
            ),
          ],
        ),
      ),
    );
  }
}
