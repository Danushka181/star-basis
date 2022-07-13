import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


const String base_url = "http://10.0.2.2:8000/api/";
// const String base_url = "https://reqres.in/api/";
// const String base_url = "http://aaf3-2402-4000-2380-c5a6-8b2-d08d-4cef-d817.ngrok.io/api/";


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

getSavedToken() async {
  SharedPreferences storage = await SharedPreferences.getInstance();
  String? _token = storage.getString('token');
  return _token;
}

showAlertDialog(BuildContext context, String text){
  AlertDialog alert=AlertDialog(
    content: Row(
      children: [
        const SizedBox(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.greenAccent,
          ),
          width: 30,
          height: 30,
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