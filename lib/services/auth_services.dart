import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

class AuthServices {
  // this is login Auth service

  // register request
  static Future<http.Response> register(String name, String email,
      String password, String confirmPassword) async {
      // ready data for send to the server
      Map data = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword
      };
      var body = json.encode(data);
      var url = Uri.parse(base_url + 'auth/register'); // api register URL
      http.Response response = await http.post(
          url,
          headers: headers,
          body: body
      );
    return response;
  }

  // login request
  static Future<http.Response> login(String email, String password) async {
    // ready data for send to the server
    Map data = {
      "email": email,
      "password": password,
    };

    var body = json.encode(data);
    var url = Uri.parse(base_url + 'auth/login'); // api register URL
    http.Response response = await http.post(
        url,
        headers: headers,
        body: body
    );
    // print(_getToken());
    return response;
  }

  // refresh token
  static Future<http.Response> refresh(String token) async {
    Map data = {
      "token": token
    };
    // ready data for send to the server
    var body = json.encode(data);
    var url = Uri.parse(base_url + 'auth/refresh'); // api refresh token
    http.Response response = await http.post(
        url,
        headers: headers,
        body:body
    );
    return response;
  }

}