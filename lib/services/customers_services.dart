
import 'package:http/http.dart' as http;
import 'globals.dart';

class CustomersService {

  /* all Customers */
  static Future<http.Response> allCustomers() async {
    String _token = await getSavedToken();

    // ready data for send to the server
    var url = Uri.parse(base_url + 'customers/'); // api centers
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

  static Future<http.Response> singleCustomer(String id ) async {
    String _token = await getSavedToken();
    var url = Uri.parse(base_url + 'customers/show/'+id);
    http.Response response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer '+_token,
      },
    );
    return response;
  }

  //
  // static Future<http.Response> addCenters(centerName,centerAddress) async {
  //   String _token = await getSavedToken();
  //   Map data = {
  //     "center_name": centerName,
  //     "center_address": centerAddress,
  //   };
  //
  //   // ready data for send to the server
  //   var body = json.encode(data);
  //   var url = Uri.parse(base_url + 'centers/add-center'); // api centers
  //   http.Response response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer '+_token,
  //     },
  //     body:body,
  //   );
  //   return response;
  //
  // }
  //
  // static Future<http.Response> deleteCenters(centerId) async {
  //   String _token = await getSavedToken();
  //   Map data = {};
  //
  //   // ready data for send to the server
  //   var body = json.encode(data);
  //   var url = Uri.parse(base_url + 'centers/delete-center/'+centerId); // api centers
  //   http.Response response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Accept': 'application/json',
  //       'Authorization': 'Bearer '+_token,
  //     },
  //     body:body,
  //   );
  //   return response;
  //
  // }
}
