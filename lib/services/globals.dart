import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// const String base_url = "http://10.0.2.2:8000/api/";
// const String base_url = "https://reqres.in/api/";
const String base_url = "http://25f1-116-206-246-110.ngrok.io/api/";


const Map<String, String> headers = {"Content-Type": "Application/json"};


//Error snack bar for show errors
errorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(text),
        duration: const Duration(seconds: 3),
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
