import 'dart:convert';

import 'package:http/http.dart' as http;
import 'globals.dart';


class CustomerGroupServices {

  static Future<http.Response> getAllCustomerGroups() async {
    String _token = await getSavedToken();

    // ready data for send to the server
    var url = Uri.parse(base_url + 'customer-groups/'); // api centers
    http.Response response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+_token,
      },
    );
    return response;
  }

  static Future<http.Response> addGroup(groupName,groupDesc,centerId) async {
    String _token = await getSavedToken();
    Map data = {
      "group_name": groupName,
      "group_desc": groupDesc,
      "center_id": centerId,
    };

    // ready data for send to the server
    var body = json.encode(data);
    var url = Uri.parse(base_url + 'customer-groups/create'); // api centers
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+_token,
      },
      body:body,
    );
    return response;

  }



}