import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// const String base_url = "http://10.0.2.2:8000/api/";
const String base_url = "https://app.starbasis.lk/api/";
// const String base_url = "https://58cd-2402-4000-2380-2c85-3955-6960-70fc-b0e2.ngrok.io/api/";

const Map<String, String> headers = {"Content-Type": "Application/json"};

//Error snack bar for show errors
errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(text),
        duration: const Duration(seconds: 4),
      )
  );
}
//Notify snack bar for show errors
notifySnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(text),
        duration: const Duration(seconds: 4),
      )
  );
}

//Error snack bar for show errors
successSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(text),
        duration: const Duration(seconds: 4),
      )
  );
}

infoMessage(String msg,Color bgColor){
  return(
    Container(
      padding: const EdgeInsets.symmetric(vertical: 50,horizontal: 20),
      decoration: BoxDecoration(
        color: bgColor
      ),
      child: Text(msg,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 17,
          fontFamily: 'Inter',
          color: Colors.white,
        ),
      ),
    )
  );
}


getSavedToken() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String? token = storage.getString('token');
  return token;
}

getCurrentUserId() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String? currentId = storage.getString('userid');
  return currentId;
}

showAlertDialog(BuildContext context, String text){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
        const SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.greenAccent,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],),
    );
    showDialog(barrierDismissible: false,
    context:context,
    builder:(BuildContext context){
      return alert;
    },
  );
}