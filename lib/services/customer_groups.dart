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

}